import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/letter_paper_painter.dart';
import 'package:frontend/core/utils/library/topic_bubble_widget.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/domains/diary/provider/write_diary_provider.dart';
import 'package:frontend/domains/font/provider/font_provider.dart';
import 'package:frontend/res/constants.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/components/toast.dart';
import 'package:frontend/ui/components/weather_emotion_badge_writing_diary.dart';
import 'package:frontend/ui/screen/diary/write_diary_loading_screen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rive/rive.dart';

class WriteDiaryScreen extends ConsumerStatefulWidget {
  final DateTime date;
  final String emotion;
  final String weather;
  final DiaryDetailData? diaryData;
  final bool isEditScreen;

  final bool isAutoSave;

  WriteDiaryScreen({
    Key? key,
    required this.date,
    required this.emotion,
    required this.weather,
    required this.isEditScreen,
    this.diaryData,
    required this.isAutoSave,
  }) : super(key: key);

  @override
  WriteDiaryScreenState createState() => WriteDiaryScreenState();
}

class WriteDiaryScreenState extends ConsumerState<WriteDiaryScreen> with SingleTickerProviderStateMixin {
  Timer? _autoSaveTimer;

  XFile? pickedFile;
  CroppedFile? croppedFile;

  late WriteDiaryNotifier writeDiaryNotifier;
  late DiaryNotifier diaryNotifier;
  late DateTime screenEntryTime;

  @override
  void initState() {
    super.initState();

    writeDiaryNotifier = ref.read(writeDiaryProvider.notifier);
    diaryNotifier = ref.read(diaryProvider.notifier);
    screenEntryTime = ref.read(screenEntryTimeProvider);

    _autoSaveTimer = Timer.periodic(Duration(seconds: 3), (Timer t) => _autoSaveDiary());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(writeDiaryProvider.notifier).setRandomImageNumber(Random().nextInt(7) + 1);
      ref.watch(animationControllerProvider.notifier).state = AnimationController(vsync: this);
      ref.watch(writeDiaryProvider.notifier).diaryEditingController.addListener(ref.watch(writeDiaryProvider.notifier).onTextChanged);

      ref.watch(writeDiaryProvider.notifier).getDefaultTopic(widget.emotion);

      if (widget.diaryData != null) {
        ref.watch(writeDiaryProvider.notifier).setDiaryData(widget.diaryData!);
      } else {
        ref.watch(writeDiaryProvider.notifier).diaryEditingController.text = "";
        ref.watch(writeDiaryProvider.notifier).state = ref.watch(writeDiaryProvider.notifier).state.copyWith(diaryValueLength: 0);
      }
    });
  }

  Future<void> _autoSaveDiary() async {
    String currentText = ref.watch(writeDiaryProvider.notifier).diaryEditingController.text;
    if (currentText.isNotEmpty) {
      DiaryDetailData diary = DiaryDetailData(
        id: widget.diaryData?.id,
        diaryContent: ref.watch(writeDiaryProvider.notifier).diaryEditingController.text,
        feeling: widget.emotion,
        feelingScore: 1,
        weather: widget.weather,
        targetDate: DateFormat('yyyy-MM-dd').format(widget.date),
        topic: ref.watch(writeDiaryProvider).topic.value,
        image: ref.watch(writeDiaryProvider).firebaseImageUrl == "" ? ref.watch(diaryProvider).diaryDetailData?.image ?? "" : ref.watch(writeDiaryProvider).firebaseImageUrl,
        isAutoSave: true,
      );

      ref.watch(diaryProvider.notifier).saveDiary(DateFormat('yyyy-MM-dd').format(widget.date), diary);
    }
  }

  Future<void> cropImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedImage != null) {
      pickedFile = pickedImage;
    }

    final bytes = await pickedFile!.readAsBytes();

    final kb = bytes.lengthInBytes / 1024;
    final directory = await getApplicationDocumentsDirectory();

    if (kb > 200) {
      ref.watch(cropQualityImageProvider.notifier).state = await FlutterImageCompress.compressAndGetFile(
        pickedFile!.path,
        '${directory.path}/haruKitty.jpg',
        quality: 20,
      );
    } else {
      ref.watch(cropQualityImageProvider.notifier).state = await FlutterImageCompress.compressAndGetFile(
        pickedFile!.path,
        '${directory.path}/haruKitty.jpg',
        quality: 100,
      );
    }
    if (pickedFile != null) {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: ref.watch(cropQualityImageProvider)!.path,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '이미지 자르기',
            toolbarColor: kOrange200Color,
            toolbarWidgetColor: kWhiteColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: '이미지 자르기',
          ),
        ],
      );
      setState(() {
        if (croppedImage != null) {
          croppedFile = croppedImage;
        }
      });
    }
  }

  Future<void> uploadImage() async {
    final socialId = await tokenUseCase.getSocialId();

    File file = File(croppedFile!.path);

    try {
      // Use the user's UID and the current timestamp to create a unique path for each image.
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      await FirebaseStorage.instance.ref('uploads/$socialId/$timestamp.png').putFile(file);

      String downloadURL = await FirebaseStorage.instance.ref('uploads/$socialId/$timestamp.png').getDownloadURL();

      await ref.read(diaryProvider.notifier).postImageHistory(downloadURL);

      ref.read(writeDiaryProvider.notifier).state = ref.read(writeDiaryProvider).copyWith(firebaseImageUrl: downloadURL);
    } on FirebaseException {
      // Get.snackbar('알림', '이미지 업로드에 실패하였습니다.');
      // e.g, e.code == 'canceled'
    }
  }

  Future<void> clear() async {
    setState(() {
      pickedFile = null;
      croppedFile = null;
    });

    if (mounted) {
      writeDiaryNotifier.state = ref.read(writeDiaryProvider).copyWith(networkImage: null);
    }
    await Future.delayed(Duration.zero);
    diaryNotifier.setDiaryDetailData(ref.read(diaryProvider).diaryDetailData?.copyWith(image: ""));
  }

  @override
  Future<void> dispose() async {
    _autoSaveTimer?.cancel();
    writeDiaryNotifier.diaryEditingController.removeListener(writeDiaryNotifier.onTextChanged);

    DateTime screenExitTime = DateTime.now();
    Duration stayDuration = screenExitTime.difference(screenEntryTime);

    Future(() {
      diaryNotifier.loadDiary(widget.date);
      writeDiaryNotifier.resetFirebaseImageUrl();
    });

    // Firebase Analytics에 체류시간 로깅
    GlobalUtils.setAnalyticsCustomEvent('stay_duration', {
      'screen': "Screen_Event_WriteDiary_WritePage",
      'duration': stayDuration.inSeconds,
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> handleBackButton() async {
      if (ref.watch(writeDiaryProvider.notifier).diaryEditingController.text.isEmpty) {
        Navigator.pop(context);
        FocusManager.instance.primaryFocus?.unfocus();
        return true;
      } else if (widget.diaryData?.diaryContent != ref.watch(writeDiaryProvider.notifier).diaryEditingController.text) {
        await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (ctx) => _buildDialog(
            context,
            title: "뒤로 가시겠어요?",
            content: "변경된 내용이 있어요.",
          ),
        );
        return false;
      } else if (ref.watch(writeDiaryProvider.notifier).diaryEditingController.text.isNotEmpty) {
        await showDialog(
          barrierDismissible: true,
          context: context,
          builder: (ctx) => _buildDialog(
            context,
            title: "뒤로 가시겠어요?",
            content: "작성 중인 모든 내용이 삭제되어요.",
          ),
        );
        return false;
      }

      return true;
    }

    final fontState = ref.watch(fontProvider);
    final fontNotifier = ref.watch(fontProvider.notifier);

    return DefaultLayout(
      screenName: 'Screen_Event_WriteDiary_WritePage',
      child: WillPopScope(
        onWillPop: handleBackButton,
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              actions: [
                Consumer(builder: (context, ref, child) {
                  return TextButton(
                    onPressed: ref.watch(writeDiaryProvider).diaryValue.isEmpty
                        ? null
                        : () async {
                            GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Register');
                            if (croppedFile != null) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                    onWillPop: () async => false,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      child: Lottie.asset(
                                        'lib/config/assets/lottie/loading_haru.json',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },
                              );

                              try {
                                await uploadImage();
                                // ignore: use_build_context_synchronously
                                Navigator.of(context, rootNavigator: true).pop();
                              } catch (e) {
                                Navigator.of(context, rootNavigator: true).pop();
                              }
                            }

                            if (mounted) {
                              FocusManager.instance.primaryFocus?.unfocus();

                              _autoSaveTimer?.cancel();

                              ref.watch(writeDiaryProvider.notifier).diaryEditingController.removeListener(ref.watch(writeDiaryProvider.notifier).onTextChanged);

                              Future(() {
                                ref.watch(diaryProvider.notifier).getEmotionStampList();
                              });

                              DateTime screenExitTime = DateTime.now();
                              Duration stayDuration = screenExitTime.difference(ref.watch(screenEntryTimeProvider));

                              // Firebase Analytics에 체류시간 로깅
                              GlobalUtils.setAnalyticsCustomEvent('stay_duration', {
                                'screen': "Screen_Event_WriteDiary_WritePage",
                                'duration': stayDuration.inSeconds,
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WriteDiaryLoadingScreen(
                                    diaryData: DiaryDetailData(
                                        id: widget.diaryData?.id,
                                        diaryContent: ref.watch(writeDiaryProvider.notifier).diaryEditingController.text,
                                        feeling: widget.emotion,
                                        feelingScore: 1,
                                        weather: widget.weather,
                                        targetDate: DateFormat('yyyy-MM-dd').format(widget.date),
                                        topic: ref.watch(writeDiaryProvider).topic.value,
                                        image: ref.watch(writeDiaryProvider).firebaseImageUrl == ""
                                            ? ref.watch(diaryProvider).diaryDetailData?.image ?? ""
                                            : ref.watch(writeDiaryProvider).firebaseImageUrl),
                                    date: widget.date,
                                    isEditScreen: widget.isEditScreen,
                                  ),
                                ),
                              );
                            }
                          },
                    child: Text(
                      '등록',
                      style:
                          ref.watch(writeDiaryProvider).diaryValue.isEmpty ? kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textDisabled) : kHeader6Style.copyWith(color: kOrange350Color),
                    ),
                  );
                }),
              ],
              title: Text(
                DateFormat('M월 d일').format(widget.date),
                style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
              ),
              leading: BackIcon(
                onPressed: handleBackButton,
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Get_Topic');
                                ref.watch(writeDiaryProvider.notifier).getRandomTopic();
                              },
                              child: TopicBubbleWidget(
                                color: Theme.of(context).colorScheme.secondaryColor,
                                text: Consumer(builder: (context, ref, child) {
                                  return Text(
                                    textAlign: TextAlign.center,
                                    ref.watch(writeDiaryProvider).topic.value,
                                    style: fontNotifier.getFontStyle().copyWith(
                                          color: Theme.of(context).colorScheme.textTitle,
                                          fontSize: fontState.selectedFontDefaultSize - 2,
                                          height: 1,
                                        ),
                                  );
                                }),
                                onDelete: () {},
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 164,
                          child: Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  getWeatherCharacter(widget.weather),
                                  height: 140,
                                ),
                              ),
                              getWeatherAnimation(widget.weather) == ""
                                  ? Container()
                                  : RiveAnimation.asset(
                                      getWeatherAnimation(widget.weather),
                                      fit: BoxFit.fill,
                                    ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              color: Theme.of(context).colorScheme.surface_01,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      height: 72.0,
                                      child: WeatherEmotionBadgeWritingDiary(
                                        emoticon: getEmoticonImage(widget.emotion),
                                        emoticonDesc: getEmoticonValue(widget.emotion),
                                        weatherIcon: getWeatherChipImage(widget.weather),
                                        weatherIconDesc: getWeatherValue(widget.weather),
                                        color: Theme.of(context).colorScheme.letterBackgroundLineColor,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 70,
                                    child: Consumer(builder: (context, ref, child) {
                                      return ref.watch(diaryProvider).diaryDetailData == null
                                          ? Container()
                                          : ref.watch(diaryProvider).diaryDetailData!.image == ''
                                              ? Container()
                                              : Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          color: kImageBackgroundColor,
                                                          width: 260,
                                                          height: 260,
                                                          child: Image.network(
                                                            ref.watch(diaryProvider).diaryDetailData!.image!,
                                                            width: 260,
                                                            height: 260,
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: 12,
                                                          top: 12,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              clear();
                                                            },
                                                            child: Container(
                                                              margin: const EdgeInsets.all(6),
                                                              decoration: BoxDecoration(
                                                                color: kWhiteColor.withOpacity(0.6),
                                                                shape: BoxShape.circle,
                                                              ),
                                                              height: 24.h,
                                                              width: 24.w,
                                                              child: SvgPicture.asset(
                                                                "lib/config/assets/images/diary/light_mode/close.svg",
                                                                color: kGrayColor950,
                                                                height: 12,
                                                                width: 12,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                    }),
                                  ),
                                  Positioned(
                                    top: 70,
                                    child: Consumer(builder: (context, ref, child) {
                                      return (croppedFile != null || pickedFile != null || ref.watch(writeDiaryProvider).networkImage != null)
                                          ? Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                                child: ref.watch(writeDiaryProvider).networkImage != null
                                                    ? Stack(
                                                        children: [
                                                          Container(
                                                            color: kImageBackgroundColor,
                                                            width: MediaQuery.of(context).size.width - 100,
                                                            height: MediaQuery.of(context).size.width - 100,
                                                            child: Image.network(
                                                              ref.watch(writeDiaryProvider).networkImage!,
                                                              width: MediaQuery.of(context).size.width - 100,
                                                              height: MediaQuery.of(context).size.width - 100,
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: 12,
                                                            top: 12,
                                                            child: GestureDetector(
                                                              onTap: () async {
                                                                await clear();
                                                              },
                                                              child: Container(
                                                                margin: const EdgeInsets.all(6),
                                                                decoration: BoxDecoration(
                                                                  color: kWhiteColor.withOpacity(0.6),
                                                                  shape: BoxShape.circle,
                                                                ),
                                                                height: 24.h,
                                                                width: 24.w,
                                                                child: SvgPicture.asset(
                                                                  "lib/config/assets/images/diary/light_mode/close.svg",
                                                                  color: kGrayColor950,
                                                                  height: 12,
                                                                  width: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : croppedFile != null
                                                        ? Stack(
                                                            children: [
                                                              Container(
                                                                color: kImageBackgroundColor,
                                                                width: 260,
                                                                height: 260,
                                                                child: Image.file(
                                                                  File(croppedFile!.path),
                                                                  width: 260,
                                                                  height: 260,
                                                                ),
                                                              ),
                                                              Positioned(
                                                                right: 12,
                                                                top: 12,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    clear();
                                                                  },
                                                                  child: Container(
                                                                    margin: const EdgeInsets.all(6),
                                                                    decoration: BoxDecoration(
                                                                      color: kWhiteColor.withOpacity(0.6),
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    height: 24.h,
                                                                    width: 24.w,
                                                                    child: SvgPicture.asset(
                                                                      "lib/config/assets/images/diary/light_mode/close.svg",
                                                                      color: kGrayColor950,
                                                                      height: 12,
                                                                      width: 12,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : const SizedBox.shrink(),
                                              ),
                                            )
                                          : Container();
                                    }),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: ((croppedFile != null || pickedFile != null || ref.watch(writeDiaryProvider).networkImage != null) ||
                                                (ref.watch(diaryProvider).diaryDetailData != null && ref.watch(diaryProvider).diaryDetailData!.image != ''))
                                            ? 350
                                            : 70,
                                        left: 30,
                                        right: 30),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        minHeight: 500,
                                      ),
                                      child: CustomPaint(
                                        painter: LetterPaperPainter(
                                          color: Theme.of(context).colorScheme.letterBackgroundLineColor,
                                        ),
                                        child: TextField(
                                          maxLength: 500,
                                          maxLines: null,
                                          autofocus: true,
                                          style: fontNotifier.getFontStyle().copyWith(
                                                color: Theme.of(context).colorScheme.textBody,
                                              ),
                                          controller: ref.watch(writeDiaryProvider.notifier).diaryEditingController,
                                          keyboardType: TextInputType.multiline,
                                          textAlignVertical: TextAlignVertical.center,
                                          cursorColor: Theme.of(context).colorScheme.primaryColor,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            helperText: "",
                                            counterText: "",
                                            hintStyle: kBody1Style.copyWith(color: kGrayColor400),
                                            contentPadding: const EdgeInsets.only(
                                              top: 4,
                                            ),
                                            filled: true,
                                            enabledBorder: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          onChanged: (value) {
                                            ref.watch(writeDiaryProvider.notifier).setDiaryValueLength(value.length);
                                            value.length == 500
                                                ? showDialog(
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder: (ctx) {
                                                      return DialogComponent(
                                                        title: "글자 제한",
                                                        content: Text(
                                                          "500 글자까지 작성할 수 있어요.",
                                                          style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                                        ),
                                                        actionContent: [
                                                          DialogButton(
                                                            title: "확인 했어요",
                                                            onTap: () {
                                                              Navigator.pop(context);
                                                            },
                                                            backgroundColor: kOrange200Color,
                                                            textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  )
                                                : null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceModal,
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.border,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Picture');

                                cropImage();
                                // ref.watch(writeDiaryProvider.notifier).selectDeviceImage().then((_) => ref.watch(writeDiaryProvider.notifier).cropImage());
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 16.w),
                                child: SvgPicture.asset(
                                  "lib/config/assets/images/diary/write_diary/album.svg",
                                  color: Theme.of(context).colorScheme.iconSubColor,
                                  // width: 24.w,
                                  // height: 24.h,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Temp_Save');

                                DiaryDetailData diary = DiaryDetailData(
                                  id: widget.diaryData?.id,
                                  diaryContent: ref.watch(writeDiaryProvider.notifier).diaryEditingController.text,
                                  feeling: widget.emotion,
                                  feelingScore: 1,
                                  weather: widget.weather,
                                  targetDate: DateFormat('yyyy-MM-dd').format(widget.date),
                                  topic: ref.watch(writeDiaryProvider).topic.value,
                                  image: ref.watch(writeDiaryProvider).firebaseImageUrl == "" ? ref.watch(diaryProvider).diaryDetailData?.image ?? "" : ref.watch(writeDiaryProvider).firebaseImageUrl,
                                  isAutoSave: true,
                                );

                                ref.watch(diaryProvider.notifier).saveDiary(DateFormat('yyyy-MM-dd').format(widget.date), diary).then((value) {
                                  toast(
                                    context: context,
                                    text: '작성 중인 일기가 임시저장 되었어요.',
                                    isCheckIcon: true,
                                  );
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 16.w),
                                child: Image.asset(
                                  "lib/config/assets/images/diary/write_diary/save-2.png",
                                  color: Theme.of(context).colorScheme.iconSubColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 16.w),
                          child: Row(
                            children: [
                              Consumer(builder: (context, ref, child) {
                                return Text(
                                  "${ref.watch(writeDiaryProvider).diaryValueLength}",
                                  style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                );
                              }),
                              Text(
                                "/500",
                                style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textLowEmphasis),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDialog(BuildContext context, {required String title, required String content}) {
    return DialogComponent(
      title: title,
      content: Text(
        content,
        style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
      ),
      actionContent: [
        DialogButton(
          title: "아니요",
          onTap: () => Navigator.pop(context),
          backgroundColor: Theme.of(context).colorScheme.secondaryColor,
          textStyle: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
        ),
        SizedBox(
          width: 12.w,
        ),
        DialogButton(
          title: "예",
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
            FocusManager.instance.primaryFocus?.unfocus();
          },
          backgroundColor: kOrange200Color,
          textStyle: kHeader4Style.copyWith(color: kWhiteColor),
        ),
      ],
    );
  }
}

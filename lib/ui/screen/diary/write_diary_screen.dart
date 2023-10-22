import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/domains/diary/provider/diary_select_provider.dart';
import 'package:frontend/domains/diary/provider/wtire_diary_provider.dart';
import 'package:frontend/res/constants.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/components/weather_emotion_badge_writing_diary.dart';
import 'package:frontend/ui/screen/diary/write_diary_loading_screen.dart';
import 'package:frontend/ui/screen/home/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';

class WriteDiaryScreen extends ConsumerStatefulWidget {
  final DateTime date;
  final String emotion;
  final String weather;
  final DiaryData? diaryData;
  final bool isEditScreen;

  WriteDiaryScreen({
    Key? key,
    required this.date,
    required this.emotion,
    required this.weather,
    required this.isEditScreen,
    this.diaryData,
  }) : super(key: key);

  @override
  WriteDiaryScreenState createState() => WriteDiaryScreenState();
}

class WriteDiaryScreenState extends ConsumerState<WriteDiaryScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.watch(writeDiaryProvider.notifier).setRandomImageNumber(Random().nextInt(7) + 1);
      ref.watch(animationControllerProvider.notifier).state = AnimationController(vsync: this);
      ref.watch(writeDiaryProvider.notifier).diaryEditingController.addListener(ref.watch(writeDiaryProvider.notifier).onTextChanged);

      ref.watch(writeDiaryProvider.notifier).getDefaultTopic(widget.emotion);

      if (widget.diaryData != null) {
        ref.watch(writeDiaryProvider.notifier).setDiaryData(widget.diaryData!);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    ref.watch(writeDiaryProvider.notifier).diaryEditingController.removeListener(ref.watch(writeDiaryProvider.notifier).onTextChanged);

    DateTime screenExitTime = DateTime.now();
    Duration stayDuration = screenExitTime.difference(ref.watch(screenEntryTimeProvider));

    // Firebase Analytics에 체류시간 로깅
    GlobalUtils.setAnalyticsCustomEvent('stay_duration', {
      'screen': "Screen_Event_WriteDiary_WritePage",
      'duration': stayDuration.inSeconds,
    });
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
                            if (ref.watch(croppedFileProvider) != null) {
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
                                await ref.watch(writeDiaryProvider.notifier).uploadImage();
                                // ignore: use_build_context_synchronously
                                Navigator.of(context, rootNavigator: true).pop();
                              } catch (e) {
                                Navigator.of(context, rootNavigator: true).pop();
                              }
                            }

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                  settings: RouteSettings(arguments: {"index": 0}),
                                ),
                                (route) => false);

                            FocusManager.instance.primaryFocus?.unfocus();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WriteDiaryLoadingScreen(
                                  diaryData: DiaryData(
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
                        SizedBox(
                          height: 188.h,
                          child: Stack(
                            children: [
                              Center(
                                child: Image.asset(
                                  getWeatherCharacter(widget.weather),
                                  height: 196.h,
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
                        SizedBox(
                          height: 8.h,
                        ),
                        Center(
                          child: Consumer(builder: (context, ref, child) {
                            return Text(
                              textAlign: TextAlign.center,
                              ref.watch(writeDiaryProvider).topic.value,
                              maxLines: 2,
                              style: kHeader3Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle,
                              ),
                            );
                          }),
                        ),
                        Container(
                          height: 12.h,
                        ),
                        WeatherEmotionBadgeWritingDiary(
                          emoticon: getEmoticonImage(widget.emotion),
                          emoticonDesc: getEmoticonValue(widget.emotion),
                          weatherIcon: getWeatherImage(widget.weather),
                          weatherIconDesc: getWeatherValue(widget.weather),
                          color: Theme.of(context).colorScheme.surface_01,
                        ),
                        Consumer(builder: (context, ref, child) {
                          return ref.watch(diaryProvider).diaryDetailData == null
                              ? Container()
                              : ref.watch(diaryProvider).diaryDetailData!.image == ''
                                  ? Container()
                                  : Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20.0.w, right: 20.w, top: 20),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              ref.watch(diaryProvider).diaryDetailData!.image,
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              right: 12,
                                              top: 12,
                                              child: GestureDetector(
                                                onTap: () {
                                                  ref.watch(writeDiaryProvider.notifier).clear();
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
                        Consumer(builder: (context, ref, child) {
                          return (ref.watch(croppedFileProvider) != null || ref.watch(pickedFileProvider) != null || ref.watch(writeDiaryProvider).networkImage != null)
                              ? Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20.0.w, right: 20.w, top: 20),
                                    child: ref.watch(writeDiaryProvider).networkImage != null
                                        ? Stack(
                                            children: [
                                              Image.network(
                                                ref.watch(writeDiaryProvider).networkImage!,
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                right: 12,
                                                top: 12,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    ref.watch(writeDiaryProvider.notifier).clear();
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
                                        : ref.watch(croppedFileProvider) != null
                                            ? Stack(
                                                children: [
                                                  Image.file(
                                                    fit: BoxFit.cover,
                                                    File(ref.watch(croppedFileProvider)!.path),
                                                  ),
                                                  Positioned(
                                                    right: 12,
                                                    top: 12,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        ref.watch(writeDiaryProvider.notifier).clear();
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
                        TextField(
                          maxLength: 500,
                          maxLines: null,
                          autofocus: true,
                          style: kBody1Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                          controller: ref.watch(writeDiaryProvider.notifier).diaryEditingController,
                          keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: Theme.of(context).colorScheme.inverseSurface,
                          decoration: InputDecoration(
                            helperText: "",
                            counterText: "",
                            hintStyle: kBody1Style.copyWith(color: kGrayColor400),
                            contentPadding: const EdgeInsets.only(
                              top: 12,
                              left: 20,
                              right: 20,
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
                                ref.watch(writeDiaryProvider.notifier).selectDeviceImage().then((_) => ref.watch(writeDiaryProvider.notifier).cropImage());
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 16.w),
                                child: SvgPicture.asset(
                                  "lib/config/assets/images/diary/write_diary/album.svg",
                                  color: kGrayColor600,
                                  width: 24.w,
                                  height: 24.h,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Get_Topic');
                                ref.watch(writeDiaryProvider.notifier).getRandomTopic();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: 16.w),
                                child: SvgPicture.asset(
                                  "lib/config/assets/images/diary/write_diary/refresh.svg",
                                  width: 24.w,
                                  color: kGrayColor600,
                                  height: 24.h,
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

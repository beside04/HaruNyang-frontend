import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/main.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/weather_emotion_badge_writing_diary.dart';
import 'package:frontend/presentation/diary/components/diary_popup_menu_item.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_note_screen.dart';
import 'package:frontend/presentation/diary/write_diary_screen.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/utils/utils.dart';

class DiaryDetailScreen extends StatefulWidget {
  final int diaryId;
  final DateTime date;
  final DiaryData diaryData;
  final CroppedFile? imageFile;
  final bool isNewDiary;

  const DiaryDetailScreen({
    Key? key,
    required this.diaryId,
    required this.date,
    required this.diaryData,
    required this.isNewDiary,
    this.imageFile,
  }) : super(key: key);

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final diaryController = Get.find<DiaryController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });

    super.initState();
  }

  init() async {
    await diaryController.getDiaryDetail(widget.diaryId);

    print(diaryController.isNote);

    diaryController.isNote.value = true;

    print(diaryController.isNote);
    print(diaryController.isNote);
    print(diaryController.isNote);
    print(diaryController.isNote);
    print(diaryController.isNote);

    widget.isNewDiary
        // ignore: use_build_context_synchronously
        ? await Navigator.of(context).push(
            PageRouteBuilder(
              barrierColor: Colors.black38,
              opaque: false, // set to false
              pageBuilder: (_, __, ___) => DairyNoteScreen(),
            ),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final mainViewController = Get.find<MainViewModel>();
    final diaryController = Get.find<DiaryController>();

    return DefaultLayout(
      screenName: 'Screen_Event_DiaryRead',
      child: WillPopScope(
        onWillPop: () async {
          Get.offAll(
            () => const HomeScreen(),
            binding: BindingsBuilder(
              getHomeViewModelBinding,
            ),
          );
          Get.find<DiaryController>().resetDiary();
          return false;
        },
        child: Scaffold(
          floatingActionButton: Obx(() => diaryController.isNote.value
              ? Container(
                  width: 60.w,
                  height: 60.h,
                  child: FloatingActionButton(
                    elevation: 5,
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          barrierColor: Colors.black38,
                          opaque: false, // set to false
                          pageBuilder: (_, __, ___) => DairyNoteScreen(),
                        ),
                      );
                    },
                    backgroundColor: kOrange300Color,
                    child: Center(
                      child: Image.asset(
                        "lib/config/assets/images/diary/write_diary/letter.png",
                        height: 32.h,
                      ),
                    ),
                  ),
                )
              : Container()),
          appBar: AppBar(
            title: Text(
              DateFormat('M월 d일').format(widget.date),
              style: kHeader4Style.copyWith(
                  color: Theme.of(context).colorScheme.textTitle),
            ),
            leading: IconButton(
              onPressed: () {
                Get.offAll(
                  () => const HomeScreen(),
                  binding: BindingsBuilder(
                    getHomeViewModelBinding,
                  ),
                );
                Get.find<DiaryController>().resetDiary();
              },
              icon: SvgPicture.asset(
                "lib/config/assets/images/diary/dark_mode/close.svg",
                color: Theme.of(context).colorScheme.iconColor,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              Theme(
                data: Theme.of(context).copyWith(
                  dividerTheme: DividerThemeData(
                    color: Theme.of(context).colorScheme.border,
                  ),
                ),
                child: PopupMenuButton(
                  icon: SvgPicture.asset(
                    "lib/config/assets/images/diary/dark_mode/kebab.svg",
                    color: Theme.of(context).colorScheme.iconColor,
                  ),
                  onSelected: (id) {
                    if (id == 'edit') {
                      GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Update');

                      Get.to(
                        () => WriteDiaryScreen(
                          date: widget.date,
                          emotion: widget.diaryData.feeling,
                          diaryData: widget.diaryData.id == null
                              ? widget.diaryData.copyWith(id: widget.diaryId)
                              : widget.diaryData,
                          weather: widget.diaryData.weather,
                          isEditScreen: true,
                        ),
                      );
                    }
                    if (id == 'delete') {
                      GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Delete');
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return DialogComponent(
                            title: "삭제 하실래요?",
                            content: Text(
                              "삭제 후 일기를 복원 할 수 없어요",
                              style: kHeader6Style.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .textSubtitle),
                            ),
                            actionContent: [
                              DialogButton(
                                title: "아니요",
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .secondaryColor,
                                textStyle: kHeader4Style.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .textSubtitle),
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              DialogButton(
                                title: "예",
                                onTap: () async {
                                  Navigator.pop(context);

                                  await diaryController.deleteDiary(
                                      widget.diaryData.id ??
                                          widget.diaryData
                                              .copyWith(id: widget.diaryId)
                                              .id!);

                                  await showDialog(
                                    barrierDismissible: false,
                                    context: navigatorKey.currentContext!,
                                    builder: (ctx) {
                                      return WillPopScope(
                                        onWillPop: () async => false,
                                        child: DialogComponent(
                                          title: "삭제 완료",
                                          content: Text(
                                            "일기를 삭제했어요.",
                                            style: kHeader6Style.copyWith(
                                                color: Theme.of(ctx)
                                                    .colorScheme
                                                    .textSubtitle),
                                          ),
                                          actionContent: [
                                            DialogButton(
                                              title: "확인",
                                              onTap: () {
                                                Get.offAll(
                                                  () => const HomeScreen(),
                                                  binding: BindingsBuilder(
                                                    getHomeViewModelBinding,
                                                  ),
                                                );
                                                Get.find<DiaryController>()
                                                    .resetDiary();
                                              },
                                              backgroundColor: kOrange200Color,
                                              textStyle: kHeader4Style.copyWith(
                                                  color: kWhiteColor),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                backgroundColor: kOrange200Color,
                                textStyle:
                                    kHeader4Style.copyWith(color: kWhiteColor),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  offset: Offset(0.0, AppBar().preferredSize.height),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  itemBuilder: (context) {
                    final list = <PopupMenuEntry>[];
                    list.add(
                      diaryPopUpMenuItem(
                        'edit',
                        '일기 수정',
                        context,
                        SvgPicture.asset(
                          "lib/config/assets/images/diary/dark_mode/edit.svg",
                          color: Theme.of(context).colorScheme.iconColor,
                        ),
                      ),
                    );
                    list.add(
                      const PopupMenuDivider(
                        height: 10,
                      ),
                    );
                    list.add(
                      diaryPopUpMenuItem(
                        'delete',
                        '일기 삭제',
                        context,
                        SvgPicture.asset(
                          "lib/config/assets/images/diary/dark_mode/trash.svg",
                          color: Theme.of(context).colorScheme.iconColor,
                        ),
                      ),
                    );
                    return list;
                  },
                ),
              ),
            ],
          ),
          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: ListView(
                children: [
                  SizedBox(
                    height: 188.h,
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            getWeatherCharacter(widget.diaryData.weather),
                            height: 196.h,
                          ),
                        ),
                        getWeatherAnimation(widget.diaryData.weather) == ""
                            ? Container()
                            : RiveAnimation.asset(
                                getWeatherAnimation(widget.diaryData.weather),
                                fit: BoxFit.fill,
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  WeatherEmotionBadgeWritingDiary(
                    emoticon: getEmoticonImage(widget.diaryData.feeling),
                    emoticonDesc: getEmoticonValue(widget.diaryData.feeling),
                    weatherIcon: getWeatherImage(widget.diaryData.weather),
                    weatherIconDesc: getWeatherValue(widget.diaryData.weather),
                    color: Theme.of(context).colorScheme.surface_01,
                  ),
                  Container(
                    height: 20.h,
                  ),
                  Obx(
                    () => diaryController.diaryDetailData.value?.image == '' ||
                            diaryController.diaryDetailData.value == null
                        ? Container()
                        : Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 12.0, right: 20.w, left: 20.w),
                              child: Image.network(
                                "${diaryController.diaryDetailData.value?.image}",
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.w, right: 20.w, bottom: 12.h),
                    child: Text(
                      widget.diaryData.diaryContent,
                      style: kBody1Style.copyWith(
                          color: Theme.of(context).colorScheme.textTitle),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/main.dart';
import 'package:frontend/presentation/components/back_icon.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/weather_emotion_badge_writing_diary.dart';
import 'package:frontend/presentation/diary/components/diary_loading_widget.dart';
import 'package:frontend/presentation/diary/components/diary_popup_menu_item.dart';
import 'package:frontend/presentation/diary/write_diary_screen.dart';
import 'package:frontend/presentation/diary/write_diary_view_model.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

class DiaryDetailScreen extends StatefulWidget {
  final DateTime date;
  final DiaryData diaryData;
  final bool isStamp;
  final CroppedFile? imageFile;

  const DiaryDetailScreen({
    Key? key,
    required this.date,
    required this.diaryData,
    required this.isStamp,
    this.imageFile,
  }) : super(key: key);

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  final diaryController = Get.find<DiaryController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 일기 작성 페이지 컨트롤러 초기화
      Get.delete<WriteDiaryViewModel>();

      if (widget.isStamp) {
        diaryController.setCalendarData(widget.diaryData);
      } else {
        await diaryController.saveDiary(
            widget.diaryData, widget.imageFile, widget.date);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(
          () => const HomeScreen(),
          binding: BindingsBuilder(
            getHomeViewModelBinding,
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                dividerTheme: DividerThemeData(
                  color: Theme.of(context).colorScheme.border,
                ),
              ),
              child: PopupMenuButton(
                onSelected: (id) {
                  if (id == 'edit') {
                    Get.to(
                      () => WriteDiaryScreen(
                        date: widget.date,
                        weather: diaryController.state.value.diary!.weather,
                        emotion: diaryController.state.value.diary!.emotion,
                        emoticonIndex:
                            diaryController.state.value.diary!.emoticonIndex,
                        diaryData: diaryController.state.value.diary!,
                        isEditScreen: true,
                      ),
                    );
                  }
                  if (id == 'delete') {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return DialogComponent(
                          title: "삭제 하실래요?",
                          content: Text(
                            "삭제 후 일기를 복원 할 수 없어요",
                            style: kHeader6Style.copyWith(
                                color:
                                    Theme.of(context).colorScheme.textSubtitle),
                          ),
                          actionContent: [
                            DialogButton(
                              title: "아니요",
                              onTap: () {
                                Get.back();
                              },
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondaryColor,
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
                                Get.back();
                                await diaryController.deleteDiary(
                                    diaryController.state.value.diary!.id ??
                                        '');

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
                                              color: Theme.of(context)
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
                    ),
                  );
                  return list;
                },
              ),
            ),
          ],
          title: Text(
            DateFormat('M월 d일').format(widget.date),
            style: kHeader4Style.copyWith(
                color: Theme.of(context).colorScheme.textTitle),
          ),
          leading: BackIcon(
            onPressed: () {
              Get.offAll(
                () => const HomeScreen(),
                binding: BindingsBuilder(
                  getHomeViewModelBinding,
                ),
              );
            },
          ),
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: Obx(
              () => ListView(
                children: [
                  SizedBox(
                    height: 6.h,
                  ),
                  Padding(
                    padding: kPrimaryPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WeatherEmotionBadgeWritingDiary(
                          emoticon: widget.diaryData.emotion.emoticon,
                          emoticonIndex: widget.diaryData.emoticonIndex,
                          weatherIcon: widget.diaryData.weather,
                          color: Theme.of(context).colorScheme.surface_01,
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          widget.diaryData.diaryContent,
                          style: kBody1Style.copyWith(
                              color: Theme.of(context).colorScheme.textBody),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        diaryController.state.value.networkImage.isNotEmpty
                            ? Column(
                                children: [
                                  Center(
                                    child: Image.network(
                                      diaryController.state.value.networkImage,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 8.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, top: 20.h),
                    child: Text(
                      "하루냥의 명언",
                      style: kHeader4Style.copyWith(
                          color: Theme.of(context).colorScheme.textTitle),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      height:
                          diaryController.state.value.isLoading ? 36.h : 16.h,
                    ),
                  ),
                  Obx(
                    () {
                      if (diaryController.state.value.isLoading) {
                        return const DiaryLoadingWidget();
                      } else {
                        return AnimationLimiter(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 20.w, right: 20.w),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: diaryController
                                        .state.value.wiseSayingList.length <
                                    3
                                ? diaryController
                                    .state.value.wiseSayingList.length
                                : 3,
                            itemBuilder: (BuildContext context, int index) {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                delay: const Duration(milliseconds: 100),
                                child: SlideAnimation(
                                  duration: const Duration(milliseconds: 2500),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: FadeInAnimation(
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    duration:
                                        const Duration(milliseconds: 2500),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 12.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16.w),
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface_01,
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                        ),
                                        child: Padding(
                                          padding: kPrimaryPadding,
                                          child: Obx(
                                            () => Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          "lib/config/assets/images/character/character11.svg",
                                                          width: 26.w,
                                                        ),
                                                        SizedBox(
                                                          width: 4.w,
                                                        ),
                                                        Text(
                                                          "하루냥",
                                                          style: kHeader5Style.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .textTitle),
                                                        )
                                                      ],
                                                    ),
                                                    Obx(
                                                      () => diaryController.isBookmarked(
                                                              diaryController
                                                                      .state
                                                                      .value
                                                                      .wiseSayingList[
                                                                          index]
                                                                      .id ??
                                                                  0)
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                diaryController.deleteBookmarkByWiseSaying(
                                                                    diaryController
                                                                        .state
                                                                        .value
                                                                        .wiseSayingList[index]);
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                "lib/config/assets/images/diary/write_diary/bookmark_check.svg",
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                diaryController.saveBookmark(
                                                                    diaryController
                                                                        .state
                                                                        .value
                                                                        .wiseSayingList[index]);
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                "lib/config/assets/images/diary/write_diary/bookmark.svg",
                                                              ),
                                                            ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 12.h,
                                                ),
                                                Text(
                                                  diaryController
                                                      .state
                                                      .value
                                                      .wiseSayingList[index]
                                                      .message,
                                                  style: kBody2Style.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .textBody),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    diaryController
                                                        .state
                                                        .value
                                                        .wiseSayingList[index]
                                                        .author,
                                                    style: kBody3Style.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .textSubtitle),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
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

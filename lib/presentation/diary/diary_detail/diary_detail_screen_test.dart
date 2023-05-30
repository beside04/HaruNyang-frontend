import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
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
import 'package:frontend/presentation/diary/write_diary_screen_test.dart';
import 'package:frontend/presentation/diary/write_diary_view_model.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/utils.dart';

class DiaryDetailScreenTest extends StatefulWidget {
  final DateTime date;
  final DiaryData diaryData;
  final bool isStamp;
  final CroppedFile? imageFile;

  const DiaryDetailScreenTest({
    Key? key,
    required this.date,
    required this.diaryData,
    required this.isStamp,
    this.imageFile,
  }) : super(key: key);

  @override
  State<DiaryDetailScreenTest> createState() => _DiaryDetailScreenTestState();
}

class _DiaryDetailScreenTestState extends State<DiaryDetailScreenTest>
    with SingleTickerProviderStateMixin {
  final diaryController = Get.find<DiaryController>();

  int _page = 0;
  TabController? _tabController;
  PageController? _pageController;

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

    _tabController = new TabController(length: 2, vsync: this);
    _pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          return false;
        },
        child: Scaffold(
          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: Column(
                children: [
                  TabBar(
                    onTap: (value) {
                      setState(() {
                        _page = value;
                      });
                      _pageController!.animateToPage(_page,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    indicatorColor: Theme.of(context).colorScheme.primaryColor,
                    controller: _tabController,
                    labelColor: Theme.of(context).colorScheme.primaryColor,
                    unselectedLabelColor:
                        Theme.of(context).colorScheme.textSubtitle,
                    tabs: [
                      Tab(
                        text: "하루냥의 한 마디",
                      ),
                      Tab(
                        text: "내가 쓴 일기",
                      ),
                    ],
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          _page = value;
                        });
                        _tabController!.animateTo(_page,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Image.asset(
                                "lib/config/assets/images/character/write_character.png",
                                height: 200.h,
                                width: 200.h,
                              ),
                              Obx(
                                () => SizedBox(
                                  height: diaryController.state.value.isLoading
                                      ? 36.h
                                      : 16.h,
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
                                        padding: EdgeInsets.only(
                                            left: 20.w, right: 20.w),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: diaryController.state.value
                                                    .wiseSayingList.length <
                                                3
                                            ? diaryController.state.value
                                                .wiseSayingList.length
                                            : 3,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            delay: const Duration(
                                                milliseconds: 100),
                                            child: SlideAnimation(
                                              duration: const Duration(
                                                  milliseconds: 2500),
                                              curve:
                                                  Curves.fastLinearToSlowEaseIn,
                                              child: FadeInAnimation(
                                                curve: Curves
                                                    .fastLinearToSlowEaseIn,
                                                duration: const Duration(
                                                    milliseconds: 2500),
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(16.w),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .surface_01,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0),
                                                    ),
                                                    child: Padding(
                                                      padding: kPrimaryPadding,
                                                      child: Obx(
                                                        () => Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SvgPicture
                                                                        .asset(
                                                                      "lib/config/assets/images/character/character11.svg",
                                                                      width:
                                                                          26.w,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          4.w,
                                                                    ),
                                                                    Text(
                                                                      "하루냥",
                                                                      style: kHeader5Style.copyWith(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .textTitle),
                                                                    )
                                                                  ],
                                                                ),
                                                                Obx(
                                                                  () => diaryController.isBookmarked(diaryController
                                                                              .state
                                                                              .value
                                                                              .wiseSayingList[index]
                                                                              .id ??
                                                                          0)
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            diaryController.deleteBookmarkByWiseSaying(diaryController.state.value.wiseSayingList[index]);
                                                                          },
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            "lib/config/assets/images/diary/write_diary/bookmark_check.svg",
                                                                          ),
                                                                        )
                                                                      : GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            diaryController.saveBookmark(diaryController.state.value.wiseSayingList[index]);
                                                                          },
                                                                          child:
                                                                              SvgPicture.asset(
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
                                                                  .wiseSayingList[
                                                                      index]
                                                                  .message,
                                                              style: kBody2Style.copyWith(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .textBody),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                diaryController
                                                                    .state
                                                                    .value
                                                                    .wiseSayingList[
                                                                        index]
                                                                    .author,
                                                                style: kBody3Style.copyWith(
                                                                    color: Theme.of(
                                                                            context)
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
                        Expanded(
                          child: ListView(
                            children: [
                              Stack(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      "lib/config/assets/images/character/rain_character1.png",
                                    ),
                                  ),
                                  Image.asset(
                                    "lib/config/assets/images/character/rain.png",
                                  ),
                                ],
                              ),
                              Container(
                                height: 12.h,
                              ),
                              Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "오늘 가장 슬픈 일은\n 무엇이었나요?",
                                  maxLines: 2,
                                  style: kHeader3Style.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.textTitle,
                                  ),
                                ),
                              ),
                              Container(
                                height: 12.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface_01,
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.network(
                                          widget.diaryData.weather,
                                          width: 24.w,
                                          height: 24.h,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(widget.diaryData.weather),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(6.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface_01,
                                    ),
                                    child: Row(
                                      children: [
                                        // SvgPicture.network(
                                        //   widget.diaryData.emotion.emoticon,
                                        //   width: 24.w,
                                        //   height: 24.h,
                                        // ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text("그저그래"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(25.0.w),
                                child: Text(
                                  maxLines: 7,
                                  widget.diaryData.diaryContent,
                                  style: kBody1Style.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .textBody),
                                ),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      GlobalUtils.setAnalyticsCustomEvent(
                                          'Click_Diary_Update');
                                      // Get.to(
                                      //   () => WriteDiaryScreenTest(
                                      //     date: widget.date,
                                      //     weather: diaryController
                                      //         .state.value.diary!.weather,
                                      //     emotion: diaryController
                                      //         .state.value.diary!.emotion,
                                      //     emoticonIndex: diaryController
                                      //         .state.value.diary!.emoticonIndex,
                                      //     diaryData: diaryController
                                      //         .state.value.diary!,
                                      //     isEditScreen: true,
                                      //   ),
                                      // );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.h, bottom: 10.h, left: 25.w),
                                      child: Icon(Icons.edit),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      GlobalUtils.setAnalyticsCustomEvent(
                                          'Click_Diary_Delete');
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
                                                  Get.back();
                                                },
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondaryColor,
                                                textStyle:
                                                    kHeader4Style.copyWith(
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
                                                  // await diaryController
                                                  //     .deleteDiary(
                                                  //         diaryController
                                                  //                 .state
                                                  //                 .value
                                                  //                 .diary!
                                                  //                 .id ??
                                                  //             '');

                                                  await showDialog(
                                                    barrierDismissible: false,
                                                    context: navigatorKey
                                                        .currentContext!,
                                                    builder: (ctx) {
                                                      return WillPopScope(
                                                        onWillPop: () async =>
                                                            false,
                                                        child: DialogComponent(
                                                          title: "삭제 완료",
                                                          content: Text(
                                                            "일기를 삭제했어요.",
                                                            style: kHeader6Style.copyWith(
                                                                color: Theme.of(
                                                                        ctx)
                                                                    .colorScheme
                                                                    .textSubtitle),
                                                          ),
                                                          actionContent: [
                                                            DialogButton(
                                                              title: "확인",
                                                              onTap: () {
                                                                Get.offAll(
                                                                  () =>
                                                                      const HomeScreen(),
                                                                  binding:
                                                                      BindingsBuilder(
                                                                    getHomeViewModelBinding,
                                                                  ),
                                                                );
                                                              },
                                                              backgroundColor:
                                                                  kOrange200Color,
                                                              textStyle:
                                                                  kHeader4Style
                                                                      .copyWith(
                                                                          color:
                                                                              kWhiteColor),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                backgroundColor:
                                                    kOrange200Color,
                                                textStyle:
                                                    kHeader4Style.copyWith(
                                                        color: kWhiteColor),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 10.h,
                                            bottom: 10.h,
                                            left: 25.w),
                                        child: Icon(Icons.delete)),
                                  ),
                                ],
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
}

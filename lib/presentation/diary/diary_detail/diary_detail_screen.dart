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
  final diaryController = Get.find<DiaryController>();

  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });

    super.initState();
  }

  init() async {
    await diaryController.getDiaryDetail(widget.diaryId);

    widget.isNewDiary
        // ignore: use_build_context_synchronously
        ? await showDialog(
            barrierDismissible: true,
            context: context,
            builder: (ctx) {
              return AlertDialog(
                elevation: 0,
                titlePadding: EdgeInsets.zero,
                iconPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                actionsPadding: EdgeInsets.zero,
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                title: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 584.h,
                        child: Container(
                          color: Theme.of(context).colorScheme.backgroundModal,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      color: kModalColor,
                                      child: Image.asset(
                                        "lib/config/assets/images/character/character5.png",
                                        height: 220.h,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                    Container(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .backgroundModal,
                                      child: CarouselSlider.builder(
                                        options: CarouselOptions(
                                          enableInfiniteScroll: false,
                                          viewportFraction: 1.0,
                                          onPageChanged: (index, reason) {
                                            _counter.value = index;
                                          },
                                        ),
                                        itemCount: diaryController
                                            .diaryDetailData
                                            .value!
                                            .comments
                                            .length,
                                        itemBuilder: (BuildContext context,
                                            int index, int realIndex) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                left: 24.0.w,
                                                right: 24.0.w,
                                                top: 24.0.h),
                                            child: ListView(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    diaryController
                                                                .diaryDetailData
                                                                .value!
                                                                .comments[index]
                                                                .author ==
                                                            "harunyang"
                                                        ? Text(
                                                            '하루냥',
                                                            style: kHeader5Style.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .textSubtitle),
                                                          )
                                                        : Text(
                                                            diaryController
                                                                .diaryDetailData
                                                                .value!
                                                                .comments[index]
                                                                .author,
                                                            style: kHeader5Style.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .textSubtitle),
                                                          ),
                                                    Obx(
                                                      () => diaryController
                                                              .diaryDetailData
                                                              .value!
                                                              .comments[index]
                                                              .isFavorite
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                diaryController
                                                                    .deleteBookmarkByBookmarkId(
                                                                  diaryController
                                                                      .diaryDetailData
                                                                      .value!
                                                                      .comments[
                                                                          index]
                                                                      .id!,
                                                                  index,
                                                                );
                                                              },
                                                              child: SvgPicture
                                                                  .asset(
                                                                "lib/config/assets/images/diary/write_diary/bookmark_check.svg",
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onTap: () {
                                                                diaryController
                                                                    .saveBookmark(
                                                                  diaryController
                                                                      .diaryDetailData
                                                                      .value!
                                                                      .comments[
                                                                          index]
                                                                      .id!,
                                                                  index,
                                                                );
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
                                                  height: 10.0.h,
                                                ),
                                                SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      diaryController
                                                          .diaryDetailData
                                                          .value!
                                                          .comments[index]
                                                          .message,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style:
                                                          kBody1Style.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .textBody),
                                                    )),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0.h, bottom: 16.0.h),
                                  child: ValueListenableBuilder<int>(
                                    valueListenable: _counter,
                                    builder: (BuildContext context, int index,
                                            Widget? child) =>
                                        AnimatedSmoothIndicator(
                                      activeIndex: index,
                                      axisDirection: Axis.horizontal,
                                      count: diaryController.diaryDetailData
                                          .value!.comments.length,
                                      effect: ScrollingDotsEffect(
                                        dotColor: kGrayColor400,
                                        activeDotColor: kOrange300Color,
                                        dotWidth: 6.h,
                                        dotHeight: 6.h,
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
                content: null,
                actions: <Widget>[],
              );
            },
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final mainViewController = Get.find<MainViewModel>();

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
          floatingActionButton: Container(
            width: 60.w,
            height: 60.h,
            child: FloatingActionButton(
              elevation: 5,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.1),
              //     spreadRadius: 1,
              //     blurRadius: 10,
              //     offset: Offset(0, 5),
              //   ),
              // ],
              onPressed: () {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      elevation: 0,
                      titlePadding: EdgeInsets.zero,
                      iconPadding: EdgeInsets.zero,
                      contentPadding: EdgeInsets.zero,
                      actionsPadding: EdgeInsets.zero,
                      insetPadding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      title: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 584.h,
                              child: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .backgroundModal,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            color: kModalColor,
                                            child: Image.asset(
                                              "lib/config/assets/images/character/character5.png",
                                              height: 220.h,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                            ),
                                          ),
                                          Container(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .backgroundModal,
                                            child: CarouselSlider.builder(
                                              options: CarouselOptions(
                                                enableInfiniteScroll: false,
                                                viewportFraction: 1.0,
                                                onPageChanged: (index, reason) {
                                                  _counter.value = index;
                                                },
                                              ),
                                              itemCount: diaryController
                                                  .diaryDetailData
                                                  .value!
                                                  .comments
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index,
                                                      int realIndex) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 24.0.w,
                                                      right: 24.0.w,
                                                      top: 24.0.h),
                                                  child: ListView(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          diaryController
                                                                      .diaryDetailData
                                                                      .value!
                                                                      .comments[
                                                                          index]
                                                                      .author ==
                                                                  "harunyang"
                                                              ? Text(
                                                                  '하루냥',
                                                                  style: kHeader5Style.copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .textSubtitle),
                                                                )
                                                              : Text(
                                                                  diaryController
                                                                      .diaryDetailData
                                                                      .value!
                                                                      .comments[
                                                                          index]
                                                                      .author,
                                                                  style: kHeader5Style.copyWith(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .textSubtitle),
                                                                ),
                                                          Obx(
                                                            () => diaryController
                                                                    .diaryDetailData
                                                                    .value!
                                                                    .comments[
                                                                        index]
                                                                    .isFavorite
                                                                ? GestureDetector(
                                                                    onTap: () {
                                                                      diaryController
                                                                          .deleteBookmarkByBookmarkId(
                                                                        diaryController
                                                                            .diaryDetailData
                                                                            .value!
                                                                            .comments[index]
                                                                            .id!,
                                                                        index,
                                                                      );
                                                                    },
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      "lib/config/assets/images/diary/write_diary/bookmark_check.svg",
                                                                    ),
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      diaryController
                                                                          .saveBookmark(
                                                                        diaryController
                                                                            .diaryDetailData
                                                                            .value!
                                                                            .comments[index]
                                                                            .id!,
                                                                        index,
                                                                      );
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
                                                        height: 10.0.h,
                                                      ),
                                                      SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Text(
                                                            diaryController
                                                                .diaryDetailData
                                                                .value!
                                                                .comments[index]
                                                                .message,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: kBody1Style.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .textBody),
                                                          )),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 8.0.h, bottom: 16.0.h),
                                        child: ValueListenableBuilder<int>(
                                          valueListenable: _counter,
                                          builder: (BuildContext context,
                                                  int index, Widget? child) =>
                                              AnimatedSmoothIndicator(
                                            activeIndex: index,
                                            axisDirection: Axis.horizontal,
                                            count: diaryController
                                                .diaryDetailData
                                                .value!
                                                .comments
                                                .length,
                                            effect: ScrollingDotsEffect(
                                              dotColor: kGrayColor400,
                                              activeDotColor: kOrange300Color,
                                              dotWidth: 6.h,
                                              dotHeight: 6.h,
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
                      content: null,
                      actions: <Widget>[],
                    );
                  },
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
          ),
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
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.w, right: 20.w, bottom: 12.h),
                    child: Text(
                      widget.diaryData.diaryContent,
                      style: kBody1Style.copyWith(
                          color: Theme.of(context).colorScheme.textTitle),
                    ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

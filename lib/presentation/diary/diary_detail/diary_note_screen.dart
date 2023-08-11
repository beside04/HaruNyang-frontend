import 'dart:io';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/presentation/components/toast.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DairyNoteScreen extends StatefulWidget {
  const DairyNoteScreen({
    super.key,
  });

  @override
  State<DairyNoteScreen> createState() => _DairyNoteScreenState();
}

class _DairyNoteScreenState extends State<DairyNoteScreen> {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final diaryController = Get.find<DiaryController>();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          backgroundColor: Colors.black38,
          floatingActionButton: Container(
            width: 60.w,
            height: 60.h,
            child: FloatingActionButton(
              elevation: 5,
              onPressed: () {
                Get.back();
              },
              backgroundColor: kWhiteColor,
              child: Center(
                child: Image.asset(
                  "lib/config/assets/images/diary/light_mode/close.png",
                  color: Theme.of(context).colorScheme.iconSubColor,
                  height: 16.h,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 120.h),
                  SizedBox(
                    height: 490,
                    child: PageView(
                      padEnds: false,
                      onPageChanged: (index) {
                        _counter.value = index;
                      },
                      controller: PageController(initialPage: 0),
                      scrollDirection: Axis.horizontal,
                      children: diaryController.diaryDetailData.value!.comments
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        var comment = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              color:
                                  Theme.of(context).colorScheme.backgroundModal,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: kModalColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                          10,
                                        ),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 37.0,
                                                right: 37,
                                                top: 28,
                                              ),
                                              child: diaryController
                                                          .diaryDetailData
                                                          .value!
                                                          .comments[index]
                                                          .author ==
                                                      "harunyang"
                                                  ? Image.asset(
                                                      "lib/config/assets/images/character/character5.png",
                                                    )
                                                  : Image.asset(
                                                      "lib/config/assets/images/character/character10.png",
                                                    ),
                                            ),
                                            Positioned(
                                              right: 10,
                                              top: 10,
                                              child: Obx(
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
                                                                .comments[index]
                                                                .id!,
                                                            0,
                                                          );
                                                          toast(
                                                            context: context,
                                                            text: '북마크를 삭제했어요.',
                                                            isCheckIcon: true,
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              SvgPicture.asset(
                                                            "lib/config/assets/images/diary/write_diary/bookmark_check.svg",
                                                            width: 20,
                                                            height: 20,
                                                          ),
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
                                                            0,
                                                          );
                                                          toast(
                                                            context: context,
                                                            text: '북마크를 추가했어요.',
                                                            isCheckIcon: true,
                                                          );
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              SvgPicture.asset(
                                                            "lib/config/assets/images/diary/write_diary/bookmark.svg",
                                                            width: 20,
                                                            height: 20,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    diaryController.diaryDetailData.value!
                                                .comments[index].author ==
                                            "harunyang"
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              left: 24.0.w,
                                              right: 24.0.w,
                                              top: 24.0.h,
                                            ),
                                            child: Text(
                                              '하루냥',
                                              style: kHeader5Style.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .textSubtitle),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(
                                                left: 24.0.w,
                                                right: 24.0.w,
                                                top: 24.0.h,
                                                bottom: 20.h),
                                            child: Text(
                                              diaryController
                                                  .diaryDetailData
                                                  .value!
                                                  .comments[index]
                                                  .author,
                                              style: kHeader5Style.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .textSubtitle),
                                            ),
                                          ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 24.0.w,
                                          right: 16.0.w,
                                          bottom: 30,
                                        ),
                                        child: Scrollbar(
                                          thumbVisibility: true,
                                          interactive: true,
                                          thickness: 6.0,
                                          radius: const Radius.circular(8.0),
                                          child: ListView(
                                            children: [
                                              const SizedBox(
                                                height: 4.0,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: SizedBox(
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
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  diaryController.diaryDetailData.value!.comments.length == 1
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(top: 8.0.h, bottom: 16.0.h),
                          child: ValueListenableBuilder<int>(
                            valueListenable: _counter,
                            builder: (BuildContext context, int index,
                                    Widget? child) =>
                                AnimatedSmoothIndicator(
                              activeIndex: index,
                              axisDirection: Axis.horizontal,
                              count: diaryController
                                  .diaryDetailData.value!.comments.length,
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
      ),
    );
  }
}

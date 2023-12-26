import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/res/constants.dart';
import 'package:frontend/ui/components/toast.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class DairyNoteScreen extends ConsumerStatefulWidget {
  const DairyNoteScreen({super.key});

  @override
  DairyNoteScreenState createState() => DairyNoteScreenState();
}

class DairyNoteScreenState extends ConsumerState<DairyNoteScreen> {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
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
                Navigator.pop(context);
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
                  SizedBox(height: 73.h),
                  SizedBox(
                    height: 550.h,
                    child: PageView(
                      padEnds: false,
                      onPageChanged: (index) {
                        _counter.value = index;
                      },
                      controller: PageController(initialPage: 0),
                      scrollDirection: Axis.horizontal,
                      children: ref.watch(diaryProvider).diaryDetailData!.comments.asMap().entries.map((entry) {
                        int index = entry.key;
                        var comment = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              color: Theme.of(context).colorScheme.backgroundModal,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // color: kModalColor,
                                      color: Color(0xff0A9F60),
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
                                                top: 18,
                                              ),
                                              child: Image.asset(
                                                "lib/config/assets/images/character/character5_christmas.png",
                                                height: 180.h,
                                                width: double.infinity,
                                              ),
                                              // ref.watch(diaryProvider).diaryDetailData!.comments[index].author == "harunyang"
                                              //     ? Image.asset(
                                              //         "lib/config/assets/images/character/character5_christmas.png",
                                              //       )
                                              //     : Image.asset(
                                              //         "lib/config/assets/images/character/character10.png",
                                              //       ),
                                            ),
                                            Positioned(
                                                right: 10,
                                                top: 10,
                                                child: Consumer(builder: (context, ref, child) {
                                                  return ref.watch(diaryProvider).diaryDetailData!.comments[index].isFavorite
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            ref.watch(diaryProvider.notifier).deleteBookmarkByBookmarkId(
                                                                  ref.watch(diaryProvider).diaryDetailData!.comments[index].id!,
                                                                  0,
                                                                );
                                                            toast(
                                                              context: context,
                                                              text: '북마크를 삭제했어요.',
                                                              isCheckIcon: true,
                                                            );
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: SvgPicture.asset(
                                                              "lib/config/assets/images/diary/write_diary/bookmark_check.svg",
                                                              width: 20,
                                                              height: 20,
                                                              color: kWhiteColor,
                                                            ),
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            ref.watch(diaryProvider.notifier).saveBookmark(
                                                                  ref.watch(diaryProvider).diaryDetailData!.comments[index].id!,
                                                                  0,
                                                                );
                                                            toast(
                                                              context: context,
                                                              text: '북마크를 추가했어요.',
                                                              isCheckIcon: true,
                                                            );
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: SvgPicture.asset(
                                                              "lib/config/assets/images/diary/write_diary/bookmark.svg",
                                                              width: 20,
                                                              height: 20,
                                                              color: kWhiteColor,
                                                            ),
                                                          ),
                                                        );
                                                })),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ref.watch(diaryProvider).diaryDetailData!.comments[index].author == "harunyang"
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              left: 24.0.w,
                                              right: 24.0.w,
                                              top: 24.0.h,
                                            ),
                                            child: Text(
                                              '산타 하루냥',
                                              style: kHeader5Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.only(left: 24.0.w, right: 24.0.w, top: 24.0.h, bottom: 20.h),
                                            child: Text(
                                              ref.watch(diaryProvider).diaryDetailData!.comments[index].author,
                                              style: kHeader5Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                            ),
                                          ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 24.0.w,
                                          right: 16.0.w,
                                          bottom: isBannerOpen ? 8 : 20,
                                        ),
                                        child: Scrollbar(
                                          interactive: true,
                                          thickness: 6.0,
                                          radius: const Radius.circular(8.0),
                                          child: ListView(
                                            children: [
                                              const SizedBox(
                                                height: 4.0,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: SizedBox(
                                                    width: MediaQuery.of(context).size.width,
                                                    child: Text(
                                                      ref.watch(diaryProvider).diaryDetailData!.comments[index].message,
                                                      textAlign: TextAlign.start,
                                                      style: kBody1Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: isBannerOpen,
                                      child: GestureDetector(
                                        onTap: () async {
                                          GlobalUtils.setAnalyticsCustomEvent('Click_Banner');
                                          if (!await launch(bannerUrl)) {
                                            throw Exception('Could not launch');
                                          }
                                        },
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 24.0),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).colorScheme.secondaryColor,
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              child: Text(
                                                "산타 하루냥에게 답장 쓰러가기",
                                                style: kBody1Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
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
                  ref.watch(diaryProvider).diaryDetailData!.comments.length == 1
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(top: 8.0.h, bottom: 16.0.h),
                          child: ValueListenableBuilder<int>(
                            valueListenable: _counter,
                            builder: (BuildContext context, int index, Widget? child) => AnimatedSmoothIndicator(
                              activeIndex: index,
                              axisDirection: Axis.horizontal,
                              count: ref.watch(diaryProvider).diaryDetailData!.comments.length,
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

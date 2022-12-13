import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/core/utils/delay_tween_animation.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_view_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiaryDetailScreen extends GetView<DiaryDetailViewModel> {
  final DateTime date;

  const DiaryDetailScreen({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getDiaryDetailBinding();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE69954),
        elevation: 0,
        centerTitle: true,
        title: Text(
          DateFormat('MM월 dd일').format(date),
          style: kHeader3BlackStyle,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kBlackColor,
            size: 20.w,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffE69954), Color(0xffE4A469), Color(0xffE4A86F)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(
                height: 6.h,
              ),
              Padding(
                padding: kPrimarySidePadding,
                child: Container(
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: kPrimaryPadding,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: kSurfaceLightColor,
                              ),
                              child: SvgPicture.asset(
                                "lib/config/assets/images/diary/weather/sunny.svg",
                                width: 16.w,
                                height: 16.h,
                              ),
                            ),
                            SizedBox(
                              width: 7.w,
                            ),
                            Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: kSurfaceLightColor,
                              ),
                              child: SvgPicture.network(
                                "https://firebasestorage.googleapis.com/v0/b/dark-room-84532.appspot.com/o/excited.svg?alt=media",
                                width: 16.w,
                                height: 16.h,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet consectetur. Arcuegenstas malesuada mauris quisque.",
                          style: kBody1BlackStyle,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 44.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.w),
                child: Text(
                  "하루냥의 명언",
                  style: kHeader3BlackStyle,
                ),
              ),
              Obx(
                () => SizedBox(
                  height: controller.isLoading.value ? 36.h : 16.h,
                ),
              ),
              Obx(
                () {
                  if (controller.isLoading.value) {
                    return Column(
                      children: [
                        Center(
                          child: Container(
                            width: 108.w,
                            height: 52.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0.w),
                              color: kWhiteColor,
                            ),
                            child: Padding(
                              padding: kPrimaryPadding,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (BuildContext context, int i) {
                                  return FadeTransition(
                                    opacity: DelayTween(
                                            begin: 0.0,
                                            end: 1.0,
                                            delay: controller.delays[i])
                                        .animate(
                                            controller.animationController),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 12.w,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: kBlackColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        i == 2
                                            ? Container()
                                            : SizedBox(
                                                width: 14.w,
                                              ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 40.0.h),
                          child: SvgPicture.asset(
                            "lib/config/assets/images/character/onboarding2.svg",
                            width: 350.w,
                            height: 350.h,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return AnimationLimiter(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            delay: const Duration(milliseconds: 100),
                            child: SlideAnimation(
                              duration: const Duration(milliseconds: 2500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: FadeInAnimation(
                                curve: Curves.fastLinearToSlowEaseIn,
                                duration: const Duration(milliseconds: 2500),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16.w),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 40,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: kWhiteColor,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: kPrimaryPadding,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    "lib/config/assets/images/character/defalut1.svg",
                                                    width: 24.w,
                                                    height: 24.h,
                                                  ),
                                                  SizedBox(
                                                    width: 7.w,
                                                  ),
                                                  Text(
                                                    "하루냥",
                                                    style: kSubtitle1BlackStyle,
                                                  )
                                                ],
                                              ),
                                              Obx(
                                                () => controller
                                                        .isBookmark.value
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          controller
                                                              .toggleBookmark();
                                                        },
                                                        child: const Icon(Icons
                                                            .bookmark_border),
                                                      )
                                                    : GestureDetector(
                                                        onTap: () {
                                                          controller
                                                              .toggleBookmark();
                                                        },
                                                        child: const Icon(
                                                          Icons.bookmark,
                                                          color: kPrimaryColor,
                                                        ),
                                                      ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Text(
                                            "가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가마바사 \n- 가나다",
                                            style: kBody1BlackStyle,
                                          )
                                        ],
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
    );
  }
}

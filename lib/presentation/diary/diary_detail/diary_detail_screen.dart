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
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/weather_emotion_badge_component.dart';
import 'package:frontend/presentation/diary/components/diary_loading_widget.dart';
import 'package:frontend/presentation/diary/components/diary_popup_menu_item.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_view_model.dart';
import 'package:frontend/presentation/diary/write_diary_screen.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

class DiaryDetailScreen extends GetView<DiaryDetailViewModel> {
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
  Widget build(BuildContext context) {
    getDiaryDetailBinding(
      diaryData: diaryData,
      isStamp: isStamp,
      imageFile: imageFile,
      date: date,
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        actions: [
          PopupMenuButton(
            onSelected: (id) {
              if (id == 'edit') {
                Get.to(
                  () => WriteDiaryScreen(
                    date: date,
                    weather: Weather.values[0],
                    emotion: controller.diary.value!.emotion,
                    emoticonIndex: controller.diary.value!.emoticonIndex,
                    diaryData: controller.diary.value!,
                  ),
                );
              }
              if (id == 'delete') {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (ctx) {
                    return DialogComponent(
                      title: "삭제 하실래요?",
                      content: Text(
                        "삭제 후 일기를 복원 할 수 없어요",
                        style: kHeader6Gray600Style,
                      ),
                      actionContent: [
                        DialogButton(
                          title: "아니요",
                          onTap: () {
                            Get.back();
                          },
                          backgroundColor:
                              Theme.of(context).colorScheme.darkTheme_100_650,
                          textStyle: Theme.of(context).textTheme.headline4!,
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        DialogButton(
                          title: "예",
                          onTap: () async {
                            Get.back();
                            await controller.deleteDiary();
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (ctx) {
                                return DialogComponent(
                                  title: "삭제 완료",
                                  content: Text(
                                    "일기를 삭제했어요.",
                                    style: kHeader6Gray600Style,
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
                                      backgroundColor: kPrimary2Color,
                                      textStyle: kHeader4WhiteStyle,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          backgroundColor: kPrimary2Color,
                          textStyle: kHeader4WhiteStyle,
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
        ],
        title: Text(
          DateFormat('MM월 dd일').format(date),
          style: Theme.of(context).textTheme.headline3,
        ),
        leading: IconButton(
          onPressed: () {
            Get.back(result: true);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.w,
          ),
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
                      WeatherEmotionBadgeComponent(
                        emoticon: diaryData.emotion.emoticon,
                        emoticonIndex: diaryData.emoticonIndex,
                        weatherIcon:
                            "lib/config/assets/images/diary/weather/${diaryData.weather}.svg",
                        color: Theme.of(context).colorScheme.darkTheme_100_700,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      controller.networkImage.value.isNotEmpty
                          ? Column(
                              children: [
                                Center(
                                  child: Image.network(
                                    controller.networkImage.value,
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
                      Text(
                        diaryData.diaryContent,
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 8.h,
                  color: Theme.of(context).colorScheme.darkTheme_100_850,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, top: 20.h),
                  child: Text(
                    "하루냥의 명언",
                    style: Theme.of(context).textTheme.headline3,
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
                      return const DiaryLoadingWidget();
                    } else {
                      return AnimationLimiter(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(left: 20.w, right: 20.w),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.wiseSayingList.length < 3
                              ? controller.wiseSayingList.length
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
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: kPrimaryPadding,
                                        child: Obx(
                                          () => Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                        style:
                                                            kHeader4BlackStyle,
                                                      )
                                                    ],
                                                  ),
                                                  Obx(
                                                    () => controller
                                                            .wiseSayingList[
                                                                index]
                                                            .isBookmarked
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              controller.toggleBookmark(
                                                                  controller
                                                                          .wiseSayingList[
                                                                      index]);
                                                            },
                                                            child: const Icon(
                                                              Icons.bookmark,
                                                              color:
                                                                  kPrimaryColor,
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                            onTap: () {
                                                              controller.toggleBookmark(
                                                                  controller
                                                                          .wiseSayingList[
                                                                      index]);
                                                            },
                                                            child: const Icon(Icons
                                                                .bookmark_border),
                                                          ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12.h,
                                              ),
                                              Text(
                                                "${controller.wiseSayingList[index].message} \n- ${controller.wiseSayingList[index].author}",
                                                style: kBody1BlackStyle,
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
    );
  }
}

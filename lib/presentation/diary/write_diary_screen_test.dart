import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/weather_emotion_badge_writing_diary.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen_test.dart';
import 'package:frontend/presentation/diary/write_diary_loading_screen.dart';
import 'package:frontend/presentation/diary/write_diary_view_model.dart';
import 'package:frontend/presentation/diary/write_diary_view_model_test.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../core/utils/utils.dart';
import '../components/back_icon.dart';

class WriteDiaryScreenTest extends GetView<WriteDiaryViewModelTest> {
  final DateTime date;
  final EmoticonData emotion;
  final String weather;
  final int emoticonIndex;
  final DiaryData? diaryData;
  final bool isEditScreen;

  WriteDiaryScreenTest({
    Key? key,
    required this.date,
    required this.emotion,
    required this.weather,
    required this.emoticonIndex,
    this.isEditScreen = false,
    this.diaryData,
  }) : super(key: key);

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    getWriteDiaryBindingTest(emotion, diaryData);

    return DefaultLayout(
      screenName: 'Screen_Event_WriteDiary_WritePage',
      child: WillPopScope(
        onWillPop: () async {
          GlobalUtils.setAnalyticsCustomEvent(
              'Click_Diary_Back_WriteToCalendar');
          if (controller.diaryEditingController.value.text.isEmpty) {
            Get.back();
            FocusManager.instance.primaryFocus?.unfocus();
          } else if (diaryData?.diaryContent !=
              controller.diaryEditingController.value.text) {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (ctx) {
                return DialogComponent(
                  title: "뒤로 가시겠어요?",
                  content: Text(
                    "변경된 내용이 있어요.",
                    style: kHeader6Style.copyWith(
                        color: Theme.of(context).colorScheme.textSubtitle),
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
                          color: Theme.of(context).colorScheme.textSubtitle),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    DialogButton(
                      title: "예",
                      onTap: () {
                        Get.back();
                        Get.back();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      backgroundColor: kOrange200Color,
                      textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                    ),
                  ],
                );
              },
            );
          } else if (controller.diaryEditingController.value.text.isNotEmpty) {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (ctx) {
                return DialogComponent(
                  title: "뒤로 가시겠어요?",
                  content: Text(
                    "작성 중인 모든 내용이 삭제되요.",
                    style: kHeader6Style.copyWith(
                        color: Theme.of(context).colorScheme.textSubtitle),
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
                          color: Theme.of(context).colorScheme.textSubtitle),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    DialogButton(
                      title: "예",
                      onTap: () {
                        Get.back();
                        Get.back();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      backgroundColor: kOrange200Color,
                      textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                    ),
                  ],
                );
              },
            );
          }

          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              actions: [
                Obx(
                  () => TextButton(
                    onPressed: controller.diaryValue.value.isEmpty
                        ? null
                        : () {
                            GlobalUtils.setAnalyticsCustomEvent(
                                'Click_Diary_Register');
                            Get.offNamed("/home", arguments: {"index": 0});
                            FocusManager.instance.primaryFocus?.unfocus();

                            Get.to(
                              () => DiaryDetailScreenTest(
                                date: date,
                                isStamp: false,
                                diaryData: diaryData != null
                                    ? diaryData!.copyWith(
                                        diaryContent: controller
                                            .diaryEditingController.value.text,
                                        images: controller.networkImage.value !=
                                                null
                                            ? [controller.networkImage.value!]
                                            : [],
                                      )
                                    : DiaryData(
                                        emotion: emotion,
                                        diaryContent: controller
                                            .diaryEditingController.value.text,
                                        emoticonIndex: emoticonIndex,
                                        weather: weather,
                                        images: [],
                                        wiseSayings: [],
                                        writingTopic: controller.topic.value,
                                      ),
                                imageFile: controller.croppedFile.value,
                              ),
                            );

                            Get.to(() => WriteDiaryLoadingScreen());
                          },
                    child: Text(
                      '등록',
                      style: controller.diaryValue.value.isEmpty
                          ? kHeader6Style.copyWith(
                              color:
                                  Theme.of(context).colorScheme.disabledColor)
                          : kHeader6Style.copyWith(color: kOrange350Color),
                    ),
                  ),
                ),
              ],
              title: Text(
                DateFormat('M월 d일').format(date),
                style: kHeader4Style.copyWith(
                    color: Theme.of(context).colorScheme.textTitle),
              ),
              leading: BackIcon(
                onPressed: () {
                  if (controller.diaryEditingController.value.text.isEmpty) {
                    Get.back();
                  } else if (diaryData?.diaryContent !=
                      controller.diaryEditingController.value.text) {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (ctx) {
                        return DialogComponent(
                          title: "뒤로 가시겠어요?",
                          content: Text(
                            "변경된 내용이 있어요.",
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
                              onTap: () {
                                Get.offNamed("/home", arguments: {"index": 0});
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              backgroundColor: kOrange200Color,
                              textStyle:
                                  kHeader4Style.copyWith(color: kWhiteColor),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (controller
                      .diaryEditingController.value.text.isNotEmpty) {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (ctx) {
                        return DialogComponent(
                          title: "뒤로 가시겠어요?",
                          content: Text(
                            "작성 중인 모든 내용이 삭제되요.",
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
                              onTap: () {
                                Get.offNamed("/home", arguments: {"index": 0});
                                FocusManager.instance.primaryFocus?.unfocus();
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
              ),
            ),
            body: SafeArea(
              child: FormBuilder(
                key: _fbKey,
                child: Column(
                  children: [
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
                              // Lottie.asset(
                              //   'lib/config/assets/lottie/graphic_type.json',
                              //   controller: controller.animationController,
                              //   onLoaded: (composition) {
                              //     controller.animationController
                              //       ..duration = composition.duration
                              //       ..forward();
                              //   },
                              //   repeat: true,
                              //   fit: BoxFit.fill,
                              // ),
                              Image.asset(
                                "lib/config/assets/images/character/rain.png",
                              ),
                            ],
                          ),
                          // isEditScreen
                          //     ? Container()
                          //     : Obx(
                          //         () => InkWell(
                          //           onTap: (controller.topicReset.value > 0)
                          //               ? () {
                          //                   GlobalUtils
                          //                       .setAnalyticsCustomEvent(
                          //                           'Click_Diary_Get_Topic');
                          //                   controller
                          //                       .getRandomTopic(context);
                          //                 }
                          //               : () {
                          //                   GlobalUtils.setAnalyticsCustomEvent(
                          //                       'Click_Diary_Get_Topic_Fail');
                          //                   controller.showSnackBar(
                          //                       '글감을 더 받을 수 없어요.', context);
                          //                 },
                          //           child: SvgPicture.asset(
                          //             "lib/config/assets/images/diary/write_diary/refresh.svg",
                          //           ),
                          //         ),
                          //       ),
                          Container(
                            height: 12.h,
                          ),
                          Center(
                            child: isEditScreen
                                ? Text(
                                    textAlign: TextAlign.center,
                                    diaryData!.writingTopic.value,
                                    maxLines: 2,
                                    style: kHeader3Style.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .textTitle,
                                    ),
                                  )
                                : Obx(
                                    () => Text(
                                      textAlign: TextAlign.center,
                                      controller.topic.value.value,
                                      maxLines: 2,
                                      style: kHeader3Style.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textTitle,
                                      ),
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
                                  // borderRadius: const BorderRadius.all(
                                  //   Radius.circular(24),
                                  // ),
                                  borderRadius: BorderRadius.circular(24),
                                  color:
                                      Theme.of(context).colorScheme.surface_01,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.network(
                                      weather,
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text("비"),
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
                                  color:
                                      Theme.of(context).colorScheme.surface_01,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.network(
                                      emotion.emoticon,
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text("그저그래"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          FormBuilderTextField(
                            maxLength: 500,
                            maxLines: null,
                            autofocus: true,
                            name: 'name',
                            style: kBody1Style.copyWith(
                                color: Theme.of(context).colorScheme.textBody),
                            controller: controller.diaryEditingController.value,
                            keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor:
                                Theme.of(context).colorScheme.inverseSurface,
                            decoration: InputDecoration(
                              helperText: "",
                              counterText: "",
                              hintText: '오늘 있었던 일과 기분을 자유롭게 말해보세요',
                              hintStyle:
                                  kBody1Style.copyWith(color: kGrayColor400),
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
                              controller.diaryValueLength.value = value!.length;
                              value.length == 500
                                  ? showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (ctx) {
                                        return DialogComponent(
                                          title: "글자 제한",
                                          content: Text(
                                            "500 글자까지 작성할 수 있어요.",
                                            style: kHeader6Style.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .textSubtitle),
                                          ),
                                          actionContent: [
                                            DialogButton(
                                              title: "확인 했어요",
                                              onTap: () {
                                                Get.back();
                                              },
                                              backgroundColor: kOrange200Color,
                                              textStyle: kHeader4Style.copyWith(
                                                  color: kWhiteColor),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : null;
                            },
                          ),
                          // Obx(
                          //   () => AnimatedOpacity(
                          //     opacity:
                          //         controller.shouldShowWidget.value ? 1.0 : 0.0,
                          //     duration: const Duration(milliseconds: 500),
                          //     child: Container(
                          //       width: 200.0,
                          //       height: 200.0,
                          //       color: Colors.green,
                          //     ),
                          //   ),
                          // ),
                          Obx(
                            () => (controller.croppedFile.value != null ||
                                    controller.pickedFile.value != null ||
                                    controller.networkImage.value != null)
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0.w,
                                      ),
                                      child: controller.networkImage.value !=
                                              null
                                          ? Stack(
                                              children: [
                                                Image.network(
                                                  controller
                                                      .networkImage.value!,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  right: 12,
                                                  top: 12,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller.clear();
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: kBlackColor,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      height: 24.h,
                                                      width: 24.w,
                                                      child: const Icon(
                                                        Icons.close,
                                                        size: 12,
                                                        color: kWhiteColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : controller.croppedFile.value != null
                                              ? Stack(
                                                  children: [
                                                    Image.file(
                                                      fit: BoxFit.cover,
                                                      File(controller
                                                          .croppedFile
                                                          .value!
                                                          .path),
                                                    ),
                                                    Positioned(
                                                      right: 12,
                                                      top: 12,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          controller.clear();
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: kBlackColor,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          height: 24.h,
                                                          width: 24.w,
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 12,
                                                            color: kWhiteColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox.shrink(),
                                    ),
                                  )
                                : Container(),
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
                                  GlobalUtils.setAnalyticsCustomEvent(
                                      'Click_Diary_Picture');
                                  controller
                                      .uploadImage()
                                      .then((_) => controller.cropImage());
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.h, bottom: 10.h, left: 16.w),
                                  child: SvgPicture.asset(
                                    "lib/config/assets/images/diary/write_diary/album.svg",
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                ),
                              ),
                              Obx(
                                () => InkWell(
                                  onTap: (controller.topicReset.value > 0)
                                      ? () {
                                          GlobalUtils.setAnalyticsCustomEvent(
                                              'Click_Diary_Get_Topic');
                                          controller.getRandomTopic(context);
                                        }
                                      : () {
                                          GlobalUtils.setAnalyticsCustomEvent(
                                              'Click_Diary_Get_Topic_Fail');
                                          controller.showSnackBar(
                                              '글감을 더 받을 수 없어요.', context);
                                        },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 10.h, bottom: 10.h, left: 16.w),
                                    child: SvgPicture.asset(
                                      "lib/config/assets/images/diary/write_diary/refresh.svg",
                                      width: 24.w,
                                      height: 24.h,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10.h, bottom: 10.h, right: 16.w),
                            child: Obx(
                              () => Text(
                                "${controller.diaryValueLength.value}/500",
                                style: kBody2Style.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .textTitle),
                              ),
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
      ),
    );
  }
}

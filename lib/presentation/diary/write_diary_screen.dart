import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/weather_emotion_badge_component.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/presentation/diary/write_diary_view_model.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WriteDiaryScreen extends GetView<WriteDiaryViewModel> {
  final DateTime date;
  final EmoticonData emotion;
  final String weather;
  final int emoticonIndex;
  final DiaryData? diaryData;

  WriteDiaryScreen({
    Key? key,
    required this.date,
    required this.emotion,
    required this.weather,
    required this.emoticonIndex,
    this.diaryData,
  }) : super(key: key);

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    getWriteDiaryBinding();

    if (diaryData != null) {
      controller.setDiaryData(diaryData!);
    }

    return WillPopScope(
      onWillPop: () async {
        if (controller.diaryEditingController.text.isEmpty) {
          Get.back();
        } else if (diaryData?.diaryContent !=
            controller.diaryEditingController.text) {
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
                    },
                    backgroundColor: kOrange200Color,
                    textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                  ),
                ],
              );
            },
          );
        } else if (controller.diaryEditingController.text.isNotEmpty) {
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
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            Obx(
              () => TextButton(
                onPressed: controller.diaryValue.value.isEmpty
                    ? null
                    : () {
                        showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (ctx) {
                            return DialogComponent(
                              title: "작성 완료",
                              content: Text(
                                "하루냥의 명언이 준비됐어요.",
                                style: kHeader6Style.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .textSubtitle),
                              ),
                              actionContent: [
                                DialogButton(
                                  title: "예",
                                  onTap: () {
                                    Get.offAll(
                                      () => const HomeScreen(),
                                      binding: BindingsBuilder(
                                        getHomeViewModelBinding,
                                      ),
                                    );
                                    Get.to(
                                      () => DiaryDetailScreen(
                                        date: date,
                                        isStamp: false,
                                        diaryData: diaryData != null
                                            ? diaryData!.copyWith(
                                                diaryContent: controller
                                                    .diaryEditingController
                                                    .text,
                                                images: controller.networkImage
                                                            .value !=
                                                        null
                                                    ? [
                                                        controller
                                                            .networkImage.value!
                                                      ]
                                                    : [],
                                              )
                                            : DiaryData(
                                                emotion: emotion,
                                                diaryContent: controller
                                                    .diaryEditingController
                                                    .text,
                                                emoticonIndex: emoticonIndex,
                                                weather: weather,
                                                images: [],
                                                wiseSayings: [],
                                              ),
                                        imageFile: controller.croppedFile.value,
                                      ),
                                    );
                                  },
                                  backgroundColor: kOrange200Color,
                                  textStyle: kHeader4Style.copyWith(
                                      color: kWhiteColor),
                                ),
                              ],
                            );
                          },
                        );
                      },
                child: Text(
                  '등록',
                  style: controller.diaryValue.value.isEmpty
                      ? kHeader6Style.copyWith(
                          color: Theme.of(context).colorScheme.disabledColor)
                      : kHeader6Style.copyWith(color: kOrange350Color),
                ),
              ),
            ),
          ],
          title: Text(
            DateFormat('MM월 dd일').format(date),
            style: kHeader3Style.copyWith(
                color: Theme.of(context).colorScheme.textTitle),
          ),
          leading: IconButton(
            onPressed: () {
              if (controller.diaryEditingController.text.isEmpty) {
                Get.back();
              } else if (diaryData?.diaryContent !=
                  controller.diaryEditingController.text) {
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
                              color:
                                  Theme.of(context).colorScheme.textSubtitle),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        DialogButton(
                          title: "예",
                          onTap: () {
                            Get.back();
                            Get.back();
                          },
                          backgroundColor: kOrange200Color,
                          textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                        ),
                      ],
                    );
                  },
                );
              } else if (controller.diaryEditingController.text.isNotEmpty) {
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
                              color:
                                  Theme.of(context).colorScheme.textSubtitle),
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        DialogButton(
                          title: "예",
                          onTap: () {
                            Get.back();
                            Get.back();
                          },
                          backgroundColor: kOrange200Color,
                          textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20.w,
            ),
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
                      Padding(
                        padding: EdgeInsets.only(left: 20.w, top: 8.h),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 6.0.h),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kOrange300Color,
                                ),
                                child: SvgPicture.asset(
                                  "lib/config/assets/images/character/character${controller.randomImageNumber}.svg",
                                  width: 48.w,
                                  height: 48.h,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Expanded(
                              child: Bubble(
                                alignment: Alignment.topLeft,
                                nip: BubbleNip.leftTop,
                                nipOffset: 50.w,
                                nipWidth: 17.w,
                                nipHeight: 10.h,
                                elevation: 0,
                                padding: const BubbleEdges.all(0),
                                margin: const BubbleEdges.all(0),
                                radius: const Radius.circular(24),
                                color: Theme.of(context).colorScheme.surface_02,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 24.w,
                                    top: 12.h,
                                    bottom: 12.h,
                                    right: 24.w,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '오늘 가장 기쁜 일은 \n무엇이었나요?',
                                        style: kHeader4Style.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .textTitle,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        "lib/config/assets/images/diary/write_diary/refresh.svg",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      Divider(
                        height: 1.h,
                        thickness: 12.h,
                      ),
                      Container(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          top: 16.h,
                        ),
                        child: WeatherEmotionBadgeComponent(
                          emoticon: emotion.emoticon,
                          emoticonIndex: emoticonIndex,
                          weatherIcon: weather,
                          color: Theme.of(context).colorScheme.surface_01,
                        ),
                      ),
                      FormBuilderTextField(
                        maxLength: 1000,
                        maxLines: null,
                        name: 'name',
                        style: kBody1Style.copyWith(
                            color: Theme.of(context).colorScheme.textBody),
                        controller: controller.diaryEditingController,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.center,
                        cursorColor:
                            Theme.of(context).colorScheme.inverseSurface,
                        decoration: InputDecoration(
                          helperText: "",
                          counterText: "",
                          hintText: '오늘 있었던 일과 기분을 자유롭게 말해보세요!',
                          hintStyle: kBody1Style.copyWith(color: kGrayColor400),
                          contentPadding: const EdgeInsets.only(
                            top: 12,
                            left: 20,
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
                          value!.length == 1000
                              ? showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (ctx) {
                                    return DialogComponent(
                                      title: "글자 제한",
                                      content: Text(
                                        "1000 글자까지 작성할 수 있어요.",
                                        style: kHeader6Style.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .textSubtitle),
                                      ),
                                      actionContent: [
                                        DialogButton(
                                          title: "예",
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
                      Obx(
                        () => (controller.croppedFile.value != null ||
                                controller.pickedFile.value != null ||
                                controller.networkImage.value != null)
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.0.w,
                                  ),
                                  child: controller.networkImage.value != null
                                      ? Stack(
                                          children: [
                                            Image.network(
                                              controller.networkImage.value!,
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  controller.clear();
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: kWhiteColor
                                                        .withOpacity(.6),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  height: 24.h,
                                                  width: 24.w,
                                                  child: const Icon(
                                                    Icons.close,
                                                    size: 12,
                                                    color: kBlackColor,
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
                                                      .croppedFile.value!.path),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      controller.clear();
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                        color: kWhiteColor
                                                            .withOpacity(.6),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      height: 24.h,
                                                      width: 24.w,
                                                      child: const Icon(
                                                        Icons.close,
                                                        size: 12,
                                                        color: kBlackColor,
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
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller
                              .uploadImage()
                              .then((_) => controller.cropImage());
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 10.h, bottom: 10.h, left: 16.w),
                          child: SvgPicture.asset(
                            "lib/config/assets/images/diary/write_diary/camera.svg",
                            width: 24.w,
                            height: 24.h,
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
    );
  }
}

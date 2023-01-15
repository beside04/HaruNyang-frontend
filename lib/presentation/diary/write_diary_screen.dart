import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/Emoticon/emoticon_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/weather_emotion_badge_component.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/presentation/diary/write_diary_view_model.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WriteDiaryScreen extends GetView<WriteDiaryViewModel> {
  final DateTime date;
  final EmoticonData emotion;
  final Weather weather;
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
        controller.diaryEditingController.text.isEmpty
            ? Get.back()
            : showDialog(
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
                                                weather: weather.name,
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
          leading: Obx(
            () => controller.isOnKeyboard.value
                ? IconButton(
                    onPressed: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                    icon: SvgPicture.asset(
                      "lib/config/assets/images/diary/write_diary/keyboard.svg",
                      width: 24.w,
                      height: 24.h,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      controller.diaryEditingController.text.isEmpty
                          ? Get.back()
                          : showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (ctx) {
                                return DialogComponent(
                                  title: "뒤로 가시겠어요?",
                                  content: Text(
                                    "작성 중인 모든 내용이 삭제되요.",
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
                                      onTap: () {
                                        Get.back();
                                        Get.back();
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
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20.w,
                    ),
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
                        padding:
                            EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 6.0.h),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kOrange300Color,
                                ),
                                child: SvgPicture.asset(
                                  "lib/config/assets/images/character/onboarding1.svg",
                                  width: 40.w,
                                  height: 40.h,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Expanded(
                              child: Container(
                                height: 72.h,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.surface_02,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface_02,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.w,
                                      top: 12.h,
                                      bottom: 12.h,
                                      right: 24.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '',
                                        style: kHeader4Style.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .textTitle,
                                        ),
                                      ),
                                      SvgPicture.asset(
                                        "lib/config/assets/images/diary/write_diary/refresh.svg",
                                        width: 24.w,
                                        height: 24.h,
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
                          weatherIcon: weatherDataList[weather.index].icon,
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

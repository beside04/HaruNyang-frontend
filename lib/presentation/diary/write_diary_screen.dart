import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/diary/write_diary_view_model.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WriteDiaryScreen extends GetView<WriteDiaryViewModel> {
  final DateTime date;
  final Emotion emotion;
  final Weather weather;

  WriteDiaryScreen({
    Key? key,
    required this.date,
    required this.emotion,
    required this.weather,
  }) : super(key: key);

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    getWriteDiaryBinding();
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (ctx) {
            return DialogComponent(
              title: "뒤로 가시겠어요?",
              content: Text(
                "작성 중인 모든 내용이 삭제되요.",
                style: kSubtitle3Gray600Style,
              ),
              actionContent: [
                DialogButton(
                  title: "아니요",
                  onTap: () {
                    Get.back();
                  },
                  backgroundColor: kGrayColor100,
                  textStyle: kSubtitle1Gray600Style,
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
                  backgroundColor: kPrimary2Color,
                  textStyle: kSubtitle1WhiteStyle,
                ),
              ],
            );
          },
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          centerTitle: true,
          actions: [
            Obx(
              () => TextButton(
                onPressed: controller.nicknameValue.value.isEmpty
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
                                style: kSubtitle3Gray600Style,
                              ),
                              actionContent: [
                                DialogButton(
                                  title: "예",
                                  onTap: () {
                                    Get.back();
                                    Get.back();
                                  },
                                  backgroundColor: kPrimary2Color,
                                  textStyle: kSubtitle1WhiteStyle,
                                ),
                              ],
                            );
                          },
                        );
                      },
                child: Text(
                  '등록',
                  style: controller.nicknameValue.value.isEmpty
                      ? kSubtitle3Gray300Style
                      : kSubtitle3Primary250Style,
                ),
              ),
            ),
          ],
          title: Text(
            DateFormat('MM월 dd일').format(date),
            style: kHeader3BlackStyle,
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
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (ctx) {
                          return DialogComponent(
                            title: "뒤로 가시겠어요?",
                            content: Text(
                              "작성 중인 모든 내용이 삭제되요.",
                              style: kSubtitle3Gray600Style,
                            ),
                            actionContent: [
                              DialogButton(
                                title: "아니요",
                                onTap: () {
                                  Get.back();
                                },
                                backgroundColor: kGrayColor100,
                                textStyle: kSubtitle1Gray600Style,
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
                                backgroundColor: kPrimary2Color,
                                textStyle: kSubtitle1WhiteStyle,
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: kBlackColor,
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
                                  color: kPrimary2Color,
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
                                  color: kGrayColor50,
                                  borderRadius: BorderRadius.circular(24),
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
                                        emotionDataList[emotion.index]
                                            .writeValue,
                                        style: kSubtitle1Gray950Style,
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
                        color: kGrayColor50,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          top: 16.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: kSurfaceLightColor,
                              ),
                              child: SvgPicture.asset(
                                weatherDataList[weather.index].icon,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: kSurfaceLightColor,
                              ),
                              child: SvgPicture.asset(
                                emotionDataList[emotion.index].icon,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FormBuilderTextField(
                        maxLength: 1000,
                        maxLines: null,
                        name: 'name',
                        style: kSubtitle4BlackStyle,
                        controller: controller.nicknameEditingController,
                        keyboardType: TextInputType.multiline,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          helperText: "",
                          counterText: "",
                          hintText: '오늘 있었던 일과 기분을 자유롭게 말해보세요!',
                          hintStyle: kSubtitle3Gray250Style,
                          contentPadding: const EdgeInsets.only(
                            top: 12,
                            left: 20,
                          ),
                          filled: true,
                          fillColor: kWhiteColor,
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kWhiteColor),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kWhiteColor),
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
                                        style: kSubtitle3Gray600Style,
                                      ),
                                      actionContent: [
                                        DialogButton(
                                          title: "예",
                                          onTap: () {
                                            Get.back();
                                          },
                                          backgroundColor: kPrimary2Color,
                                          textStyle: kSubtitle1WhiteStyle,
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
                                controller.pickedFile.value != null)
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.0.w,
                                  ),
                                  child: controller.croppedFile.value != null
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
                  decoration: const BoxDecoration(
                    color: kGrayColor50,
                    border: Border(
                      top: BorderSide(width: 0.4, color: kGrayColor300),
                      bottom: BorderSide(width: 0.4, color: kGrayColor300),
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

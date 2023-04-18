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
import 'package:frontend/presentation/diary/write_diary_view_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../core/utils/utils.dart';
import '../components/back_icon.dart';

class WriteDiaryScreen extends GetView<WriteDiaryViewModel> {
  final DateTime date;
  final EmoticonData emotion;
  final String weather;
  final int emoticonIndex;
  final DiaryData? diaryData;
  final bool isEditScreen;

  WriteDiaryScreen({
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
    getWriteDiaryBinding(emotion, diaryData);

    return DefaultLayout(
      screenName: 'Screen_Event_WriteDiary_WritePage',
      child: WillPopScope(
        onWillPop: () async {
          GlobalUtils.setAnalyticsCustomEvent(
              'Click_Diary_Back_WriteToCalendar');
          if (controller.diaryEditingController.text.isEmpty) {
            Get.back();
            FocusManager.instance.primaryFocus?.unfocus();
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
                        FocusManager.instance.primaryFocus?.unfocus();
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
                                        Get.offNamed("/home",
                                            arguments: {"index": 0});
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();

                                        Get.to(
                                          () => DiaryDetailScreen(
                                            date: date,
                                            isStamp: false,
                                            diaryData: diaryData != null
                                                ? diaryData!.copyWith(
                                                    diaryContent: controller
                                                        .diaryEditingController
                                                        .text,
                                                    images: controller
                                                                .networkImage
                                                                .value !=
                                                            null
                                                        ? [
                                                            controller
                                                                .networkImage
                                                                .value!
                                                          ]
                                                        : [],
                                                  )
                                                : DiaryData(
                                                    emotion: emotion,
                                                    diaryContent: controller
                                                        .diaryEditingController
                                                        .text,
                                                    emoticonIndex:
                                                        emoticonIndex,
                                                    weather: weather,
                                                    images: [],
                                                    wiseSayings: [],
                                                    writingTopic:
                                                        controller.topic.value,
                                                  ),
                                            imageFile:
                                                controller.croppedFile.value,
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
                      .diaryEditingController.text.isNotEmpty) {
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
                          Padding(
                            padding: EdgeInsets.only(left: 20.w, top: 20.h),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6.h),
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
                                SizedBox(
                                  width: 12.w,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 80.h,
                                    margin: EdgeInsets.only(
                                      right: 20.w,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(24),
                                        bottomRight: Radius.circular(24),
                                        bottomLeft: Radius.circular(24),
                                      ),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface_02,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 12.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: isEditScreen
                                              ? Text(
                                                  diaryData!.writingTopic.value,
                                                  maxLines: 2,
                                                  style: kHeader4Style.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .textTitle,
                                                  ),
                                                )
                                              : Obx(
                                                  () => Text(
                                                    controller
                                                        .topic.value.value,
                                                    maxLines: 2,
                                                    style:
                                                        kHeader4Style.copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .textTitle,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        isEditScreen
                                            ? Container()
                                            : Obx(
                                                () => InkWell(
                                                  onTap: (controller.topicReset
                                                              .value >
                                                          0)
                                                      ? () {
                                                          GlobalUtils
                                                              .setAnalyticsCustomEvent(
                                                                  'Click_Diary_Get_Topic');
                                                          controller
                                                              .getRandomTopic(
                                                                  context);
                                                        }
                                                      : () {
                                                          GlobalUtils
                                                              .setAnalyticsCustomEvent(
                                                                  'Click_Diary_Get_Topic_Fail');
                                                          controller.showSnackBar(
                                                              '글감을 더 받을 수 없어요.',
                                                              context);
                                                        },
                                                  child: SvgPicture.asset(
                                                    "lib/config/assets/images/diary/write_diary/refresh.svg",
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
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
                              top: 20.h,
                            ),
                            child: WeatherEmotionBadgeWritingDiary(
                              emoticon: emotion.emoticon,
                              emoticonIndex: emoticonIndex,
                              weatherIcon: weather,
                              color: Theme.of(context).colorScheme.surface_01,
                            ),
                          ),
                          FormBuilderTextField(
                            maxLength: 1000,
                            maxLines: null,
                            autofocus: true,
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
        ),
      ),
    );
  }
}

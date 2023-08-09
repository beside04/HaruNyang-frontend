import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/weather_emotion_badge_writing_diary.dart';
import 'package:frontend/presentation/diary/write_diary_loading_screen.dart';
import 'package:frontend/presentation/diary/write_diary_view_model.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';

import '../../core/utils/utils.dart';
import '../components/back_icon.dart';

class WriteDiaryScreen extends GetView<WriteDiaryViewModel> {
  final DateTime date;
  final String emotion;
  final String weather;
  final DiaryData? diaryData;
  final bool isEditScreen;

  WriteDiaryScreen({
    Key? key,
    required this.date,
    required this.emotion,
    required this.weather,
    required this.isEditScreen,
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
          if (controller.diaryEditingController.value.text.isEmpty) {
            Navigator.pop(context);
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
                        Navigator.pop(context);
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
                        Navigator.pop(context);
                        Navigator.pop(context);

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
                    "작성 중인 모든 내용이 삭제되어요.",
                    style: kHeader6Style.copyWith(
                        color: Theme.of(context).colorScheme.textSubtitle),
                  ),
                  actionContent: [
                    DialogButton(
                      title: "아니요",
                      onTap: () {
                        Navigator.pop(context);
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
                        Navigator.pop(context);
                        Navigator.pop(context);

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
              elevation: 0,
              actions: [
                Obx(
                  () => TextButton(
                    onPressed: controller.diaryValue.value.isEmpty
                        ? null
                        : () async {
                            getWriteDiaryLoadingBinding();
                            GlobalUtils.setAnalyticsCustomEvent(
                                'Click_Diary_Register');
                            if (controller.croppedFile.value != null) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                    onWillPop: () async => false,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                      child: Lottie.asset(
                                        'lib/config/assets/lottie/loading_haru.json',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                },
                              );

                              try {
                                await controller.uploadImage();
                                // ignore: use_build_context_synchronously
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              } catch (e) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            }

                            Get.offNamed("/home", arguments: {"index": 0});
                            FocusManager.instance.primaryFocus?.unfocus();

                            Get.to(
                              () => WriteDiaryLoadingScreen(
                                diaryData: DiaryData(
                                    id: diaryData?.id,
                                    diaryContent: controller
                                        .diaryEditingController.value.text,
                                    feeling: emotion,
                                    feelingScore: 1,
                                    weather: weather,
                                    targetDate:
                                        DateFormat('yyyy-MM-dd').format(date),
                                    topic: controller.topic.value.value,
                                    image: controller.firebaseImageUrl.value ==
                                            ""
                                        ? Get.find<DiaryController>()
                                                .diaryDetailData
                                                .value
                                                ?.image ??
                                            ""
                                        : controller.firebaseImageUrl.value),
                                date: date,
                                isEditScreen: isEditScreen,
                              ),
                            );
                          },
                    child: Text(
                      '등록',
                      style: controller.diaryValue.value.isEmpty
                          ? kHeader6Style.copyWith(
                              color: Theme.of(context).colorScheme.textDisabled)
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
                    Navigator.pop(context);
                    Get.find<DiaryController>().resetDiary();
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
                                Navigator.pop(context);
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
                                Get.find<DiaryController>().resetDiary();
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
                            "작성 중인 모든 내용이 삭제되어요.",
                            style: kHeader6Style.copyWith(
                                color:
                                    Theme.of(context).colorScheme.textSubtitle),
                          ),
                          actionContent: [
                            DialogButton(
                              title: "아니요",
                              onTap: () {
                                Navigator.pop(context);
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
                                Get.find<DiaryController>().resetDiary();
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
                          SizedBox(
                            height: 188.h,
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.asset(
                                    getWeatherCharacter(weather),
                                    height: 196.h,
                                  ),
                                ),
                                getWeatherAnimation(weather) == ""
                                    ? Container()
                                    : RiveAnimation.asset(
                                        getWeatherAnimation(weather),
                                        fit: BoxFit.fill,
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Center(
                            child: Obx(
                              () => Text(
                                textAlign: TextAlign.center,
                                controller.topic.value.value,
                                maxLines: 2,
                                style: kHeader3Style.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.textTitle,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 12.h,
                          ),
                          WeatherEmotionBadgeWritingDiary(
                            emoticon: getEmoticonImage(emotion),
                            emoticonDesc: getEmoticonValue(emotion),
                            weatherIcon: getWeatherImage(weather),
                            weatherIconDesc: getWeatherValue(weather),
                            color: Theme.of(context).colorScheme.surface_01,
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
                                                Navigator.pop(context);
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
                            () => Get.find<DiaryController>()
                                        .diaryDetailData
                                        .value ==
                                    null
                                ? Container()
                                : Get.find<DiaryController>()
                                            .diaryDetailData
                                            .value!
                                            .image ==
                                        ''
                                    ? Container()
                                    : Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 20.0.w,
                                          ),
                                          child: Stack(
                                            children: [
                                              Image.network(
                                                Get.find<DiaryController>()
                                                    .diaryDetailData
                                                    .value!
                                                    .image,
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
                                                        const EdgeInsets.all(6),
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
                                          ),
                                        ),
                                      ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  GlobalUtils.setAnalyticsCustomEvent(
                                      'Click_Diary_Picture');
                                  controller
                                      .selectDeviceImage()
                                      .then((_) => controller.cropImage());
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.h, bottom: 10.h, left: 16.w),
                                  child: SvgPicture.asset(
                                    "lib/config/assets/images/diary/write_diary/album.svg",
                                    color: kGrayColor600,
                                    width: 24.w,
                                    height: 24.h,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  GlobalUtils.setAnalyticsCustomEvent(
                                      'Click_Diary_Get_Topic');
                                  controller.getRandomTopic();
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.h, bottom: 10.h, left: 16.w),
                                  child: SvgPicture.asset(
                                    "lib/config/assets/images/diary/write_diary/refresh.svg",
                                    width: 24.w,
                                    color: kGrayColor600,
                                    height: 24.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10.h, bottom: 10.h, right: 16.w),
                            child: Row(
                              children: [
                                Obx(
                                  () => Text(
                                    "${controller.diaryValueLength.value}",
                                    style: kBody2Style.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textTitle),
                                  ),
                                ),
                                Text(
                                  "/500",
                                  style: kBody2Style.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .textLowEmphasis),
                                ),
                              ],
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

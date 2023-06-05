import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/emoticon_weather/weather_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/main.dart';
import 'package:frontend/presentation/components/back_icon.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/weather_emotion_badge_writing_diary.dart';
import 'package:frontend/presentation/diary/components/diary_loading_widget.dart';
import 'package:frontend/presentation/diary/components/diary_popup_menu_item.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_comment_screen.dart';
import 'package:frontend/presentation/diary/write_diary_screen.dart';
import 'package:frontend/presentation/diary/write_diary_screen_test.dart';
import 'package:frontend/presentation/diary/write_diary_view_model.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/utils.dart';

class DiaryDetailScreenTest extends StatefulWidget {
  final DateTime date;
  final DiaryData diaryData;
  final CroppedFile? imageFile;

  const DiaryDetailScreenTest({
    Key? key,
    required this.date,
    required this.diaryData,
    this.imageFile,
  }) : super(key: key);

  @override
  State<DiaryDetailScreenTest> createState() => _DiaryDetailScreenTestState();
}

class _DiaryDetailScreenTestState extends State<DiaryDetailScreenTest> {
  final diaryController = Get.find<DiaryController>();

  @override
  void initState() {
    diaryController.getDiaryDetail(widget.diaryData.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_DiaryRead',
      child: WillPopScope(
        onWillPop: () async {
          Get.offAll(
            () => const HomeScreen(),
            binding: BindingsBuilder(
              getHomeViewModelBinding,
            ),
          );
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              DateFormat('M월 d일').format(widget.date),
              style: kHeader4Style.copyWith(
                  color: Theme.of(context).colorScheme.textTitle),
            ),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.to(
                  () => DiaryCommentScreen(
                    date: widget.date,
                    diaryDetailData: diaryController.diaryDetailData.value!,
                  ),
                );
              },
              icon: Icon(Icons.note),
            ),
          ),
          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "lib/config/assets/images/character/write_character.png",
                      height: 200.h,
                      width: 200.h,
                    ),
                  ),
                  WeatherEmotionBadgeWritingDiary(
                    emoticon: getEmoticonImage(widget.diaryData.feeling),
                    emoticonDesc: getEmoticonValue(widget.diaryData.feeling),
                    weatherIcon: getWeatherImage(widget.diaryData.weather),
                    weatherIconDesc: getWeatherValue(widget.diaryData.weather),
                    color: Theme.of(context).colorScheme.surface_01,
                  ),
                  Container(
                    height: 12.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20.w, top: 24.h, right: 20.w, bottom: 12.h),
                    child: Obx(() => Text(
                          "${diaryController.diaryDetailData.value?.diaryContent}",
                          maxLines: 10,
                          style: kBody1Style.copyWith(
                              color: Theme.of(context).colorScheme.textTitle),
                        )),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            GlobalUtils.setAnalyticsCustomEvent(
                                'Click_Diary_Update');
                            Get.to(() => WriteDiaryScreenTest(
                                  date: widget.date,
                                  emotion: widget.diaryData.feeling,
                                  diaryData: widget.diaryData,
                                  weather: widget.diaryData.weather,
                                  isEditScreen: true,
                                ));
                          },
                          child: Image.asset(
                            "lib/config/assets/images/diary/write_diary/pen.png",
                            width: 24.w,
                            height: 24.h,
                          ),
                        ),
                        SizedBox(
                          width: 12.h,
                        ),
                        InkWell(
                          onTap: () {
                            GlobalUtils.setAnalyticsCustomEvent(
                                'Click_Diary_Delete');
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return DialogComponent(
                                  title: "삭제 하실래요?",
                                  content: Text(
                                    "삭제 후 일기를 복원 할 수 없어요",
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
                                      onTap: () async {
                                        Get.back();
                                        await diaryController
                                            .deleteDiary(widget.diaryData.id!);

                                        await showDialog(
                                          barrierDismissible: false,
                                          context: navigatorKey.currentContext!,
                                          builder: (ctx) {
                                            return WillPopScope(
                                              onWillPop: () async => false,
                                              child: DialogComponent(
                                                title: "삭제 완료",
                                                content: Text(
                                                  "일기를 삭제했어요.",
                                                  style: kHeader6Style.copyWith(
                                                      color: Theme.of(ctx)
                                                          .colorScheme
                                                          .textSubtitle),
                                                ),
                                                actionContent: [
                                                  DialogButton(
                                                    title: "확인",
                                                    onTap: () {
                                                      Get.offAll(
                                                        () =>
                                                            const HomeScreen(),
                                                        binding:
                                                            BindingsBuilder(
                                                          getHomeViewModelBinding,
                                                        ),
                                                      );
                                                    },
                                                    backgroundColor:
                                                        kOrange200Color,
                                                    textStyle:
                                                        kHeader4Style.copyWith(
                                                            color: kWhiteColor),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
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
                          child: Image.asset(
                            "lib/config/assets/images/diary/write_diary/trash.png",
                            width: 24.w,
                            height: 24.h,
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
    );
  }
}

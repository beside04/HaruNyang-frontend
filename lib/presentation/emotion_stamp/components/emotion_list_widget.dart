import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen_test.dart';
import 'package:frontend/presentation/emotion_stamp/components/emotion_card_diary_widget.dart';
import 'package:get/get.dart';

class EmotionListWidget extends StatefulWidget {
  const EmotionListWidget({super.key});

  @override
  State<EmotionListWidget> createState() => _EmotionListWidgetState();
}

class _EmotionListWidgetState extends State<EmotionListWidget> {
  final diaryController = Get.find<DiaryController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller:
            PageController(initialPage: diaryController.currentPageCount),
        itemBuilder: (context, i) {
          return ListView.builder(
            itemCount: diaryController.state.value.diaryCardDataList.isEmpty
                ? 1
                : diaryController.state.value.diaryCardDataList.length,
            itemBuilder: (BuildContext context, int index) {
              return diaryController.state.value.diaryCardDataList.isEmpty
                  ? Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 121.h,
                            ),
                            Center(
                              child: Image.asset(
                                "lib/config/assets/images/character/haru_empty_case.png",
                                width: 280.w,
                                height: 280.h,
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Text(
                              "작성한 일기가 없어요",
                              style: kHeader3Style.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "일기를 쓰고 하루냥의 한마디를 받아보세요!",
                              style: kBody2Style.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .textSubtitle),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //if (!isUsedWeekName(weekName))
                        Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Text(
                            "${diaryController.state.value.diaryCardDataList[index].title}번째 주",
                            style: kHeader3Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
                          ),
                        ),
                        Column(
                          children: diaryController.state.value
                              .diaryCardDataList[index].diaryDataList
                              .map((diary) => Padding(
                                    padding: EdgeInsets.only(
                                      top: 20.h,
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => DiaryDetailScreenTest(
                                            diaryId: diary.id!,
                                            date: DateTime.parse(
                                                diary.targetDate),
                                            diaryData: diary,
                                            isNewDiary: false,
                                          ),
                                        );
                                      },
                                      child: EmotionCardDiaryWidget(
                                        diaryData: diary,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    );
            },
          );
        },
      ),
    );
  }
}

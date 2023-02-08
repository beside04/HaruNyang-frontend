import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
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
                              child: SvgPicture.asset(
                                "lib/config/assets/images/character/character6.svg",
                                width: 240.w,
                                height: 240.h,
                              ),
                            ),
                            SizedBox(
                              height: 45.h,
                            ),
                            Text(
                              "작성한 일기가 없어요",
                              style: kHeader5Style.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.textTitle),
                            )
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
                                          () => DiaryDetailScreen(
                                            date:
                                                DateTime.parse(diary.writtenAt),
                                            isStamp: true,
                                            diaryData: diary,
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/ui/screen/emotion_stamp/components/emotion_card_diary_widget.dart';

class EmotionListWidget extends ConsumerStatefulWidget {
  const EmotionListWidget({super.key});

  @override
  EmotionListWidgetState createState() => EmotionListWidgetState();
}

class EmotionListWidgetState extends ConsumerState<EmotionListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: PageController(initialPage: ref.watch(diaryProvider).currentPageCount),
        itemBuilder: (context, i) {
          return ListView.builder(
            itemCount: ref.watch(diaryProvider).diaryCardDataList.isEmpty ? 1 : ref.watch(diaryProvider).diaryCardDataList.length,
            itemBuilder: (BuildContext context, int index) {
              return ref.watch(diaryProvider).diaryCardDataList.isEmpty
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
                              style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "일기를 쓰고 하루냥의 쪽지를 받아보세요!",
                              style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
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
                            "${ref.watch(diaryProvider).diaryCardDataList[index].title}번째 주",
                            style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                          ),
                        ),
                        Column(
                          children: ref
                              .watch(diaryProvider)
                              .diaryCardDataList[index]
                              .diaryDataList
                              .map((diary) => Padding(
                                    padding: EdgeInsets.only(
                                      top: 16.h,
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    child: EmotionCardDiaryWidget(
                                      diaryData: diary,
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

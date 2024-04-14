import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domains/diary/provider/diary_select_provider.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/screen/diary/components/emoticon_icon_button.dart';
import 'package:frontend/ui/screen/diary/write_diary_screen.dart';
import 'package:frontend/utils/utils.dart';

class EmotionModal extends ConsumerWidget {
  final DateTime date;

  const EmotionModal({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, child) {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        bottom: ref.watch(diarySelectProvider).isEmotionModal ? -276.h : 0,
        child: Consumer(builder: (context, ref, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: MediaQuery.of(context).size.width,
            height: 300.h,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.backgroundModal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.w),
                  topRight: Radius.circular(24.w),
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 28.w, top: 28.h),
                    child: Row(
                      children: [
                        Text(
                          "기분",
                          style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.w, top: 75.h),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: ref.watch(diarySelectProvider).emoticonDataList.length,
                      itemBuilder: (BuildContext context, int i) {
                        return Consumer(builder: (context, ref, child) {
                          return EmoticonIconButton(
                            name: ref.watch(diarySelectProvider).emoticonDataList[i].desc,
                            icon: ref.watch(diarySelectProvider).emoticonDataList[i].emoticon,
                            selected: ref.watch(diarySelectProvider).selectedEmotion == ref.watch(diarySelectProvider).emoticonDataList[i],
                            onPressed: () {
                              GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Emotion_${ref.watch(diarySelectProvider).emoticonDataList[i].id}');
                              ref.watch(diarySelectProvider.notifier).setSelectedEmoticon(ref.watch(diarySelectProvider).emoticonDataList[i]);
                            },
                          );
                        });
                      },
                    ),
                  ),
                  // Obx(
                  //   () => Padding(
                  //     padding: EdgeInsets.only(left: 6.w, top: 190.h),
                  //     child: controller.selectedEmotion.value.emoticon.isEmpty
                  //         ? Container()
                  //         : buildSlider(context),
                  //   ),
                  // ),
                  Consumer(builder: (context, ref, child) {
                    return BottomButton(
                      title: '일기쓰기',
                      onTap: ref.watch(diarySelectProvider).selectedEmotion.emoticon.isEmpty
                          ? null
                          : () {
                              GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Next_EmotionToWrite');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WriteDiaryScreen(
                                          date: date,
                                          emotion: ref.watch(diarySelectProvider).selectedEmotion.value,
                                          weather: ref.watch(diarySelectProvider).selectedWeather.value,
                                          isEditScreen: false,
                                          isAutoSave: false,
                                        )),
                              );
                            },
                    );
                  })
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}

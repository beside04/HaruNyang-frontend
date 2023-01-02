import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class EmotionListWidget extends StatefulWidget {
  const EmotionListWidget({
    Key? key,
    required this.focusedDate,
    required this.onSetFocusDay,
    required this.diaryListDataList,
  }) : super(key: key);

  final DateTime focusedDate;
  final Function(DateTime) onSetFocusDay;
  final Map<String, Object> diaryListDataList;

  @override
  State<EmotionListWidget> createState() => _EmotionListWidgetState();
}

class _EmotionListWidgetState extends State<EmotionListWidget> {
  int currentPageCount = 250;
  int controllerTempCount = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(initialPage: currentPageCount),
      onPageChanged: (currentPage) {
        // controllerTempCount와 비교해서 currentPage와 비교해서
        // currentPage가 더 크면 1달 추가 그게 아니라면
        // 1달 감소

        if (controllerTempCount < currentPage) {
          widget
              .onSetFocusDay(Jiffy(widget.focusedDate).add(months: 1).dateTime);
        } else {
          widget.onSetFocusDay(
              Jiffy(widget.focusedDate).subtract(months: 1).dateTime);
        }

        controllerTempCount = currentPage;
      },
      itemBuilder: (context, i) {
        return ListView.builder(
          itemCount: (widget.diaryListDataList["key_ordered"] as List).isEmpty
              ? 1
              : (widget.diaryListDataList["key_ordered"] as List).length,
          itemBuilder: (BuildContext context, int index) {
            return (widget.diaryListDataList["key_ordered"] as List).isEmpty
                ? Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 121.h,
                          ),
                          Center(
                            child: SvgPicture.asset(
                              "lib/config/assets/images/character/onboarding2.svg",
                              width: 240.w,
                              height: 240.h,
                            ),
                          ),
                          SizedBox(
                            height: 45.h,
                          ),
                          Text(
                            "작성한 일기가 없어요",
                            style: kSubtitle2BlackStyle,
                          )
                        ],
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: () {
                      List<dynamic> itemList =
                          ((widget.diaryListDataList["values"] as Map)[
                              (widget.diaryListDataList["key_ordered"]
                                  as List)[index]]);

                      //Get.delete<DiaryDetailViewModel>();

                      Get.to(
                        () => DiaryDetailScreen(
                          date: DateTime.parse(itemList[0].writtenAt),
                          isStamp: true,
                          diaryData: List<DiaryData>.from(itemList)[0],
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.h, left: 20.w),
                          child: Text(
                            "${(widget.diaryListDataList["key_ordered"] as List)[index]}번째 주",
                            style: kSubtitle1BlackStyle,
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              (widget.diaryListDataList["values"] as Map)[
                                      (widget.diaryListDataList["key_ordered"]
                                          as List)[index]]
                                  .length,
                          itemBuilder: (BuildContext context, int i) {
                            var itemList =
                                (widget.diaryListDataList["values"] as Map)[
                                    (widget.diaryListDataList["key_ordered"]
                                        as List)[index]][i];
                            return Padding(
                              padding: EdgeInsets.only(
                                top: 20.h,
                                left: 20.w,
                                right: 20.w,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kGrayColor50,
                                  borderRadius: BorderRadius.circular(20.0.w),
                                ),
                                child: Padding(
                                  padding: kPrimaryPadding,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat.MMMEd("ko_KR").format(
                                                DateTime.parse(
                                                    itemList.writtenAt)),
                                            style: kSubtitle2BlackStyle,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(4.w),
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: kWhiteColor,
                                                ),
                                                child: SvgPicture.asset(
                                                  "lib/config/assets/images/diary/weather/sunny.svg",
                                                  width: 16.w,
                                                  height: 16.h,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 7.w,
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.h,
                                                    horizontal: 8.w),
                                                decoration: BoxDecoration(
                                                  color: kWhiteColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.0.w),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SvgPicture.network(
                                                      itemList.emotion.emoticon,
                                                      width: 16.w,
                                                      height: 16.h,
                                                    ),
                                                    SizedBox(
                                                      width: 6.w,
                                                    ),
                                                    getEmotionTextWidget(
                                                      itemList.emoticonIndex,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12.h,
                                      ),
                                      itemList.images[0] == ""
                                          ? Container()
                                          : Column(
                                              children: [
                                                Center(
                                                  child: Image.network(
                                                    "${itemList.images[0]}",
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 12.h,
                                                ),
                                              ],
                                            ),
                                      Text(
                                        itemList.diaryContent,
                                        style: kBody1BlackStyle,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
          },
        );
      },
    );
  }
}

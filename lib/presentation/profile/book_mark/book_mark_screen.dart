import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/presentation/components/back_icon.dart';
import 'package:frontend/presentation/profile/components/book_mark_list.dart';
import 'package:get/get.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  final diaryController = Get.find<DiaryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '북마크',
          style: kHeader4Style.copyWith(
              color: Theme.of(context).colorScheme.textTitle),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: Theme.of(context).colorScheme.border,
            height: 1.0,
          ),
        ),
        leading: BackIcon(
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 8.0.h),
          child: Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemCount: diaryController.state.value.bookmarkList.isEmpty
                  ? 1
                  : diaryController.state.value.bookmarkList.length,
              itemBuilder: (BuildContext context, int index) {
                return diaryController.state.value.bookmarkList.isEmpty
                    ? Column(
                        children: [
                          SizedBox(
                            height: 121.h,
                          ),
                          Center(
                            child: SvgPicture.asset(
                              "lib/config/assets/images/character/character3.svg",
                              width: 280.w,
                              height: 280.h,
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            "작성한 내용이 없어요",
                            style: kHeader3Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            "일기를 쓰고 하루냥이 준 위로를 저장해보세요!",
                            style: kBody2Style.copyWith(
                                color:
                                    Theme.of(context).colorScheme.textSubtitle),
                          )
                        ],
                      )
                    : Obx(
                        () => BookMarkList(
                          date: DateTime.parse(diaryController
                              .state.value.bookmarkList[index].createdAt),
                          isBookMark: true,
                          title: diaryController.state.value.bookmarkList[index]
                              .wiseSaying.message,
                          name: diaryController.state.value.bookmarkList[index]
                              .wiseSaying.author,
                          onTap: () {
                            diaryController.deleteBookmarkByBookmarkId(
                                diaryController
                                    .state.value.bookmarkList[index].id);
                          },
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

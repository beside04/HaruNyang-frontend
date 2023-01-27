import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
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
          style: kHeader3Style.copyWith(
              color: Theme.of(context).colorScheme.textTitle),
        ),
        elevation: 0.5,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 8.0.h),
          child: Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemCount: diaryController.state.value.bookmarkList.length,
              itemBuilder: (BuildContext context, int index) {
                return Obx(
                  () => BookMarkList(
                    date: DateTime(2022, 12, 15),
                    isBookMark: false,
                    title: diaryController
                        .state.value.bookmarkList[index].wiseSaying.message,
                    name: diaryController
                        .state.value.bookmarkList[index].wiseSaying.author,
                    onTap: () {
                      diaryController.deleteBookmarkByBookmarkId(
                          diaryController.state.value.bookmarkList[index].id);
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/profile/book_mark/book_mark_view_model.dart';
import 'package:frontend/presentation/profile/components/book_mark_list.dart';
import 'package:get/get.dart';

class BookMarkScreen extends GetView<BookMarkViewModel> {
  const BookMarkScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getBookMarkViewModelBinding();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '북마크',
          style: Theme.of(context).textTheme.headline3,
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
        child: ListView(
          children: [
            SizedBox(
              height: 8.h,
            ),
            Obx(
              () => BookMarkList(
                date: DateTime(2022, 12, 15),
                isBookMark: controller.isBookmark.value,
                title:
                    '가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사',
                name: '이름',
                onTap: () {
                  controller.toggleBookmark();
                },
              ),
            ),
            Obx(
              () => BookMarkList(
                date: DateTime(2022, 12, 20),
                isBookMark: controller.isBookmark.value,
                title:
                    '가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사',
                name: '이름',
                onTap: () {
                  controller.toggleBookmark();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

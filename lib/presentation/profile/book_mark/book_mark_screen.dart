import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/profile/book_mark/book_mark_view_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
          style: kHeader3BlackStyle,
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
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  // color: kWhiteColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      // color: Colors.black.withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    // color: kWhiteColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: kPrimaryPadding,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  DateFormat('yyyy.MM.dd')
                                      .format(DateTime(2022, 12, 15)),
                                  style: kSubtitle1BlackStyle,
                                )
                              ],
                            ),
                            Obx(
                              () => controller.isBookmark.value
                                  ? GestureDetector(
                                      onTap: () {
                                        controller.toggleBookmark();
                                      },
                                      child: const Icon(Icons.bookmark_border),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        controller.toggleBookmark();
                                      },
                                      child: const Icon(
                                        Icons.bookmark,
                                        // color: kPrimaryColor,
                                      ),
                                    ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          "가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사",
                          style: kBody1BlackStyle,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "이름",
                            style: kBody2BlackStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  // color: kWhiteColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      // color: Colors.black.withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    // color: kWhiteColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: kPrimaryPadding,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  DateFormat('yyyy.MM.dd')
                                      .format(DateTime(2022, 12, 15)),
                                  style: kSubtitle1BlackStyle,
                                )
                              ],
                            ),
                            Obx(
                              () => controller.isBookmark.value
                                  ? GestureDetector(
                                      onTap: () {
                                        controller.toggleBookmark();
                                      },
                                      child: const Icon(Icons.bookmark_border),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        controller.toggleBookmark();
                                      },
                                      child: const Icon(
                                        Icons.bookmark,
                                        // color: kPrimaryColor,
                                      ),
                                    ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          "가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사",
                          style: kBody1BlackStyle,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "이름",
                            style: kBody2BlackStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  // color: kWhiteColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.w),
                  ),
                  boxShadow: [
                    BoxShadow(
                      // color: Colors.black.withOpacity(0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    // color: kWhiteColor,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: kPrimaryPadding,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  DateFormat('yyyy.MM.dd')
                                      .format(DateTime(2022, 12, 15)),
                                  style: kSubtitle1BlackStyle,
                                )
                              ],
                            ),
                            Obx(
                              () => controller.isBookmark.value
                                  ? GestureDetector(
                                      onTap: () {
                                        controller.toggleBookmark();
                                      },
                                      child: const Icon(Icons.bookmark_border),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        controller.toggleBookmark();
                                      },
                                      child: const Icon(
                                        Icons.bookmark,
                                        // color: kPrimaryColor,
                                      ),
                                    ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          "가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사",
                          style: kBody1BlackStyle,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "이름",
                            style: kBody2BlackStyle,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

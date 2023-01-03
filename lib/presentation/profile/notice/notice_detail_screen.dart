import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NoticeDetailScreen extends StatelessWidget {
  const NoticeDetailScreen({
    super.key,
    required this.title,
    required this.date,
    required this.isImportant,
    required this.content,
  });

  final String title;
  final DateTime date;
  final bool isImportant;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kBlackColor),
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
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
            Padding(
              padding: EdgeInsets.only(
                top: 28.h,
                left: 20.w,
                right: 20.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isImportant
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.w),
                            color: kPrimaryColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0.h, horizontal: 6.0.w),
                            child: Text(
                              '중요',
                              style: kCaption1WhiteStyle,
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 13.h,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 9.h,
                  ),
                  Text(
                    DateFormat('yyyy.MM.dd').format(date),
                    style: kBody2Gray400Style,
                  ),
                  SizedBox(
                    height: 9.h,
                  ),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

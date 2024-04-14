import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
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
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_Notice_${DateFormat('yyyy.MM.dd').format(date)}',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              color: Theme.of(context).colorScheme.border,
              height: 1.0,
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
                              color: kOrange200Color,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 6.0.w),
                              child: Text(
                                '중요',
                                style: kCaption1Style.copyWith(color: kWhiteColor),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 13.h,
                    ),
                    Text(
                      DateFormat('yyyy.MM.dd').format(date),
                      style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textLowEmphasis),
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    Text(
                      content.replaceAll(r'\n', '\n'),
                      style: kBody1Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

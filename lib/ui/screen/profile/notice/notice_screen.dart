import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domains/profile/provider/notice/notice_provider.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/screen/profile/components/notice_button.dart';
import 'package:frontend/ui/screen/profile/notice/notice_detail_screen.dart';

class NoticeScreen extends ConsumerWidget {
  const NoticeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_Notice',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '공지사항',
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
          leading: BackIcon(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Consumer(builder: (context, ref, child) {
            return ListView(
              children: [
                SizedBox(
                  height: 8.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.0.w, top: 17.h, bottom: 17.h),
                  child: Text(
                    '총 ${ref.watch(noticeProvider).length}건',
                    style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                  ),
                ),
                Divider(
                  thickness: 1.h,
                ),
                ...ref
                    .watch(noticeProvider)
                    .map((e) => NoticeButton(
                          title: e.title,
                          date: DateTime.parse(e.createdAt),
                          isImportant: false,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoticeDetailScreen(
                                  title: e.title,
                                  date: DateTime.parse(e.createdAt),
                                  isImportant: false,
                                  content: e.content,
                                ),
                              ),
                            );
                          },
                        ))
                    .toList(),
              ],
            );
          }),
        ),
      ),
    );
  }
}

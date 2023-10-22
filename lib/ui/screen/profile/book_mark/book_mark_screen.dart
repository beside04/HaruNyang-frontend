import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/toast.dart';
import 'package:frontend/ui/screen/profile/components/book_mark_list.dart';

class BookMarkScreen extends ConsumerWidget {
  const BookMarkScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_Bookmark',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '북마크',
            style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
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
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 8.0.h),
            child: Consumer(builder: (context, ref, child) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: ref.watch(diaryProvider).bookmarkList.isEmpty ? 1 : ref.watch(diaryProvider).bookmarkList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ref.watch(diaryProvider).bookmarkList.isEmpty
                      ? Column(
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
                              "작성한 내용이 없어요",
                              style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "일기를 쓰고 하루냥이 준 위로를 저장해보세요!",
                              style: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                            )
                          ],
                        )
                      : Consumer(builder: (context, ref, child) {
                          return BookMarkList(
                            date: DateTime.parse(ref.watch(diaryProvider).bookmarkList[index].createAt),
                            isBookMark: true,
                            title: ref.watch(diaryProvider).bookmarkList[index].message,
                            name: ref.watch(diaryProvider).bookmarkList[index].author,
                            onTap: () {
                              ref.watch(diaryProvider.notifier).deleteBookmarkByBookmarkId(
                                    ref.watch(diaryProvider).bookmarkList[index].id!,
                                    index,
                                  );
                              toast(
                                context: context,
                                text: '북마크를 삭제했어요.',
                                isCheckIcon: true,
                              );
                            },
                          );
                        });
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

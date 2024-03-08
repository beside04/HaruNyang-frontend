import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';
import 'package:frontend/domains/bookmark/bookmark_list_state_provider.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/toast.dart';
import 'package:frontend/ui/screen/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/ui/screen/profile/components/book_mark_emoticon_icon_button.dart';
import 'package:frontend/ui/screen/profile/components/book_mark_list.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';

class BookMarkScreen extends ConsumerStatefulWidget {
  const BookMarkScreen({super.key});

  @override
  BookMarkScreenState createState() => BookMarkScreenState();
}

class BookMarkScreenState extends ConsumerState<BookMarkScreen> {
  late final PagingController<int, CommentData> _bookMarkPagingController = ref.read(bookmarkListStateProvider);

  @override
  void initState() {
    // _bookMarkPagingController = ref.read(bookmarkListStateProvider);
    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    _bookMarkPagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_Bookmark',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '편지 보관함',
            style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
          ),
          elevation: 0,
          leading: BackIcon(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Consumer(builder: (context, ref, child) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                                  shadowColor: Colors.transparent,
                                  disabledBackgroundColor: Theme.of(context).colorScheme.disabledColor,
                                  backgroundColor: ref.watch(bookmarkListStateProvider.notifier).emotionValue == null ? kBlackColor : Theme.of(context).colorScheme.surface_01,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    ref.watch(bookmarkListStateProvider.notifier).setSelectedEmoticon(null);
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "전체보기",
                                      style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textCaption),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: ref.watch(bookmarkListStateProvider.notifier).emotionList.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Consumer(builder: (context, ref, child) {
                              return BookMarkEmoticonIconButton(
                                name: ref.watch(bookmarkListStateProvider.notifier).emotionList[i].desc,
                                icon: ref.watch(bookmarkListStateProvider.notifier).emotionList[i].emoticon,
                                selected: ref.watch(bookmarkListStateProvider.notifier).emotionValue == ref.watch(bookmarkListStateProvider.notifier).emotionList[i].value,
                                onPressed: () {
                                  setState(() {
                                    ref.watch(bookmarkListStateProvider.notifier).setSelectedEmoticon(ref.watch(bookmarkListStateProvider.notifier).emotionList[i].value);
                                  });
                                },
                              );
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PagedListView<int, CommentData>(
                  pagingController: _bookMarkPagingController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  builderDelegate: PagedChildBuilderDelegate<CommentData>(
                    noItemsFoundIndicatorBuilder: (context) {
                      return Column(
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
                      );
                    },
                    newPageProgressIndicatorBuilder: (context) {
                      return Column(
                        children: [
                          Lottie.asset(
                            'lib/config/assets/lottie/loading.json',
                            height: 160,
                            width: 160,
                            fit: BoxFit.fill,
                          ),
                        ],
                      );
                    },
                    firstPageProgressIndicatorBuilder: (context) {
                      return Center(
                        child: Lottie.asset(
                          'lib/config/assets/lottie/loading.json',
                          fit: BoxFit.fill,
                          height: 160,
                          width: 160,
                        ),
                      );
                    },
                    itemBuilder: (context, item, index) {
                      return Consumer(builder: (context, ref, child) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiaryDetailScreen(
                                  diaryId: item.diaryId!,
                                  date: DateTime.parse(item.createAt),
                                  isNewDiary: false,
                                ),
                              ),
                            );
                          },
                          child: BookMarkList(
                            date: DateTime.parse(item.createAt),
                            isBookMark: true,
                            title: item.message,
                            name: item.author,
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
                          ),
                        );
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

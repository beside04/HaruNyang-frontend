import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_list_state_provider.g.dart';

enum ListAPIStatus {
  idle,
  loading,
  loaded,
  error,
}

@Riverpod(keepAlive: true)
class BookmarkListState extends _$BookmarkListState {
  int _lastPage = 0;
  ListAPIStatus _apiStatus = ListAPIStatus.idle;

  String? searchWord;

  String? emotionValue;

  @override
  PagingController<int, CommentData> build() {
    PagingController<int, CommentData> pagingController = PagingController(firstPageKey: 0);
    pagingController.addPageRequestListener(_fetchPage);
    return pagingController;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      if (_apiStatus == ListAPIStatus.loading) {
        return;
      }

      _apiStatus = ListAPIStatus.loading;

      final searchResult = await bookmarkUseCase.getBookmark(pageKey, 10, emotionValue);

      if (searchResult == null) {
        _apiStatus = ListAPIStatus.loaded;
        state.appendPage([], 0);
        return;
      }

      List<CommentData>? searchList;
      searchResult.when(
        success: (data) {
          searchList = data;
        },
        error: (message) {},
      );

      // try {
      //   // _lastPage = searchResult.params!.pagination?.totalPageCount! ?? 0;
      //   // _lastPage = searchList.isEmpty
      //
      //   _lastPage = 3;
      // } catch (_) {
      //   _lastPage = 1;
      // }
      //
      final nextPageKey = searchList!.isEmpty ? null : pageKey + 1;

      if (searchList!.isEmpty) {
        state.appendLastPage(searchList!);
      } else {
        state.appendPage(searchList!, nextPageKey);
      }
      _apiStatus = ListAPIStatus.loaded;
    } catch (apiException) {
      _apiStatus = ListAPIStatus.error;
      state.error = apiException.toString();
    }
  }

  void search(String keyword) {
    // if (keyword.isEmpty) {
    //   state.refresh();
    //   return;
    // }
    // searchWord = keyword;
    //
    // print("searchWord ${searchWord}");
    // state.refresh();

    // print("keywordkeyword ${keyword}");

    // List<CustomerSupportItemModel> currentList = state.itemList ?? [];
    // List<CustomerSupportItemModel> filterList = [];
    //
    // for (var element in currentList) {
    //   if (element.title != null) {
    //     print('keyword $keyword');
    //     if (element.title!.contains(keyword)) {
    //       filterList.add(element);
    //     }
    //   }
    // }
    //
    // print('filterList $filterList');
    // _apiStatus = ListAPIStatus.loaded;
    // state.itemList = [];
    // state.appendLastPage(filterList);
    // print('state ${state.itemList!.length} / ${currentList.length}');
  }

// void setFaqType(FaqType type) {
//   _faqType = type;
//   state.refresh();
// }
//
// Future<List<MenuItemModel>> getFaqMenuList() async {
//   List<MenuItemModel> menuList = [
//     MenuItemModel(menuName: '전체', idx: 0),
//   ];
//   menuList.addAll(await _customerSupportRepository.getFaqMenuList());
//   return menuList;
// }

  void setSelectedEmoticon(String? value) {
    if (value == null) {
      emotionValue = null;
      state.refresh();
    } else {
      emotionValue = value;
      state.refresh();
    }
  }

  Future<void> deleteBookmark(int bookmarkId) async {
    int targetIdx = -1;

    final result = await bookmarkUseCase.deleteBookmark(bookmarkId);
    result.when(
      success: (data) async {
        print(bookmarkId);

        print(state.itemList!);

        targetIdx = state.itemList!.indexWhere((element) => element.id == bookmarkId);

        if (targetIdx != -1) {
          state.itemList!.removeAt(targetIdx);
        }

        state.notifyListeners();
      },
      error: (message) {},
    );
  }

  List<EmoticonData> emotionList = [
    const EmoticonData(
      id: 1,
      emoticon: 'lib/config/assets/images/diary/emotion/happy.png',
      value: 'HAPPINESS',
      desc: '기뻐',
    ),
    const EmoticonData(
      id: 2,
      emoticon: 'lib/config/assets/images/diary/emotion/sad.png',
      value: 'SADNESS',
      desc: '슬퍼',
    ),
    const EmoticonData(
      id: 3,
      emoticon: 'lib/config/assets/images/diary/emotion/angry.png',
      value: 'ANGRY',
      desc: '화나',
    ),
    const EmoticonData(
      id: 4,
      emoticon: 'lib/config/assets/images/diary/emotion/excited.png',
      value: 'EXCITED',
      desc: '신나',
    ),
    const EmoticonData(
      id: 5,
      emoticon: 'lib/config/assets/images/diary/emotion/tired.png',
      value: 'TIRED',
      desc: '힘들어',
    ),
    const EmoticonData(
      id: 6,
      emoticon: 'lib/config/assets/images/diary/emotion/amazed.png',
      value: 'SURPRISED',
      desc: '놀랐어',
    ),
    const EmoticonData(
      id: 7,
      emoticon: 'lib/config/assets/images/diary/emotion/soso.png',
      value: 'NEUTRAL',
      desc: '그저그래',
    ),
    const EmoticonData(
      id: 8,
      emoticon: 'lib/config/assets/images/diary/emotion/blushed.png',
      value: 'FLUTTER',
      desc: '설레',
    ),
    const EmoticonData(
      id: 9,
      emoticon: 'lib/config/assets/images/diary/emotion/molra.png',
      value: 'UNCERTAIN',
      desc: '몰라',
    ),
  ];
}

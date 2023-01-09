import 'package:frontend/domain/model/bookmark/bookmark_data.dart';
import 'package:frontend/domain/use_case/bookmark/bookmark_use_case.dart';
import 'package:get/get.dart';

class BookMarkViewModel extends GetxController {
  BookmarkUseCase bookmarkUseCase;

  BookMarkViewModel({
    required this.bookmarkUseCase,
  });

  final RxBool isBookmark = false.obs;

  RxList<BookmarkData> bookmarkList = <BookmarkData>[].obs;

  @override
  void onInit() {
    super.onInit();
    getBookmark();
  }

  void toggleBookmark() {
    isBookmark.value = !isBookmark.value;
  }

  Future<void> saveBookmark(int wiseSayingId) async {
    final result = await bookmarkUseCase.saveBookmark(wiseSayingId);
    result.when(
      success: (data) {},
      error: (message) {},
    );
  }

  Future<void> getBookmark() async {
    int limit = 100;
    int page = 0;

    final result = await bookmarkUseCase.getBookmark(page, limit);

    result.when(
      success: (data) {
        bookmarkList.value = List.from(data);
      },
      error: (message) {
        Get.snackbar('알림', '북마크를 불러오는데 실패했습니다.');
      },
    );
  }

  Future<void> deleteBookmark(int bookmarkId) async {
    final result = await bookmarkUseCase.deleteBookmark(bookmarkId);
    result.when(
      success: (data) {},
      error: (message) {},
    );
  }
}

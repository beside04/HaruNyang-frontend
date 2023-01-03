import 'package:frontend/domain/use_case/bookmark/bookmark_use_case.dart';
import 'package:get/get.dart';

class BookMarkViewModel extends GetxController {
  BookmarkUseCase bookmarkUseCase;

  BookMarkViewModel({
    required this.bookmarkUseCase,
  });

  final RxBool isBookmark = false.obs;

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
      success: (data) {},
      error: (message) {},
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

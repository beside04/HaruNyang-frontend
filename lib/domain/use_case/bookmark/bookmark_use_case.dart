import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/bookmark/bookmark_data.dart';
import 'package:frontend/domain/repository/bookmark/bookmark_repository.dart';

class BookmarkUseCase {
  final BookmarkRepository bookmarkRepository;

  BookmarkUseCase({
    required this.bookmarkRepository,
  });

  Future<Result<bool>> saveBookmark(int wiseSayingId) async {
    return await bookmarkRepository.saveBookmark(wiseSayingId);
  }

  Future<Result<List<BookmarkData>>> getBookmark(int page, int limit) async {
    return await bookmarkRepository.getBookmark(page, limit);
  }

  Future<Result<bool>> deleteBookmark(int bookmarkId) async {
    return await bookmarkRepository.deleteBookmark(bookmarkId);
  }
}

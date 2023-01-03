import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/bookmark_api.dart';
import 'package:frontend/domain/model/bookmark/bookmark_data.dart';
import 'package:frontend/domain/repository/bookmark/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkApi bookmarkApi;

  BookmarkRepositoryImpl({
    required this.bookmarkApi,
  });

  @override
  Future<Result<bool>> saveBookmark(int wiseSayingId) async {
    return await bookmarkApi.saveBookmark(wiseSayingId);
  }

  @override
  Future<Result<BookmarkData>> getBookmark(int page, int limit) async {
    return await bookmarkApi.getBookmark(page, limit);
  }

  @override
  Future<Result<bool>> deleteBookmark(int bookmarkId) async {
    return await bookmarkApi.deleteBookmark(bookmarkId);
  }
}

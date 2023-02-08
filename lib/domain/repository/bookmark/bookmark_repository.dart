import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/bookmark/bookmark_data.dart';

abstract class BookmarkRepository {
  Future<Result<bool>> saveBookmark(int wiseSayingId);

  Future<Result<List<BookmarkData>>> getBookmark(int page, int limit);

  Future<Result<bool>> deleteBookmark(int bookmarkId);
}

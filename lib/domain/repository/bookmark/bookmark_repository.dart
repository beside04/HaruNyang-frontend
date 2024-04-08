import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';

abstract class BookmarkRepository {
  Future<Result<bool>> saveBookmark(int wiseSayingId);

  Future<Result<List<CommentData>>> getBookmark(int page, int limit, String? feeling);

  Future<Result<bool>> deleteBookmark(int bookmarkId);
}

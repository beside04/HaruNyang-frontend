import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';

abstract class BookmarkRepository {
  Future<ResponseResult<bool>> saveBookmark(int wiseSayingId);

  Future<ResponseResult<List<CommentData>>> getBookmark(int page, int limit, String? feeling);

  Future<ResponseResult<bool>> deleteBookmark(int bookmarkId);
}

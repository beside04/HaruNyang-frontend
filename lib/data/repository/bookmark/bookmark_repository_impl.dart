import 'package:frontend/apis/bookmark_api.dart';
import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';
import 'package:frontend/domain/repository/bookmark/bookmark_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkApi bookmarkApi;

  BookmarkRepositoryImpl({
    required this.bookmarkApi,
  });

  @override
  Future<ResponseResult<bool>> saveBookmark(int wiseSayingId) async {
    return await bookmarkApi.saveBookmark(wiseSayingId);
  }

  @override
  Future<ResponseResult<List<CommentData>>> getBookmark(int page, int limit, String? feeling) async {
    return await bookmarkApi.getBookmark(page, limit, feeling);
  }

  @override
  Future<ResponseResult<bool>> deleteBookmark(int bookmarkId) async {
    return await bookmarkApi.deleteBookmark(bookmarkId);
  }
}

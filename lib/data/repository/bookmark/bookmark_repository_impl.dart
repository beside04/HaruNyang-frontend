import 'package:frontend/apis/bookmark_api.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';
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
  Future<Result<List<CommentData>>> getBookmark(int page, int limit, String? feeling) async {
    return await bookmarkApi.getBookmark(page, limit, feeling);
  }

  @override
  Future<Result<bool>> deleteBookmark(int bookmarkId) async {
    return await bookmarkApi.deleteBookmark(bookmarkId);
  }
}

import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';
import 'package:frontend/domain/repository/bookmark/bookmark_repository.dart';

class BookmarkUseCase {
  final BookmarkRepository bookmarkRepository;

  BookmarkUseCase({
    required this.bookmarkRepository,
  });

  Future<ResponseResult<bool>> saveBookmark(int wiseSayingId) async {
    return await bookmarkRepository.saveBookmark(wiseSayingId);
  }

  Future<ResponseResult<List<CommentData>>> getBookmark(int page, int limit, String? feeling) async {
    return await bookmarkRepository.getBookmark(page, limit, feeling);
  }

  Future<ResponseResult<bool>> deleteBookmark(int bookmarkId) async {
    return await bookmarkRepository.deleteBookmark(bookmarkId);
  }
}

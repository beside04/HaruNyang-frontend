import 'package:dio/dio.dart';
import 'package:frontend/apis/response_result.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';

class BookmarkApi {
  final Dio dio;

  String get _baseUrl => usingServer;

  BookmarkApi({
    required this.dio,
  });

  Future<ResponseResult<bool>> saveBookmark(int wiseSayingId) async {
    String bookmarkUrl = '$_baseUrl/v2/comments/$wiseSayingId/favorite';
    try {
      Response response;
      response = await dio.post(
        bookmarkUrl,
      );

      if (response.statusCode == 200) {
        return const ResponseResult.success(true);
      } else {
        return const ResponseResult.error('북마크 저장에 실패했습니다.');
      }
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          errMessage = '401';
        } else {
          errMessage = e.response!.data['message'];
        }
      } else {
        errMessage = '401';
      }
      return ResponseResult.error(errMessage);
    } catch (e) {
      return ResponseResult.error(e.toString());
    }
  }

  Future<ResponseResult<List<CommentData>>> getBookmark(int page, int limit, String? feeling) async {
    String bookmarkUrl = '$_baseUrl/v2/comments/favorites/search';

    Map<String, dynamic> queryParameters = {};

    try {
      Response response;

      queryParameters = feeling == null
          ? {"page": page, "limitCount": limit}
          : {
              "page": page,
              "limitCount": limit,
              "feeling": feeling,
            };

      response = await dio.get(
        bookmarkUrl,
        queryParameters: queryParameters,
      );

      final Iterable bookmarkIterable = response.data;

      final List<CommentData> bookmarkList = bookmarkIterable.map((e) => CommentData.fromJson(e)).toList();

      return ResponseResult.success(bookmarkList);
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          errMessage = '401';
        } else {
          errMessage = e.response!.data['message'];
        }
      } else {
        errMessage = '401';
      }
      return ResponseResult.error(errMessage);
    } catch (e) {
      return ResponseResult.error(e.toString());
    }
  }

  Future<ResponseResult<bool>> deleteBookmark(int bookmarkId) async {
    String bookmarkUrl = '$_baseUrl/v2/comments/$bookmarkId/favorite';
    try {
      Response response;
      response = await dio.delete(
        bookmarkUrl,
      );

      if (response.statusCode == 200) {
        return const ResponseResult.success(true);
      } else {
        return const ResponseResult.error('북마크를 삭제하는데 실패했습니다.');
      }
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          errMessage = '401';
        } else {
          errMessage = e.response!.data['message'];
        }
      } else {
        errMessage = '401';
      }
      return ResponseResult.error(errMessage);
    } catch (e) {
      return ResponseResult.error(e.toString());
    }
  }
}

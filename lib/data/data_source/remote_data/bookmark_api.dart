import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/refresh_interceptor.dart';
import 'package:frontend/domain/model/bookmark/bookmark_data.dart';

class BookmarkApi {
  final RefreshInterceptor interceptor;
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  BookmarkApi({
    required this.interceptor,
  });

  Future<Result<bool>> saveBookmark(int wiseSayingId) async {
    String bookmarkUrl =
        '$_baseUrl/v1/wise-saying-bookmark?wiseSayingId=$wiseSayingId';
    var dio = await interceptor.refreshInterceptor();
    try {
      Response response;
      response = await dio.post(bookmarkUrl);

      final bool resultData = response.data['data'];
      if (resultData) {
        return const Result.success(true);
      } else {
        return const Result.error('북마크 저장에 실패했습니다.');
      }
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          errMessage =
              '북마크 저장의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
        }
      } else {
        errMessage = e.message;
      }
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<List<BookmarkData>>> getBookmark(int page, int limit) async {
    String bookmarkUrl = '$_baseUrl/v1/wise-saying-bookmark';
    var dio = await interceptor.refreshInterceptor();
    try {
      Response response;
      response = await dio.get(
        bookmarkUrl,
        queryParameters: {
          "page": page,
          "limitCount": limit,
        },
      );

      final Iterable bookmarkIterable = response.data['data']['data'];

      final List<BookmarkData> bookmarkList =
          bookmarkIterable.map((e) => BookmarkData.fromJson(e)).toList();

      return Result.success(bookmarkList);
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          errMessage =
              '북마크를 가져오는 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
        }
      } else {
        errMessage = e.message;
      }
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<bool>> deleteBookmark(int bookmarkId) async {
    String bookmarkUrl = '$_baseUrl/v1/wise-saying-bookmark/$bookmarkId';
    var dio = await interceptor.refreshInterceptor();
    try {
      Response response;
      response = await dio.delete(
        bookmarkUrl,
      );

      final bool resultData = response.data['data'];
      if (resultData) {
        return const Result.success(true);
      } else {
        return const Result.error('북마크를 삭제하는데 실패했습니다.');
      }
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          errMessage =
              '북마크를 삭제하는데 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
        }
      } else {
        errMessage = e.message;
      }
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}

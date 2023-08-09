import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/global_service.dart';
import 'package:frontend/domain/model/diary/comment_data.dart';
import 'package:get/get.dart' hide Response;

class BookmarkApi {
  final Dio dio;

  final globalService = Get.find<GlobalService>();
  String get _baseUrl => globalService.usingServer.value;

  BookmarkApi({
    required this.dio,
  });

  Future<Result<bool>> saveBookmark(int wiseSayingId) async {
    String bookmarkUrl = '$_baseUrl/v2/comments/$wiseSayingId/favorite';
    try {
      Response response;
      response = await dio.post(
        bookmarkUrl,
      );

      if (response.statusCode == 200) {
        return const Result.success(true);
      } else {
        return const Result.error('북마크 저장에 실패했습니다.');
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
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<List<CommentData>>> getBookmark(int page, int limit) async {
    String bookmarkUrl = '$_baseUrl/v2/comments/favorites';
    try {
      Response response;
      response = await dio.get(
        bookmarkUrl,
        queryParameters: {
          "page": page,
          "limitCount": limit,
        },
      );

      final Iterable bookmarkIterable = response.data;

      final List<CommentData> bookmarkList =
          bookmarkIterable.map((e) => CommentData.fromJson(e)).toList();

      return Result.success(bookmarkList);
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
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<bool>> deleteBookmark(int bookmarkId) async {
    String bookmarkUrl = '$_baseUrl/v2/comments/$bookmarkId/favorite';
    try {
      Response response;
      response = await dio.delete(
        bookmarkUrl,
      );

      if (response.statusCode == 200) {
        return const Result.success(true);
      } else {
        return const Result.error('북마크를 삭제하는데 실패했습니다.');
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
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}

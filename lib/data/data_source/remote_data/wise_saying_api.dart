import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/refresh_interceptor.dart';
import 'package:frontend/domain/model/wise_saying/wise_saying_data.dart';

class WiseSayingApi {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<Result<List<WiseSayingData>>> getWiseSaying(
      int emoticonId, String content) async {
    var dio = await refreshInterceptor();

    try {
      String emoticonUrl = '$_baseUrl/v1/emotion/$emoticonId/wisesaying';
      Response response;
      response = await dio.get(
        emoticonUrl,
        queryParameters: {
          'diaryContent': content,
        },
      );

      if (response.data['status'] == 200) {
        final Iterable wiseSayingIterable = response.data['data'];
        final List<WiseSayingData> wiseSayingList =
            wiseSayingIterable.map((e) => WiseSayingData.fromJson(e)).toList();

        return Result.success(wiseSayingList);
      } else {
        return Result.error(
            '서버 error : status code : ${response.data['status']}');
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}
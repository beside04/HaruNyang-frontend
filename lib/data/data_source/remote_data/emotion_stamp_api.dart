import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/refresh_interceptor.dart';
import 'package:frontend/domain/model/emotion_stamp/emotion_stamp_data.dart';

class EmotionStampApi {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<Result<List<EmotionStampData>>> getEmotionStamp(
      String from, String to) async {
    var dio = await refreshInterceptor();

    try {
      String emoticonStampUrl = '$_baseUrl/v1/diary?from=$from&to=$to';
      Response response;
      response = await dio.get(
        emoticonStampUrl,
      );

      if (response.data['status'] == 200) {
        final Iterable emotionStampIterable = response.data['data'];

        final List<EmotionStampData> emotionStampList = emotionStampIterable
            .map((e) => EmotionStampData.fromJson(e))
            .toList();

        return Result.success(emotionStampList);
      } else {
        return Result.error(
            '서버 error : status code : ${response.data['status']}');
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/refresh_interceptor.dart';

class DiaryApi {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<Result<bool>> saveDiary(
      String diaryContent,
      int emoticonId,
      int emoticonIndex,
      List<String> images,
      String weather,
      List<int> wiseSayingIds) async {
    String diaryUrl = '$_baseUrl/v1/diary';
    var dio = await refreshInterceptor();

    try {
      Response response;
      response = await dio.post(diaryUrl, data: {
        "diary_content": diaryContent,
        "emotion_id": emoticonId,
        "emotion_index": emoticonIndex, //감정 강도
        "images": images,
        "weather": weather,
        "wise_saying_ids": wiseSayingIds,
      });

      final bool resultData = response.data['data'];
      print(resultData);
      if (resultData) {
        return const Result.success(true);
      } else {
        return const Result.error('일기 작성이 실패 했습니다.');
      }
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          errMessage =
              '일기 작성 api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
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

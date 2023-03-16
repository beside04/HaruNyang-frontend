import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';

class EmotionStampApi {
  final Dio dio;
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  EmotionStampApi({
    required this.dio,
  });

  Future<Result<List<DiaryData>>> getEmotionStamp(
      String from, String to) async {
    try {
      String emoticonStampUrl = '$_baseUrl/v1/diaries?from=$from&to=$to';
      Response response;
      response = await dio.get(
        emoticonStampUrl,
      );

      if (response.data['status'] == 200) {
        final Iterable emotionStampIterable = response.data['data'];

        final List<DiaryData> emotionStampList =
            emotionStampIterable.map((e) => DiaryData.fromJson(e)).toList();

        emotionStampList.sort((a, b) {
          return a.id!.compareTo(b.id!);
        });

        return Result.success(emotionStampList);
      } else {
        return Result.error(
            '서버 error : status code : ${response.data['status']}');
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

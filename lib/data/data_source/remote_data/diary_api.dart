import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';

class DiaryApi {
  final Dio dio;
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  DiaryApi({
    required this.dio,
  });

  Future<Result<String>> saveDiary(DiaryData diary) async {
    String diaryUrl = '$_baseUrl/v1/diary';
    try {
      Response response;
      response = await dio.post(
        diaryUrl,
        data: {
          "diary_content": diary.diaryContent,
          "emotion_id": diary.emotion.id,
          "emotion_index": diary.emoticonIndex, //감정 강도
          "images": diary.images,
          "weather": diary.weather,
          "wise_saying_ids": diary.wiseSayings
              .where((element) => element.id != null)
              .map((e) => e.id)
              .toList(),
          "written_at": diary.createTime,
          "writing_topic_id": diary.writingTopic.id,
        },
      );

      final String diaryId = response.data['data'];
      return Result.success(diaryId);
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

  Future<Result<bool>> updateDiary(DiaryData diary) async {
    String diaryUrl = '$_baseUrl/v1/diary/${diary.id}';
    try {
      Response response;
      response = await dio.put(diaryUrl, data: {
        "diary_content": diary.diaryContent,
        "images": diary.images,
        "wise_saying_ids": diary.wiseSayings
            .where((element) => element.id != null)
            .map((e) => e.id)
            .toList(),
      });

      final bool resultData = response.data['data'];
      if (resultData) {
        return const Result.success(true);
      } else {
        return const Result.error('일기 수정이 실패 했습니다.');
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

  Future<Result<bool>> deleteDiary(String diaryId) async {
    String diaryUrl = '$_baseUrl/v1/diary/$diaryId';
    try {
      Response response;
      response = await dio.delete(
        diaryUrl,
      );

      final bool resultData = response.data['data'];
      if (resultData) {
        return const Result.success(true);
      } else {
        return const Result.error('일기 삭제가 실패 했습니다.');
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

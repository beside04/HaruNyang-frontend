import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/refresh_interceptor.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';

class DiaryApi {
  final RefreshInterceptor interceptor;
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  DiaryApi({
    required this.interceptor,
  });

  Future<Result<bool>> saveDiary(DiaryData diary) async {
    String diaryUrl = '$_baseUrl/v1/diary';
    var dio = await interceptor.refreshInterceptor();
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
        },
      );

      final bool resultData = response.data['data'];
      if (resultData) {
        return const Result.success(true);
      } else {
        return const Result.error('일기 작성이 실패 했습니다.');
      }
    } on DioError catch (e) {
      String errMessage = '';
      if (e.response != null) {
        errMessage = '일기 작성에 실패했습니다. ${e.response!.data['message']}';
      } else {
        errMessage = e.message;
      }
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<bool>> updateDiary(DiaryData diary) async {
    String diaryUrl = '$_baseUrl/v1/diary/${diary.id}';
    var dio = await interceptor.refreshInterceptor();
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
        if (e.response!.statusCode != 200) {
          errMessage =
              '일기 수정 api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
        }
      } else {
        errMessage = e.message;
      }
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<bool>> deleteDiary(String diaryId) async {
    String diaryUrl = '$_baseUrl/v1/diary/$diaryId';
    var dio = await interceptor.refreshInterceptor();
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
        if (e.response!.statusCode != 200) {
          errMessage =
              '일기 삭제 api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
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

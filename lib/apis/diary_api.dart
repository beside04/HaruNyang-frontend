import 'package:dio/dio.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/res/constants.dart';

class DiaryApi {
  final Dio dio;

  String get _baseUrl => usingServer;

  DiaryApi({
    required this.dio,
  });

  Future<Result<DiaryDetailData>> getDiaryDetail(int id) async {
    String bookmarkUrl = '$_baseUrl/v2/diaries/$id';
    try {
      Response response;
      response = await dio.get(
        bookmarkUrl,
      );

      return Result.success(DiaryDetailData.fromJson(response.data));
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

  Future<Result<DiaryDetailData>> saveDiary(DiaryData diary) async {
    String diaryUrl = '$_baseUrl/v2/diaries';
    try {
      Response response;
      response = await dio.post(
        diaryUrl,
        data: {
          "content": diary.diaryContent,
          "feeling": diary.feeling,
          "feelingScore": diary.feelingScore,
          "weather": diary.weather,
          "topic": diary.topic,
          "image": diary.image,
          "targetDate": diary.targetDate,
        },
      );

      return Result.success(DiaryDetailData.fromJson(response.data));
    } on DioError catch (e) {
      String errMessage = '';
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          errMessage = '401';
        } else {
          errMessage = e.response!.data;
        }
      } else {
        errMessage = '401';
      }
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<DiaryDetailData>> updateDiary(DiaryData diary) async {
    String diaryUrl = '$_baseUrl/v2/diaries/${diary.id}';
    try {
      Response response;
      response = await dio.post(diaryUrl, data: {
        "content": diary.diaryContent,
        "feeling": diary.feeling,
        "feelingScore": diary.feelingScore,
        "weather": diary.weather,
        "topic": diary.topic,
        "image": diary.image,
        "targetDate": diary.targetDate,
      });

      return Result.success(DiaryDetailData.fromJson(response.data));
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          errMessage = '401';
        } else {
          errMessage = e.response!.data;
        }
      } else {
        errMessage = '401';
      }
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<bool>> deleteDiary(int diaryId) async {
    String diaryUrl = '$_baseUrl/v2/diaries/$diaryId';
    try {
      Response response;
      response = await dio.delete(
        diaryUrl,
      );

      final bool resultData = response.data;
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

  Future<Result<bool>> postImageHistory(String imageUrl) async {
    String diaryUrl = '$_baseUrl/v2/storage/images/history';
    try {
      Response response;
      response = await dio.post(
        diaryUrl,
        data: {
          "imageUrl": imageUrl,
        },
      );

      if (response.statusCode == 200) {
        return const Result.success(true);
      } else {
        return const Result.error('일기 이미지 히스토리 저장 실패');
      }
    } on DioError catch (e) {
      String errMessage = '';
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          errMessage = '401';
        } else {
          errMessage = e.response!.data;
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

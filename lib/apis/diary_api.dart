import 'package:dio/dio.dart';
import 'package:frontend/apis/response_result.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';

class DiaryApi {
  final Dio dio;

  String get _baseUrl => usingServer;

  DiaryApi({
    required this.dio,
  });

  Future<ResponseResult<DiaryDetailData>> getDiaryDetail(int id) async {
    String bookmarkUrl = '$_baseUrl/v2/diaries/$id';
    try {
      Response response;
      response = await dio.get(
        bookmarkUrl,
      );

      return ResponseResult.success(DiaryDetailData.fromJson(response.data));
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

  Future<ResponseResult<DiaryDetailData>> saveDiary(DiaryDetailData diary) async {
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

      return ResponseResult.success(DiaryDetailData.fromJson(response.data));
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
      return ResponseResult.error(errMessage);
    } catch (e) {
      return ResponseResult.error(e.toString());
    }
  }

  Future<ResponseResult<DiaryDetailData>> updateDiary(DiaryDetailData diary) async {
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

      return ResponseResult.success(DiaryDetailData.fromJson(response.data));
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
      return ResponseResult.error(errMessage);
    } catch (e) {
      return ResponseResult.error(e.toString());
    }
  }

  Future<ResponseResult<bool>> deleteDiary(int diaryId) async {
    String diaryUrl = '$_baseUrl/v2/diaries/$diaryId';
    try {
      Response response;
      response = await dio.delete(
        diaryUrl,
      );

      final bool resultData = response.data;
      if (resultData) {
        return const ResponseResult.success(true);
      } else {
        return const ResponseResult.error('일기 삭제가 실패 했습니다.');
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

  Future<ResponseResult<bool>> postImageHistory(String imageUrl) async {
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
        return const ResponseResult.success(true);
      } else {
        return const ResponseResult.error('일기 이미지 히스토리 저장 실패');
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
      return ResponseResult.error(errMessage);
    } catch (e) {
      return ResponseResult.error(e.toString());
    }
  }
}

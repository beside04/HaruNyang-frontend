import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
// import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart' hide Response;

class EmotionStampApi {
  final Dio dio;

  String get _baseUrl => usingServer;

  EmotionStampApi({
    required this.dio,
  });

  Future<Result<List<DiaryData>>> getEmotionStamp(String from, String to) async {
    try {
      String emoticonStampUrl = '$_baseUrl/v2/diaries?periodFrom=$from&periodTo=$to';
      Response response;
      response = await dio.get(emoticonStampUrl);

      final Iterable emotionStampIterable = response.data;

      final List<DiaryData> emotionStampList = emotionStampIterable.map((e) => DiaryData.fromJson(e)).toList();

      emotionStampList.sort((a, b) {
        return a.id!.compareTo(b.id!);
      });

      return Result.success(emotionStampList);
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode == 403) {
          // Get.find<LoginViewModel>().connectKakaoLogin();
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

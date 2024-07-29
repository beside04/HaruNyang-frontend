import 'package:dio/dio.dart';
import 'package:frontend/apis/response_result.dart';
// import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';

class EmotionStampApi {
  final Dio dio;

  String get _baseUrl => usingServer;

  EmotionStampApi({
    required this.dio,
  });

  Future<ResponseResult<List<DiaryDetailData>>> getEmotionStamp(String from, String to) async {
    try {
      String emoticonStampUrl = '$_baseUrl/v2/diaries?periodFrom=$from&periodTo=$to';
      Response response;
      response = await dio.get(emoticonStampUrl);

      final Iterable emotionStampIterable = response.data;

      final List<DiaryDetailData> emotionStampList = emotionStampIterable.map((e) => DiaryDetailData.fromJson(e)).toList();

      emotionStampList.sort((a, b) {
        return a.id!.compareTo(b.id!);
      });

      return ResponseResult.success(emotionStampList);
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode == 403) {
          // Get.find<LoginViewModel>().connectKakaoLogin();
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

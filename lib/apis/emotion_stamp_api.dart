import 'package:dio/dio.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
// import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:frontend/res/constants.dart';

class EmotionStampApi {
  final Dio dio;

  String get _baseUrl => usingServer;

  EmotionStampApi({
    required this.dio,
  });

  Future<Result<List<DiaryDetailData>>> getEmotionStamp(String from, String to) async {
    print("adsasddsaasd");

    try {
      String emoticonStampUrl = '$_baseUrl/v2/diaries?periodFrom=$from&periodTo=$to';
      Response response;
      response = await dio.get(emoticonStampUrl);

      final Iterable emotionStampIterable = response.data;

      print("response.dataaaa ${emotionStampIterable.length}");

      // final List<DiaryDetailData> emotionStampList = [];
      // for (var e in emotionStampIterable) {
      //   try {
      //     emotionStampList.add(DiaryDetailData.fromJson(e));
      //   } catch (error) {
      //     print("Error converting to DiaryDetailData: $error");
      //   }
      // }

      final List<DiaryDetailData> emotionStampList = emotionStampIterable.map((e) => DiaryDetailData.fromJson(e)).toList();

      print("emotionStampListaaa ${emotionStampList}");

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

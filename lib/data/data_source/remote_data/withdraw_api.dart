import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/data/data_source/remote_data/refresh_interceptor.dart';

class WithdrawApi {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<void> withdrawal() async {
    String withdrawUrl = '$_baseUrl/v1/withdraw';
    var dio = await refreshInterceptor();

    try {
      Response response;
      response = await dio.delete(
        withdrawUrl,
      );
      print(response);
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          errMessage =
              'withdraw api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
        }
      } else {
        errMessage = e.message;
      }
    } catch (e) {}
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/refresh_interceptor.dart';

class WithdrawApi {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  Future<Result<bool>> withdrawUser() async {
    String withdrawUrl = '$_baseUrl/v1/withdraw';
    var dio = await refreshInterceptor();

    try {
      Response response;
      response = await dio.delete(
        withdrawUrl,
      );
      final int withdrawResult = response.statusCode ?? 0;
      if (withdrawResult == 200) {
        return const Result.success(true);
      } else {
        return const Result.error('회원 탈퇴가 실패했습니다.');
      }
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          errMessage =
              '회원탈퇴 api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
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

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';

class WithdrawApi {
  final Dio dio;
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  WithdrawApi({
    required this.dio,
  });

  Future<Result<bool>> withdrawUser() async {
    String withdrawUrl = '$_baseUrl/v2/users';
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

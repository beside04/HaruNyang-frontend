import 'package:dio/dio.dart';
import 'package:frontend/apis/response_result.dart';
import 'package:frontend/config/constants.dart';

class WithdrawApi {
  final Dio dio;

  String get _baseUrl => usingServer;

  WithdrawApi({
    required this.dio,
  });

  Future<ResponseResult<bool>> withdrawUser() async {
    String withdrawUrl = '$_baseUrl/v2/users';
    try {
      Response response;
      response = await dio.delete(
        withdrawUrl,
      );
      final int withdrawResult = response.statusCode ?? 0;
      if (withdrawResult == 200) {
        return const ResponseResult.success(true);
      } else {
        return const ResponseResult.error('회원 탈퇴가 실패했습니다.');
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

import 'package:dio/dio.dart';
import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/login_token_data.dart';
import 'package:frontend/res/constants.dart';

class LoginApi {
  String get _baseUrl => usingServer;

  final Dio dio;

  LoginApi({
    required this.dio,
  });

  Future<ResponseResult<LoginTokenData>> login(String loginType, String socialId, String? deviceId) async {
    String loginUrl = '$_baseUrl/v2/users/sign-in';

    try {
      Response response;
      response = await dio.post(
        loginUrl,
        options: Options(headers: {
          "auth-type": loginType,
          "social-id": socialId,
          "device-id": deviceId ?? "",
        }),
      );

      final cookies = response.headers.map['set-cookie'];

      return ResponseResult.success(
        LoginTokenData(
          accessToken: cookies![0].split(';')[0],
        ),
      );
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        errMessage = e.response!.statusCode!.toString();
      } else {
        print(e);
        errMessage = e.response!.statusCode!.toString();
      }
      return ResponseResult.error(errMessage);
    } catch (e) {
      return ResponseResult.error(e.toString());
    }
  }

  Future<bool> signup({
    required email,
    required loginType,
    required socialId,
    required deviceId,
    required nickname,
    required job,
    required birthDate,
  }) async {
    String signupUrl = '$_baseUrl/v2/users/sign-up';

    try {
      Response response;
      response = await dio.post(
        signupUrl,
        options: Options(headers: {
          "auth-type": loginType,
          "social-id": socialId,
          "device-id": deviceId ?? "",
        }),
        data: {
          'nickname': nickname,
          'email': email,
          'job': job,
          'birthDate': birthDate == "2000-" ? "" : birthDate,
        },
      );
      bool result = response.data;
      return result;
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          //서버 통신 에러
        }
      } else {
        //서버 통신 에러
      }
    } catch (e) {
      //서버 통신 에러
    }
    return false;
  }
}

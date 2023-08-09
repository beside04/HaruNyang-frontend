import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/global_service.dart';
import 'package:frontend/domain/model/login_token_data.dart';
import 'package:get/get.dart' hide Response;

class LoginApi {
  final globalService = Get.find<GlobalService>();
  String get _baseUrl => globalService.usingServer.value;

  final Dio _client = Dio();

  Future<Result<LoginTokenData>> login(
      String loginType, String socialId, String? deviceId) async {
    String loginUrl = '$_baseUrl/v2/users/sign-in';

    try {
      Response response;
      response = await _client.post(
        loginUrl,
        options: Options(headers: {
          "auth-type": loginType,
          "social-id": socialId,
          "device-id": deviceId ?? "",
        }),
      );

      final cookies = response.headers.map['set-cookie'];

      return Result.success(
        LoginTokenData(
          accessToken: cookies![0].split(';')[0],
        ),
      );
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        errMessage = e.response!.statusCode!.toString();
      } else {
        errMessage = e.response!.statusCode!.toString();
      }
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
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

      response = await _client.post(
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
          'birthDate': birthDate,
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

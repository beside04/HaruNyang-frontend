import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/login_token_data.dart';
import 'package:frontend/res/constants.dart';

class LoginApi {
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final Dio _client = Dio();

  Future<Result<LoginTokenData>> login(
      String loginType, String socialId, String? deviceId) async {
    String loginUrl = '$baseUrl/v1/login';
    try {
      Response response;
      response = await _client.post(
        loginUrl,
        data: {
          'device_id': deviceId ?? "",
          'login_type': loginType,
          'social_id': socialId,
        },
      );

      final json = response.data['data'];
      LoginTokenData result = LoginTokenData.fromJson(json);

      return Result.success(result);
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          errMessage =
              'login api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
        }
      } else {
        errMessage = e.message;
      }
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<SocialIDCheck> checkMember(String socialId) async {
    String checkMemberUrl = '$baseUrl/v1/members/$socialId';
    try {
      Response response;
      response = await _client.get(
        checkMemberUrl,
      );
      bool result = response.data;
      if (result) {
        return SocialIDCheck.notMember;
      } else {
        return SocialIDCheck.existMember;
      }
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          //이미 가입된 회원
          return SocialIDCheck.existMember;
        } else if (e.response!.statusCode != 200) {
          //서버 통신 에러
        }
      } else {
        //서버 통신 에러
      }
    } catch (e) {
      //에러 처리
    }
    return SocialIDCheck.error;
  }

  Future<bool> signup(String email, String loginType, String socialId) async {
    String signupUrl = '$baseUrl/v1/signup';
    try {
      Response response;

      response = await _client.post(
        signupUrl,
        data: {
          'email': email,
          'login_type': loginType,
          'social_id': socialId,
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

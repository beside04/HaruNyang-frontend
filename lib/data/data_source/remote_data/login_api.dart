import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/login_result_data.dart';
import 'package:frontend/res/constants.dart';

class LoginApi {
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final Dio _client = Dio();

  Future<Result<LoginResultData>> login(
      String loginType, String socialId) async {
    String loginUrl = '$baseUrl/v1/login';
    try {
      Response response;
      response = await _client.post(
        loginUrl,
        data: {
          'login_type': loginType,
          'social_id': socialId,
        },
      );

      final json = response.data['data'];
      LoginResultData result = LoginResultData.fromJson(json);
      print(result);

      return Result.success(result);
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          errMessage =
              'login api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
        }
      } else {
        print(e.requestOptions);
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
          print('이미 가입된 회원입니다.');
          return SocialIDCheck.existMember;
        } else if (e.response!.statusCode != 200) {
          print(
              'check member api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}');
        }
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
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
          print(
              'signup api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}');
        }
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}

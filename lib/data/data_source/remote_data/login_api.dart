import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/refresh_interceptor.dart';
import 'package:frontend/domain/model/login_token_data.dart';
import 'package:frontend/domain/model/me_data.dart';
import 'package:frontend/res/constants.dart';

class LoginApi {
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final Dio _client = Dio();
  final storage = new FlutterSecureStorage();

  Future<Result<LoginTokenData>> login(
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
      LoginTokenData result = LoginTokenData.fromJson(json);

      await storage.write(key: 'ACCESS_TOKEN', value: result.accessToken);
      await storage.write(key: 'REFRESH_TOKEN', value: result.refreshToken);

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

  Future<Result<meData>> getMe(BuildContext context) async {
    String meUrl = '$baseUrl/v1/me';

    var dio = await authDio(context);

    try {
      Response response;
      response = await dio.get(meUrl,
          options: Options(headers: {
            HttpHeaders.contentTypeHeader: "application/json;charset=utf-8",
          }));
      print(response);

      final json = response.data['data'];
      meData result = meData.fromJson(json);

      print(result.id);
      print(result.loginType);

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
}

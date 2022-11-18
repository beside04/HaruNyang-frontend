import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/domain/model/login_result_data.dart';

class LoginApi {
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final Dio _client = Dio();

  Future<void> login(String loginType, String socialId) async {
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

      print(response.data);
      final json = response.data['data'];
      LoginResultData result = LoginResultData.fromJson(json);
      print(result);
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          print(
              'login api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}');
        }
      } else {
        print(e.requestOptions);
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> checkMember(String socialId) async {
    String checkMemberUrl = '$baseUrl/v1/members/$socialId';
    try {
      Response response;
      response = await _client.get(
        checkMemberUrl,
      );
      if (response.statusCode == 400) {
        throw Exception('이미 가입된 회원입니다.');
      } else if (response.statusCode != 200) {
        throw Exception('check member api의 응답 코드가 200이 아닙니다.');
      }
      bool result = response.data;
      return result;
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          print('이미 가입된 회원입니다.');
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
    return false;
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
      print(response.data);
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

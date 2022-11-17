import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/domain/model/login_result_data.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final http.Client _client = http.Client();

  Future<void> login(String loginType, String socialId) async {
    String loginUrl = '$baseUrl/v1/login';
    try {
      http.Response response;
      Uri uri = Uri.parse(loginUrl);
      response = await _client.post(
        uri,
        body: {
          'login_type': loginType,
          'social_id': socialId,
        },
      );
      if (response.statusCode != 200) {
        throw Exception('create juso api의 응답 코드가 200이 아닙니다.');
      }
      print(response.body);
      final json = jsonDecode(response.body);
      LoginResultData result = LoginResultData.fromJson(json['data']);
    } catch (e) {}
  }
}

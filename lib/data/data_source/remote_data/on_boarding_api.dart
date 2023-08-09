import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/global_service.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/domain/repository/token_repository.dart';
import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:get/get.dart' hide Response;

class OnBoardingApi {
  final TokenRepository tokenRepository;
  final Dio dio;
  final globalService = Get.find<GlobalService>();
  String get _baseUrl => globalService.usingServer.value;

  OnBoardingApi({
    required this.dio,
    required this.tokenRepository,
  });

  Future<Result<MyInformation>> getMyInformation() async {
    String myInformationUrl = '$_baseUrl/v2/users';

    try {
      Response response;
      response = await dio.get(
        myInformationUrl,
      );

      final json = response.data;

      MyInformation result = MyInformation.fromJson(json);

      return Result.success(result);
    } on DioError catch (e) {
      String errMessage = '';
      if (e.response != null) {
      } else {
        errMessage = '401';
      }
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<Result<bool>> putMyInformation({
    required nickname,
    required job,
    required age,
    required email,
  }) async {
    String myInformationUrl = '$_baseUrl/v2/users';
    try {
      Response response;
      response = await dio.post(
        myInformationUrl,
        data: {
          'nickname': nickname,
          'job': job,
          'birthDate': age,
          'email': email,
        },
      );

      print(response.headers.map['set-cookie']);

      String cookies = response.headers.map['set-cookie']![1].split(';')[0];

      BaseOptions options = dio.options;
      options.headers['Cookie'] = cookies;

      print(cookies);

      await tokenRepository.setAccessToken(cookies);

      // await Get.find<LoginViewModel>().getLoginSuccessData(isSocialKakao: true);

      final bool result = response.data['data'];

      return Result.success(result);
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.data['code'] == "M006") {
          errMessage = '중복된 닉네임 입니다.';
        } else if (e.response!.statusCode == 401) {
          {
            errMessage = '401';
          }
        } else {
          errMessage = e.response!.data['message'];
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

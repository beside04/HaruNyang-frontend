import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/global_controller/token/token_controller.dart';
import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:get/get.dart' hide Response;

class OnBoardingApi {
  final Dio dio;
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  OnBoardingApi({
    required this.dio,
  });

  Future<Result<MyInformation>> getMyInformation() async {
    String myInformationUrl = '$baseUrl/v2/users';

    try {
      Response response;
      response = await dio.get(
        myInformationUrl,
        options: Options(headers: {
          "Cookie": Get.find<TokenController>().accessToken,
        }),
      );

      final json = response.data;

      MyInformation result = MyInformation.fromJson(json);

      return Result.success(result);
    } on DioError catch (e) {
      String errMessage = '';
      if (e.response != null) {
        if (e.response!.statusCode == 403) {
          Get.find<LoginViewModel>().connectKakaoLogin();
        }
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
  }) async {
    String myInformationUrl = '$baseUrl/v1/members';
    try {
      Response response;
      response = await dio.put(
        myInformationUrl,
        data: {
          'nickname': nickname,
          'job': job,
          'age': age,
        },
      );

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

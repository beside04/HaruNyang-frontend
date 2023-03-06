import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/my_information.dart';

class OnBoardingApi {
  final Dio dio;
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  OnBoardingApi({
    required this.dio,
  });

  Future<Result<MyInformation>> getMyInformation() async {
    String myInformationUrl = '$baseUrl/v1/me';
    try {
      Response response;
      response = await dio.get(myInformationUrl);

      final json = response.data['data'];
      MyInformation result = MyInformation.fromJson(json);

      return Result.success(result);
    } on DioError catch (e) {
      String errMessage = '';
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          errMessage = '401';
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

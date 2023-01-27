import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/refresh_interceptor.dart';
import 'package:frontend/domain/model/my_information.dart';

class OnBoardingApi {
  final RefreshInterceptor interceptor;
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  OnBoardingApi({
    required this.interceptor,
  });

  Future<Result<MyInformation>> getMyInformation() async {
    String myInformationUrl = '$baseUrl/v1/me';

    var dio = await interceptor.refreshInterceptor(isMoveToLoginPage: false);

    try {
      Response response;
      response = await dio.get(myInformationUrl);

      final json = response.data['data'];
      MyInformation result = MyInformation.fromJson(json);

      return Result.success(result);
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          errMessage =
              'api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
        }
      } else {
        errMessage = e.message;
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

    var dio = await interceptor.refreshInterceptor();

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

      //final json = response.data['data'];
      //MyInformation result = MyInformation.fromJson(json);
      final bool result = response.data['data'];
      return Result.success(result);
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          errMessage =
              'api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
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

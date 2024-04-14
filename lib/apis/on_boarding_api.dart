import 'package:dio/dio.dart';
import 'package:frontend/apis/response_result.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/domain/model/my_information.dart';
import 'package:frontend/domain/repository/token_repository.dart';

class OnBoardingApi {
  final TokenRepository tokenRepository;
  final Dio dio;

  String get _baseUrl => usingServer;

  OnBoardingApi({
    required this.dio,
    required this.tokenRepository,
  });

  Future<ResponseResult<MyInformation>> getMyInformation() async {
    String myInformationUrl = '$_baseUrl/v2/users';

    try {
      Response response;
      response = await dio.get(
        myInformationUrl,
      );

      final json = response.data;

      MyInformation result = MyInformation.fromJson(json);

      return ResponseResult.success(result);
    } on DioError catch (e) {
      String errMessage = '';
      if (e.response != null) {
      } else {
        errMessage = '401';
      }
      return ResponseResult.error(errMessage);
    } catch (e) {
      return ResponseResult.error(e.toString());
    }
  }

  Future<ResponseResult<bool>> putMyInformation({
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

      return ResponseResult.success(result);
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
      return ResponseResult.error(errMessage);
    } catch (e) {
      return ResponseResult.error(e.toString());
    }
  }
}

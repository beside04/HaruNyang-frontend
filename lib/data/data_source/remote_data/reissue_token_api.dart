import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/login_token_data.dart';

class ReissueTokenApi {
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';

  ReissueTokenApi();

  Future<Result<LoginTokenData>> reissueToken(String refreshToken) async {
    String reissueTokenUrl = '$baseUrl/v1/reissue?refreshToken=$refreshToken';

    final dio = Dio();

    try {
      Response response = await dio.get(reissueTokenUrl);

      final json = response.data['data'];
      LoginTokenData result = LoginTokenData.fromJson(json);

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
}

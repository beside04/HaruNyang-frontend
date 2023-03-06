import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:get/get.dart';

class RefreshInterceptor extends Interceptor {
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final TokenUseCase tokenUseCase;

  RefreshInterceptor({
    required this.tokenUseCase,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    //Header에 accessToken을 요청하는 값이 있는 경우
    if (options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      //access token을 가져와서 넣어준다.
      final token = await tokenUseCase.getAccessToken();
      //options.contentType = 'application/json';

      options.headers['Authorization'] = 'Bearer $token';
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    //401에러가 났을때(status code)
    //토큰 재발급 받는 시도를 하고 토큰이 재발급 되면
    //다시 새로운 토큰으로 요청을 한다.
    final refreshToken = await tokenUseCase.getRefreshToken();

    if (refreshToken == null) {
      //로그인 화면으로 다시 이동
      Get.snackbar('알림', '세션이 만료되었습니다.');
      await tokenUseCase.deleteAllToken();
      Get.offAll(
        () => const LoginScreen(),
        binding: BindingsBuilder(
          getLoginBinding,
        ),
      );
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401 || err.response == null;
    //토큰을 발급 받으려다 에러가 난 경우
    final isPathRefresh = err.requestOptions.path.contains('reissue');

    try {
      if (isStatus401 && !isPathRefresh) {
        final dio = Dio();
        // 토큰 갱신 API 요청
        final refreshResponse =
            await dio.get('$baseUrl/v1/reissue?refreshToken=$refreshToken');

        // response로부터 새로 갱신된 AccessToken과 RefreshToken 파싱
        final newAccessToken = refreshResponse.data["data"]["access_token"];
        final newRefreshToken = refreshResponse.data["data"]["refresh_token"];

        final options = err.requestOptions;

        //새로운 토큰을 넣어줌
        options.headers.addAll({
          'Authorization': 'Bearer $newAccessToken',
        });

        //토큰 변경 저장
        await tokenUseCase.setAccessToken(newAccessToken);
        await tokenUseCase.setRefreshToken(newRefreshToken);

        //요청 재전송(토큰만 바꿔서)
        final response = await dio.fetch(options);

        //에러없이 요청을 끝낼수 있다.
        return handler.resolve(response);
      }
    } on DioError catch (e) {
      // 로그인 화면으로 다시 이동
      Get.snackbar('알림', '세션이 만료되었습니다.');
      await tokenUseCase.deleteAllToken();
      Get.offAll(
        () => const LoginScreen(),
        binding: BindingsBuilder(
          getLoginBinding,
        ),
      );
      return handler.reject(e);
    }

    return handler.reject(err);
  }
}

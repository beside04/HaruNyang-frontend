import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/data/repository/token_repository_impl.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:get/get.dart';

Future<Dio> refreshInterceptor() async {
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  var dio = Dio();

  final TokenUseCase tokenUseCase = TokenUseCase(
    tokenRepository: TokenRepositoryImpl(),
  );

  dio.interceptors.clear();

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    // 기기에 저장된 AccessToken 로드
    final accessToken = await tokenUseCase.getAccessToken();

    // 매 요청마다 헤더에 AccessToken을 포함
    options.headers['Authorization'] = 'Bearer $accessToken';
    options.headers['Content-Type'] = 'application/json';

    return handler.next(options);
  }, onError: (error, handler) async {
    // 인증 오류가 발생했을 경우: AccessToken의 만료
    if (error.type.runtimeType == DioErrorType) {
      // 기기에 저장된 AccessToken과 RefreshToken 로드
      final accessToken = await tokenUseCase.getAccessToken();
      final refreshToken = await tokenUseCase.getRefreshToken();

      // 토큰 갱신 요청을 담당할 dio 객체 구현 후 그에 따른 interceptor 정의
      var refreshDio = Dio();

      refreshDio.interceptors.clear();

      refreshDio.interceptors
          .add(InterceptorsWrapper(onError: (error, handler) async {
        // 다시 인증 오류가 발생했을 경우: RefreshToken의 만료
        if (error.type.runtimeType == DioErrorType) {
          // 기기의 자동 로그인 정보 삭제
          await tokenUseCase.deleteAllToken();

          // 로그인 만료 dialog 발생 후 로그인 페이지로 이동

          Get.offAll(
            () => const LoginScreen(),
            binding: BindingsBuilder(
              getLoginBinding,
            ),
          );
          Get.snackbar('알림', '세션이 만료되었습니다.');
        }

        return handler.next(error);
      }));

      // 토큰 갱신 API 요청 시 AccessToken(만료), RefreshToken 포함
      refreshDio.options.headers['Authorization'] = 'Bearer $accessToken';

      // 토큰 갱신 API 요청
      final refreshResponse = await refreshDio
          .get('$baseUrl/v1/reissue?refreshToken=$refreshToken');

      // response로부터 새로 갱신된 AccessToken과 RefreshToken 파싱
      final newAccessToken = refreshResponse.data["data"]["access_token"];
      final newRefreshToken = refreshResponse.data["data"]["refresh_token"];

      // 기기에 저장된 AccessToken과 RefreshToken 갱신
      await tokenUseCase.setAccessToken(newAccessToken);
      await tokenUseCase.setAccessToken(newRefreshToken);

      // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
      error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      // // 수행하지 못했던 API 요청 복사본 생성
      final clonedRequest = await dio.request(error.requestOptions.path,
          options: Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers),
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters);

      // API 복사본으로 재요청
      return handler.resolve(clonedRequest);
    }

    return handler.next(error);
  }));

  return dio;
}

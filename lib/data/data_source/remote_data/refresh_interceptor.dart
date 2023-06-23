import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/repository/server_login_repository.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/presentation/login/login_screen.dart';
import 'package:get/get.dart';

class RefreshInterceptor extends Interceptor {
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final TokenUseCase tokenUseCase;
  final ServerLoginRepository serverLoginRepository;

  RefreshInterceptor({
    required this.serverLoginRepository,
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
      options.headers['Cookie'] = token;
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    //401에러가 났을때(status code)
    //토큰 재발급 받는 시도를 하고 토큰이 재발급 되면
    //다시 새로운 토큰으로 요청을 한다.

    try {
      final getDeviceId = await tokenUseCase.getDeviceId();
      final getLoginType = await tokenUseCase.getLoginType();
      final getSocialId = await tokenUseCase.getSocialId();

      final loginResult = await serverLoginRepository.login(
          getLoginType!, getSocialId!, getDeviceId);

      final options = err.requestOptions;

      await loginResult.when(
        success: (loginData) async {
          await tokenUseCase.setAccessToken(loginData.accessToken);

          options.headers['Cookie'] = loginData.accessToken;
        },
        error: (message) {},
      );

      await tokenUseCase.setDeviceId(getDeviceId ?? "");
      await tokenUseCase.setLoginType(getLoginType);
      await tokenUseCase.setSocialId(getSocialId);
      await Get.find<OnBoardingController>().getMyInformation();

      Get.offAll(
        () => const HomeScreen(),
        binding: BindingsBuilder(
          getHomeViewModelBinding,
        ),
      );

      // final loginResult=  await tokenUseCase.setAccessToken(loginData.accessToken);
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

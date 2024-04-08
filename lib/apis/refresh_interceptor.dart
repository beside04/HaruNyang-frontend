import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domain/repository/server_login_repository.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/domains/notification/provider/notification_provider.dart';
import 'package:frontend/domains/on_boarding/provider/on_boarding_provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/res/constants.dart';
import 'package:frontend/ui/screen/home/home_screen.dart';
import 'package:frontend/ui/screen/login/login_screen.dart';

class RefreshInterceptor extends Interceptor {
  String baseUrl = usingServer;
  final TokenUseCase tokenUseCase;
  final ServerLoginRepository serverLoginRepository;
  int retryCount = 0;

  RefreshInterceptor({
    required this.serverLoginRepository,
    required this.tokenUseCase,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
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
    final container = ProviderContainer();

    if (err.response?.statusCode == 401) {
      if (retryCount < 1) {
        retryCount++;

        try {
          //401에러가 났을때(status code)
          //토큰 재발급 받는 시도를 하고 토큰이 재발급 되면
          //다시 새로운 토큰으로 요청을 한다.

          final getLoginType = await tokenUseCase.getLoginType();
          final getSocialId = await tokenUseCase.getSocialId();

          var deviceToken = container.read(notificationProvider).token;

          final loginResult = await serverLoginRepository.login(getLoginType!, getSocialId!, deviceToken);

          final options = err.requestOptions;

          await loginResult.when(
            success: (loginData) async {
              await tokenUseCase.setAccessToken(loginData.accessToken);

              options.headers['Cookie'] = loginData.accessToken;
            },
            error: (message) {},
          );

          await tokenUseCase.setLoginType(getLoginType);
          await tokenUseCase.setSocialId(getSocialId);
          await container.read(onBoardingProvider.notifier).getMyInformation();
          await container.read(diaryProvider.notifier).getEmotionStampList();

          // Get.snackbar('알림', '로그인이 되었습니다. 다시 이용해주세요.');

          navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
        } on DioError catch (e) {
          // 로그인 화면으로 다시 이동
          // Get.snackbar('알림', '세션이 만료되었습니다.');
          await tokenUseCase.deleteAllToken();

          navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
          return handler.reject(e);
        }
        // Your existing code here
      } else {
        // 로그인 화면으로 다시 이동
        // Get.snackbar('알림', '세션이 만료되었습니다.');
        await tokenUseCase.deleteAllToken();

        navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);

        return handler.reject(err);
      }
    }
    return handler.reject(err);
  }
}

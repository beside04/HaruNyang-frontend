import 'package:flutter/services.dart';
import 'package:frontend/domain/repository/social_login_repository/kakao_login_repository.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginImpl implements KakaoLoginRepository {
  @override
  Future<OAuthToken?> login() async {
    OAuthToken token;
    if (await isKakaoTalkInstalled()) {
      try {
        token = await UserApi.instance.loginWithKakaoTalk();
        //카카오톡 로그인 성공
        return token;
      } catch (error) {
        //카카오톡 로그인 실패

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return null;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          token = await UserApi.instance.loginWithKakaoAccount();
          //카카오톡 로그인 성공
          return token;
        } catch (error) {
          //카카오톡 로그인 실패
          return null;
        }
      }
    } else {
      try {
        token = await UserApi.instance.loginWithKakaoAccount();
        //카카오톡 로그인 성공
        return token;
      } catch (error) {
        //카카오톡 로그인 실패
        return null;
      }
    }
  }

  @override
  Future<UserIdResponse?> logout() async {
    try {
      final UserIdResponse response = await UserApi.instance.logout();
      return response;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserIdResponse?> withdrawal() async {
    try {
      final UserIdResponse response = await UserApi.instance.unlink();
      return response;
    } catch (e) {
      return null;
    }
  }
}

import 'package:frontend/domain/repository/social_login_repository/apple_login_repository.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginImpl implements AppleLoginRepository {
  @override
  Future<AuthorizationCredentialAppleID?> login() async {
    AuthorizationCredentialAppleID token;
    try {
      //애플 로그인 성공
      token = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: "haruNyang.beside04.com",
          redirectUri: Uri.parse(
            "https://fishy-peat-hyacinth.glitch.me/callbacks/sign_in_with_apple",
          ),
        ),
      );
      return token;
    } catch (error) {
      //애플 로그인 실패
      return null;
    }
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> withdrawal() async {}
}

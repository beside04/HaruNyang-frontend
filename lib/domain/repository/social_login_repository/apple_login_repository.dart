import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class AppleLoginRepository {
  Future<AuthorizationCredentialAppleID?> login();

  Future<void> logout();

  Future<void> withdrawal();
}

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

abstract class AppleLoginRepository {
  Future<AuthorizationCredentialAppleID?> login();
}

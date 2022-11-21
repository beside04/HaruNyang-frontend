import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

abstract class SocialLoginRepository {
  Future<OAuthToken?> login();

  Future<UserIdResponse?> logout();
}

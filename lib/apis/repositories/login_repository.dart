// import 'package:dio/dio.dart';
// import 'package:frontend/apis/login_api.dart';
// import 'package:frontend/core/result.dart';
// import 'package:frontend/data/repository/token_repository_impl.dart';
// import 'package:frontend/domain/model/login_token_data.dart';
//
// class LoginRepository {
//   late final LoginApi _loginService;
//   late final TokenRepositoryImpl _tokenRepository;
//   final Dio dio;
//
//   LoginRepository({
//     required this.dio,
//   }) {
//     _loginService = LoginApi(dio: dio);
//   }
//
//   Future<bool> signup({
//     required String loginType,
//     required String? email,
//     required String socialId,
//     String? deviceToken,
//     required String nickname,
//     required String job,
//     required String birthDate,
//   }) async {
//     bool? result = await _loginService.signup(
//       email: email,
//       loginType: loginType,
//       socialId: socialId,
//       deviceId: deviceToken,
//       nickname: nickname,
//       job: job,
//       birthDate: birthDate,
//     );
//
//     return result;
//   }
//
//   Future<Result<String>> login({
//     required String loginType,
//     required String socialId,
//     required String deviceToken,
//   }) async {
//     String accessToken = '';
//
//     //로그인 api 호출
//
//     Result<LoginTokenData> result = await _loginService.login(loginType, socialId, deviceToken);
//
//     return await result.when(
//       success: (loginData) async {
//         await _tokenRepository.setAccessToken(loginData.accessToken);
//         return Result.success(accessToken);
//       },
//       error: (message) {
//         //로그인 에러 처리
//         return Result.error(message);
//       },
//     );
//   }
// }

// import 'package:frontend/domain/model/social_login_result.dart';
// import 'package:frontend/domains/login/model/index.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// final kakaoLoginProvider = StateNotifierProvider.autoDispose<KakaoLoginNotifier, KakaoLogin>((ref) {
//   socialLoginRepository = ref.read(socialLoginRepositoryProvider);
//   return KakaoLoginNotifier(
//     socialLoginRepository: socialLoginRepository;
//   );
// });
//
// class KakaoLoginNotifier extends StateNotifier<KakaoLogin> {
//   SocialLoginRepository socialLoginRepository
//   KakaoLoginNotifier({required this.socialLoginRepository}) : super(KakaoLogin.fromDefault());
//
//
//   Future<void> connectKakaoLogin() async {
//     //social id 얻기
//     final isSocialIdGet = await getSocialId(isSocialKakao: true);
//     if (!isSocialIdGet) {
//       Get.snackbar('알림', '카카오 세션과 연결이 실패했습니다.');
//       return;
//     }
//
//     getLoginSuccessData(isSocialKakao: true);
//   }
//
//   Future<void> connectAppleLogin() async {
//     //social id 얻기
//     final isSocialIdGet = await getSocialId(isSocialKakao: false);
//     if (!isSocialIdGet) {
//       Get.snackbar('알림', '애플 세션과 연결이 실패했습니다.');
//       return;
//     }
//
//     getLoginSuccessData(isSocialKakao: false);
//   }
//
//   Future<void> getLoginSuccessData({required bool isSocialKakao}) async {
//     final loginResult = await onLogin(isSocialKakao: isSocialKakao);
//
//     if (loginResult == 200) {
//       await loginDone();
//     } else if (loginResult == 404) {
//       Get.to(
//             () => LoginTermsInformationScreen(isSocialKakao: isSocialKakao),
//       );
//     }
//   }
//
//   Future<bool> getSocialId({required isSocialKakao}) async {
//     final socialLoginResult = isSocialKakao
//         ? await kakaoLoginUseCase.getKakaoSocialId()
//         : await appleLoginUseCase.getAppleSocialId();
//     final email = socialLoginResult.email;
//     final socialId = socialLoginResult.socialId;
//
//     if (socialId.isEmpty) {
//       return false;
//     }
//
//     _state.value = state.value.copyWith(
//       socialId: socialId,
//       email: email,
//       isSocialKakao: isSocialKakao,
//     );
//     return true;
//   }
//
//   Future<void> signupAndLogin(isSocialKakao) async {
//     await getSocialId(isSocialKakao: isSocialKakao);
//
//     Get.offAll(
//           () => SignInCompleteScreen(
//         email: state.value.email == "" ? null : state.value.email,
//         loginType: state.value.isSocialKakao == true ? "KAKAO" : "APPLE",
//         socialId: state.value.socialId,
//       ),
//     );
//   }
//
//   Future<int> onLogin({required isSocialKakao}) async {
//     int result = 0;
//     final loginResult = isSocialKakao
//         ? await kakaoLoginUseCase.login(state.value.socialId)
//         : await appleLoginUseCase.login(state.value.socialId);
//
//     await loginResult.when(
//       success: (accessToken) async {
//         result = 200;
//       },
//       error: (message) {
//         result = int.parse(message);
//
//         if (int.parse(message) == 404) {
//           // Get.snackbar('알림', '회원가입 되지 않은 유저입니다.');
//         } else {
//           Get.snackbar('알림', '로그인이 실패했습니다.');
//         }
//       },
//     );
//
//     return result;
//   }
//
//   void goHome() {
//     Get.offAll(
//           () => const HomeScreen(),
//       binding: BindingsBuilder(
//         getHomeViewModelBinding,
//       ),
//     );
//   }
//
//   Future<void> loginDone() async {
//     //캘린더 업데이트
//     Get.find<DiaryController>().initPage();
//
//     await Get.find<OnBoardingController>().getMyInformation();
//
//     Get.find<DiaryController>().getAllBookmarkData();
//
//     goHome();
//   }
//
//
//   Future<SocialLoginResult> getKakaoSocialId() async {
//     //카카오 social id 및 email 얻기
//     String email = '';
//     String socialId = '';
//
//     final OAuthToken? kakaoLoginResult = await socialLoginRepository.login();
//     if (kakaoLoginResult != null) {
//       User user = await UserApi.instance.me();
//
//       email = user.kakaoAccount?.email ?? '';
//       socialId = '${user.id}';
//     }
//
//     return SocialLoginResult(
//       email: email,
//       socialId: socialId,
//     );
//   }
// }

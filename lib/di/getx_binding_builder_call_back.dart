import 'package:frontend/data/data_source/remote_data/bookmark_api.dart';
import 'package:frontend/data/data_source/remote_data/diary_api.dart';
import 'package:frontend/data/data_source/remote_data/emotion_stamp_api.dart';
import 'package:frontend/data/data_source/remote_data/on_boarding_api.dart';
import 'package:frontend/data/data_source/remote_data/refresh_interceptor.dart';
import 'package:frontend/data/data_source/remote_data/reissue_token_api.dart';
import 'package:frontend/data/data_source/remote_data/wise_saying_api.dart';
import 'package:frontend/data/data_source/remote_data/withdraw_api.dart';
import 'package:frontend/data/repository/bookmark/bookmark_repository_impl.dart';
import 'package:frontend/data/repository/dark_mode/dark_mode_repository_impl.dart';
import 'package:frontend/data/repository/diary/diary_repository_impl.dart';
import 'package:frontend/data/repository/emoticon_weather/emoticon_repository_impl.dart';
import 'package:frontend/data/repository/emotion_stamp_repository/emotion_stamp_repository_impl.dart';
import 'package:frontend/data/repository/on_boarding_repository/on_boarding_repository_impl.dart';
import 'package:frontend/core/utils/notification_controller.dart';
import 'package:frontend/data/repository/push_messge_permission/dark_mode_repository_impl.dart';
import 'package:frontend/data/repository/reissu_token/reissue_token_repository_impl.dart';
import 'package:frontend/data/repository/token_repository_impl.dart';
import 'package:frontend/data/repository/social_login_repository/apple_login_impl.dart';
import 'package:frontend/data/repository/server_login_repository_impl.dart';
import 'package:frontend/data/repository/social_login_repository/kakao_login_impl.dart';
import 'package:frontend/data/repository/upload/file_upload_repository_impl.dart';

import 'package:frontend/data/repository/wise_saying/wise_saying_repository_impl.dart';
import 'package:frontend/data/repository/withdraw/withdraw_repository_impl.dart';
import 'package:frontend/domain/use_case/bookmark/bookmark_use_case.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/diary/delete_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/save_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/update_diary_use_case.dart';
import 'package:frontend/domain/use_case/emoticon_weather_use_case/get_emoticon_use_case.dart';
import 'package:frontend/domain/use_case/emoticon_weather_use_case/get_weather_use_case.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/domain/use_case/push_message_permission/push_message_permission_use_case.dart';
import 'package:frontend/domain/use_case/reissue_token_use_case/reissue_token_use_case.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/domain/use_case/upload/file_upload_use_case.dart';
import 'package:frontend/domain/use_case/wise_saying_use_case/get_wise_saying_use_case.dart';
import 'package:frontend/domain/use_case/withdraw/withdraw_use_case.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/global_controller/token/token_controller.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:frontend/presentation/diary/write_diary_view_model.dart';
import 'package:frontend/presentation/home/home_view_model.dart';
import 'package:frontend/presentation/login/login_terms_information/login_terms_information_viewmodel.dart';
import 'package:frontend/presentation/login/login_view_model.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_age/on_boarding_age_viewmodel.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_job/on_boarding_job_viewmodel.dart';
import 'package:frontend/presentation/on_boarding/on_boarding_nickname/on_boarding_nickname_viewmodel.dart';
import 'package:frontend/presentation/profile/profile_setting/profile_setting_view_model.dart';
import 'package:frontend/presentation/profile/profile_setting/withdraw/withdraw_view_model.dart';
import 'package:get/get.dart';

final TokenRepositoryImpl tokenRepositoryImpl = TokenRepositoryImpl();
final DarkModeRepositoryImpl darkModeRepositoryImpl = DarkModeRepositoryImpl();
final PushMessagePermissionRepositoryImpl pushMessagePermissionRepositoryImpl =
    PushMessagePermissionRepositoryImpl();

final TokenUseCase tokenUseCase = TokenUseCase(
  tokenRepository: tokenRepositoryImpl,
);

final DarkModeUseCase darkModeUseCase = DarkModeUseCase(
  darkModeRepository: darkModeRepositoryImpl,
);

final PushMessagePermissionUseCase pushMessagePermissionUseCase =
    PushMessagePermissionUseCase(
  pushMessagePermissionRepository: pushMessagePermissionRepositoryImpl,
);

final RefreshInterceptor interceptor = RefreshInterceptor(
  tokenUseCase: tokenUseCase,
);
final onBoardingApi = OnBoardingApi(
  interceptor: interceptor,
);
final wiseSayingApi = WiseSayingApi(
  interceptor: interceptor,
);
final diaryApi = DiaryApi(
  interceptor: interceptor,
);
final bookmarkApi = BookmarkApi(
  interceptor: interceptor,
);
final withdrawApi = WithdrawApi(
  interceptor: interceptor,
);
final emotionStampApi = EmotionStampApi(
  interceptor: interceptor,
);

final KakaoLoginImpl kakaoLoginImpl = KakaoLoginImpl();
final AppleLoginImpl appleLoginImpl = AppleLoginImpl();
final ServerLoginRepositoryImpl serverLoginImpl = ServerLoginRepositoryImpl();
final OnBoardingRepositoryImpl onBoardingImpl = OnBoardingRepositoryImpl(
  onBoardingApi: onBoardingApi,
);
final WiseSayingRepositoryImpl wiseSayingRepositoryImpl =
    WiseSayingRepositoryImpl(
  wiseSayingApi: wiseSayingApi,
);

final FileUploadRepositoryImpl fileUploadRepositoryImpl =
    FileUploadRepositoryImpl();
final diaryRepository = DiaryRepositoryImpl(
  diaryApi: diaryApi,
);
final bookmarkRepository = BookmarkRepositoryImpl(
  bookmarkApi: bookmarkApi,
);
final reissueTokenRepository = ReissueTokenRepositoryImpl(
  dataSource: ReissueTokenApi(),
);
//use case
final KakaoLoginUseCase kakaoLoginUseCase = KakaoLoginUseCase(
  socialLoginRepository: kakaoLoginImpl,
  serverLoginRepository: serverLoginImpl,
  tokenRepository: tokenRepositoryImpl,
  darkModeUseCase: darkModeUseCase,
  onBoardingRepository: onBoardingImpl,
  pushMessagePermissionUseCase: pushMessagePermissionUseCase,
);

final AppleLoginUseCase appleLoginUseCase = AppleLoginUseCase(
  socialLoginRepository: appleLoginImpl,
  serverLoginRepository: serverLoginImpl,
  tokenRepository: tokenRepositoryImpl,
  darkModeUseCase: darkModeUseCase,
  onBoardingRepository: onBoardingImpl,
  pushMessagePermissionUseCase: pushMessagePermissionUseCase,
);

final OnBoardingUseCase onBoardingUseCase = OnBoardingUseCase(
  onBoardingRepository: onBoardingImpl,
);

final WithdrawUseCase withDrawUseCase = WithdrawUseCase(
  withdrawRepository: WithdrawRepositoryImpl(
    withdrawApi: withdrawApi,
  ),
  kakaoLoginUseCase: kakaoLoginUseCase,
  appleLoginUseCase: appleLoginUseCase,
);

final GetWiseSayingUseCase getWiseSayingUseCase = GetWiseSayingUseCase(
  wiseSayingRepository: wiseSayingRepositoryImpl,
);

final GetEmoticonUseCase getEmoticonUseCase =
    GetEmoticonUseCase(emoticonRepository: EmoticonRepositoryImpl());

final GetWeatherUseCase getWeatherUseCase =
    GetWeatherUseCase(weatherRepository: EmoticonRepositoryImpl());

final GetEmotionStampUseCase getEmotionStampUseCase = GetEmotionStampUseCase(
  emotionStampRepository: EmotionStampRepositoryImpl(
    emotionStampApi: emotionStampApi,
  ),
);

final FileUploadUseCase fileUploadUseCase =
    FileUploadUseCase(fileUploadRepository: fileUploadRepositoryImpl);
final saveDiaryUseCase = SaveDiaryUseCase(
  diaryRepository: diaryRepository,
);
final updateDiaryUseCase = UpdateDiaryUseCase(
  diaryRepository: diaryRepository,
);
final deleteDiaryUseCase = DeleteDiaryUseCase(
  diaryRepository: diaryRepository,
);

final bookmarkUseCase = BookmarkUseCase(
  bookmarkRepository: bookmarkRepository,
);

final reissueTokenUseCase = ReissueTokenUseCase(
  reissueTokenRepository: reissueTokenRepository,
);

void getMainBinding() {
  Get.put(MainViewModel(
    darkModeUseCase: darkModeUseCase,
    pushMessagePermissionUseCase: pushMessagePermissionUseCase,
  ));
  Get.put(NotificationController());
}

void getLoginBinding() {
  Get.put(LoginViewModel(
    kakaoLoginUseCase: kakaoLoginUseCase,
    appleLoginUseCase: appleLoginUseCase,
  ));
}

void getDiaryBinding() {
  Get.put(
    DiaryViewModel(
      getEmoticonUseCase: getEmoticonUseCase,
      getWeatherUseCase: getWeatherUseCase,
    ),
  );
}

void getWriteDiaryBinding() {
  Get.put(
    WriteDiaryViewModel(),
  );
}

void getLoginTermsInformationBinding() {
  Get.put(LoginTermsInformationViewModel(
    kakaoLoginUseCase: kakaoLoginUseCase,
    appleLoginUseCase: appleLoginUseCase,
  ));
}

void getOnBoardingJobBinding() {
  Get.put(OnBoardingJobViewModel());
}

void getOnBoardingBirthBinding() {
  Get.put(OnBoardingAgeViewModel());
}

void getOnBoardingNickNameBinding() {
  Get.put(OnBoardingNicknameViewModel());
}

HomeViewModel getHomeViewModelBinding() {
  return Get.put(
    HomeViewModel(
      getEmotionStampUseCase: getEmotionStampUseCase,
    ),
  );
}

void getWithdrawViewModelBinding() {
  Get.put(
    WithdrawViewModel(
      withdrawUseCase: withDrawUseCase,
    ),
  );
}

void getProfileSettingViewModelBinding() {
  Get.put(
    ProfileSettingViewModel(
      kakaoLoginUseCase: kakaoLoginUseCase,
      appleLoginUseCase: appleLoginUseCase,
    ),
  );
}

void getOnBoardingControllerBinding() {
  Get.put(
    OnBoardingController(
      onBoardingUseCase: onBoardingUseCase,
      reissueTokenUseCase: reissueTokenUseCase,
    ),
  );
}

void getTokenControllerBinding() {
  Get.put(
    TokenController(
      tokenUseCase: tokenUseCase,
    ),
  );
}

void getDiaryControllerBinding() {
  Get.put(
    DiaryController(
      fileUploadUseCase: fileUploadUseCase,
      getWiseSayingUseCase: getWiseSayingUseCase,
      saveDiaryUseCase: saveDiaryUseCase,
      updateDiaryUseCase: updateDiaryUseCase,
      deleteDiaryUseCase: deleteDiaryUseCase,
      bookmarkUseCase: bookmarkUseCase,
      getEmotionStampUseCase: getEmotionStampUseCase,
    ),
  );
}

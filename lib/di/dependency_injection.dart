import 'package:dio/dio.dart';
import 'package:frontend/apis/banner_api.dart';
import 'package:frontend/apis/bookmark_api.dart';
import 'package:frontend/apis/diary_api.dart';
import 'package:frontend/apis/emotion_stamp_api.dart';
import 'package:frontend/apis/notice_api.dart';
import 'package:frontend/apis/on_boarding_api.dart';
import 'package:frontend/apis/refresh_interceptor.dart';
import 'package:frontend/apis/withdraw_api.dart';
import 'package:frontend/data/repository/banner/banner_repository_impl.dart';
import 'package:frontend/data/repository/bookmark/bookmark_repository_impl.dart';
import 'package:frontend/data/repository/dark_mode/dark_mode_repository_impl.dart';
import 'package:frontend/data/repository/diary/diary_repository_impl.dart';
import 'package:frontend/data/repository/emotion_stamp_repository/emotion_stamp_repository_impl.dart';
import 'package:frontend/data/repository/notice/notice_repository_impl.dart';
import 'package:frontend/data/repository/on_boarding_repository/on_boarding_repository_impl.dart';
import 'package:frontend/data/repository/pop_up/pop_up_repository_impl.dart';
import 'package:frontend/data/repository/push_messge/push_message_repository_impl.dart';
import 'package:frontend/data/repository/server_login_repository_impl.dart';
import 'package:frontend/data/repository/social_login_repository/apple_login_impl.dart';
import 'package:frontend/data/repository/social_login_repository/kakao_login_impl.dart';
import 'package:frontend/data/repository/token_repository_impl.dart';
import 'package:frontend/data/repository/withdraw/withdraw_repository_impl.dart';
import 'package:frontend/domain/use_case/bookmark/bookmark_use_case.dart';
import 'package:frontend/domain/use_case/dark_mode/dark_mode_use_case.dart';
import 'package:frontend/domain/use_case/diary/delete_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/get_diary_detail_use_case.dart';
import 'package:frontend/domain/use_case/diary/save_diary_use_case.dart';
import 'package:frontend/domain/use_case/diary/update_diary_use_case.dart';
import 'package:frontend/domain/use_case/emotion_stamp_use_case/get_emotion_diary_use_case.dart';
import 'package:frontend/domain/use_case/notice_use_case/get_notice_use_case.dart';
import 'package:frontend/domain/use_case/on_boarding_use_case/on_boarding_use_case.dart';
import 'package:frontend/domain/use_case/pop_up/pop_up_use_case.dart';
import 'package:frontend/domain/use_case/push_message/push_message_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/apple_login_use_case.dart';
import 'package:frontend/domain/use_case/social_login_use_case/kakao_login_use_case.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:frontend/domain/use_case/withdraw/withdraw_use_case.dart';

final TokenRepositoryImpl tokenRepositoryImpl = TokenRepositoryImpl();
final DarkModeRepositoryImpl darkModeRepositoryImpl = DarkModeRepositoryImpl();
final PushMessageRepositoryImpl pushMessagePermissionRepositoryImpl = PushMessageRepositoryImpl();
final PopUpRepositoryImpl popupRepositoryImpl = PopUpRepositoryImpl();

final TokenUseCase tokenUseCase = TokenUseCase(
  tokenRepository: tokenRepositoryImpl,
);

final DarkModeUseCase darkModeUseCase = DarkModeUseCase(
  darkModeRepository: darkModeRepositoryImpl,
);

final PushMessageUseCase pushMessagePermissionUseCase = PushMessageUseCase(
  pushMessagePermissionRepository: pushMessagePermissionRepositoryImpl,
);

final PopUpUseCase popUpUseCase = PopUpUseCase(
  popUpRepository: popupRepositoryImpl,
);
final dio = Dio();

Dio getDio() {
  dio.interceptors.add(interceptor);
  dio.options.headers.addAll({
    'accessToken': 'true',
  });
  return dio;
}

final RefreshInterceptor interceptor = RefreshInterceptor(
  tokenUseCase: tokenUseCase,
  serverLoginRepository: serverLoginImpl,
);
final onBoardingApi = OnBoardingApi(
  dio: getDio(),
  tokenRepository: tokenRepositoryImpl,
);
final diaryApi = DiaryApi(
  dio: getDio(),
);
final bookmarkApi = BookmarkApi(
  dio: getDio(),
);
final withdrawApi = WithdrawApi(
  dio: getDio(),
);
final emotionStampApi = EmotionStampApi(
  dio: getDio(),
);

final noticeApi = NoticeApi(
  dio: getDio(),
);

final bannerApi = BannerApi(
  dio: getDio(),
);

final KakaoLoginImpl kakaoLoginImpl = KakaoLoginImpl();
final AppleLoginImpl appleLoginImpl = AppleLoginImpl();
final ServerLoginRepositoryImpl serverLoginImpl = ServerLoginRepositoryImpl();
final OnBoardingRepositoryImpl onBoardingImpl = OnBoardingRepositoryImpl(
  onBoardingApi: onBoardingApi,
);
final diaryRepository = DiaryRepositoryImpl(
  diaryApi: diaryApi,
);
final bookmarkRepository = BookmarkRepositoryImpl(
  bookmarkApi: bookmarkApi,
);

final noticeRepository = NoticeRepositoryImpl(
  noticeApi: noticeApi,
);

final bannerRepository = BannerRepositoryImpl(
  bannerApi: bannerApi,
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

final GetNoticeUseCase getNoticeUseCase = GetNoticeUseCase(
  noticeRepository: noticeRepository,
);

final GetEmotionStampUseCase getEmotionStampUseCase = GetEmotionStampUseCase(
  emotionStampRepository: EmotionStampRepositoryImpl(
    emotionStampApi: emotionStampApi,
  ),
);

final GetDiaryDetailUseCase getDiaryDetailUseCase = GetDiaryDetailUseCase(diaryRepository: diaryRepository);

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
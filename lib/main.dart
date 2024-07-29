import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/providers/main/provider/main_provider.dart';
import 'package:frontend/ui/screen/home/home_screen.dart';
import 'package:frontend/ui/screen/password/password_verification_screen.dart';
import 'package:frontend/ui/screen/splash/splash_sreen.dart';
import 'package:frontend/utils/firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();

  // runApp() 호출 전 Flutter SDK 초기화
  String appkey = dotenv.env['NATIVE_APP_KEY'] ?? '';
  KakaoSdk.init(nativeAppKey: appkey);
  // getMainBinding();
  // // globalControllerBinding();
  final container = ProviderContainer();

  await container.read(mainProvider.notifier).initializeState();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
      fatal: true,
    );
  }).sendPort);

  initializeDateFormatting().then(
    (_) => runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return FGBGNotifier(
      onEvent: (event) {
        if (event == FGBGType.foreground && ref.read(mainProvider).isPasswordSet) {
          // 앱이 백그라운드에서 포그라운드로 돌아왔을 때 비밀번호가 설정 되어있다면 비밀번호 검증 페이지로 이동
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => const PasswordVerificationScreen(
                nextPage: null,
              ),
            ),
          );
        }
      },
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: MaterialApp(
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: analytics),
              ],
              navigatorKey: navigatorKey,
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              routes: {
                '/': (context) => const SplashScreen(),
                '/home': (context) => const HomeScreen(),
              },
              themeMode: ref.watch(mainProvider).themeMode,
              theme: lightMode(context),
              darkTheme: darkMode(context),
              // home: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}

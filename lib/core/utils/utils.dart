import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/config/theme/color_data.dart';

class GlobalUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static DateTime? currentBackPressTime;

  // 첫 로그인 페이지,홈,온보딩 페이지에서 뒤로가기 두번 클릭시 앱을 종료하고 boolean을 리턴하는 함수
  // 버튼 1번 클릭 시 토스트로 메시지 띄워주고 2초 안에 재 클릭 시 앱 종료
  static bool onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "한번 더 누르시면 종료됩니다.",
        gravity: ToastGravity.BOTTOM,
        backgroundColor: kGrayColor300,
        fontSize: 14,
        toastLength: Toast.LENGTH_SHORT,
      );
      return false;
    }
    return true;
  }

  static bool toBoolean(String? str) {
    if (str == 'true') {
      return true;
    }
    return false;
  }

  static setAnalyticsCustomScreenViewEvent(String screenName) async {
    await FirebaseAnalytics.instance.logEvent(
      name: screenName,
    );
  }

  static setAnalyticsCustomEvent(String eventName) async {
    await FirebaseAnalytics.instance.logEvent(
      name: eventName,
    );
  }
}

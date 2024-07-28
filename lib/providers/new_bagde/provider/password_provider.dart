import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewBadgeNotifier extends StateNotifier<bool> {
  NewBadgeNotifier() : super(false) {
    _loadIsReadAppLock();
  }

  Future<void> _loadIsReadAppLock() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool("IS_READ_APP_LOCK_SCREEN") ?? false;
  }

  Future<void> setIsReadAppLock(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("IS_READ_APP_LOCK_SCREEN", value);
    state = value;
  }
}

final newBadgeProvider = StateNotifierProvider<NewBadgeNotifier, bool>((ref) {
  return NewBadgeNotifier();
});

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/apis/storage_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

final requestHeaderInfoProvider =
StateNotifierProvider<RequestHeaderInfoNotifier, RequestHeaderInfo?>((ref) {
  return RequestHeaderInfoNotifier();
});

class RequestHeaderInfoNotifier extends StateNotifier<RequestHeaderInfo?> {
  RequestHeaderInfoNotifier() : super(null);

  Future<void> init() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final storage = StorageService();
    final String xPlatform = getXPlatform();
    final String xAppBuildNumber = packageInfo.buildNumber;
    final List<String> deviceInfos = await _getDeviceInfo();
    final String xDeviceModel = deviceInfos.first;
    final String xOSVersion = deviceInfos.last;

    state = RequestHeaderInfo(
      xPlatform: xPlatform,
      xAppBuildNumber: xAppBuildNumber,
      xDeviceModel: xDeviceModel,
      xOSVersion: xOSVersion,
    );
  }

  String getXPlatform() {
    return Platform.isAndroid ? 'ANDROID_PHONE' : 'IOS_PHONE';
  }

  Future<List<String>> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return _androidDeviceInfo(await deviceInfoPlugin.androidInfo);
    } else if (Platform.isIOS) {
      return _iosDeviceInfo(await deviceInfoPlugin.iosInfo);
    } else {
      return ['Not Found', 'Not Found'];
    }
  }

  List<String> _androidDeviceInfo(AndroidDeviceInfo info) {
    var release = info.version.release;
    var sdkInt = info.version.sdkInt;
    var manufacturer = info.manufacturer;
    var model = info.model;
    return ['$manufacturer $model', 'Android $release (SDK $sdkInt)'];
  }

  List<String> _iosDeviceInfo(IosDeviceInfo info) {
    var systemName = info.systemName;
    var version = info.systemVersion;
    var machine = info.utsname.machine;

    return [machine, '$systemName $version'];
  }

}

class RequestHeaderInfo {
  final String xPlatform;
  final String xAppBuildNumber;
  final String xDeviceModel;
  final String xOSVersion;

  RequestHeaderInfo({
    required this.xPlatform,
    required this.xAppBuildNumber,
    required this.xDeviceModel,
    required this.xOSVersion,
  });
}

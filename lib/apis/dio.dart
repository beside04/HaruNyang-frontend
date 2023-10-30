import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/apis/request_header_info.dart';
import 'package:frontend/apis/storage_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final logger = PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: true,
    compact: false,
  );

  var requestHeaderInfo = ref.watch(requestHeaderInfoProvider);
  dio.interceptors.add(logger);
  dio.interceptors.add(
    CustomInterceptor(
      storage: StorageService(),
      requestHeaderInfo: requestHeaderInfo,
    ),
  );
  return dio;

});

class CustomInterceptor extends Interceptor {
  final StorageService storage;
  final RequestHeaderInfo? requestHeaderInfo;

  CustomInterceptor({
    required this.storage,
    this.requestHeaderInfo,
  });

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    var accessToken = await storage.getAccessToken();
    var userId = await storage.getUserId();

    options.headers.addAll({
      'Authorization': 'Bearer $accessToken',
      'X-UserId': userId,
      'X-AppBuildNumber': requestHeaderInfo?.xAppBuildNumber,
      'X-DeviceModel': requestHeaderInfo?.xDeviceModel,
      'X-OSVersion': requestHeaderInfo?.xOSVersion,
    });

    print(options.uri);
    return super.onRequest(options, handler);
  }

  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) async {
  //   print(err);
  //   super.onError(err, handler);
  // }
}

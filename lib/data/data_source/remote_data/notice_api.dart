import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/global_service.dart';
import 'package:frontend/domain/model/notice/notice_data.dart';
import 'package:get/get.dart' hide Response;

class NoticeApi {
  final globalService = Get.find<GlobalService>();
  String get _baseUrl => globalService.usingServer.value;

  final Dio dio;

  NoticeApi({
    required this.dio,
  });

  Future<Result<List<NoticeData>>> getNotices(int limit, int page) async {
    try {
      String noticeUrl = '$_baseUrl/v2/notices';
      Response response;
      response = await dio.get(
        noticeUrl,
        queryParameters: {
          'limitCount': limit,
          'page': page,
        },
      );

      final Iterable noticeList = response.data;
      final List<NoticeData> noticeDataList =
          noticeList.map((e) => NoticeData.fromJson(e)).toList();

      return Result.success(noticeDataList);
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}

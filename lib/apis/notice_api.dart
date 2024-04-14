import 'package:dio/dio.dart';
import 'package:frontend/apis/response_result.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/domain/model/notice/notice_data.dart';

class NoticeApi {
  String get _baseUrl => usingServer;

  final Dio dio;

  NoticeApi({
    required this.dio,
  });

  Future<ResponseResult<List<NoticeData>>> getNotices(int limit, int page) async {
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
      final List<NoticeData> noticeDataList = noticeList.map((e) => NoticeData.fromJson(e)).toList();

      return ResponseResult.success(noticeDataList);
    } catch (e) {
      return ResponseResult.error(e.toString());
    }
  }
}

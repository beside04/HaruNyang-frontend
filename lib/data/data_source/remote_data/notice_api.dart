import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/notice/notice_data.dart';

class NoticeApi {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';
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

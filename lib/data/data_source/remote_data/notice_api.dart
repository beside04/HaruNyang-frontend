import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/notice/notice_data.dart';

class NoticeApi {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final Dio _client = Dio();

  Future<Result<List<NoticeData>>> getNotices(int limit, int page) async {
    try {
      String noticeUrl = '$_baseUrl/v2/notices';
      Response response;
      response = await _client.get(
        noticeUrl,
        queryParameters: {
          'limitCount': limit,
          'page': page,
        },
      );

      if (response.data['status'] == 200) {
        final Iterable noticeList = response.data['data']['data'];
        final List<NoticeData> noticeDataList =
            noticeList.map((e) => NoticeData.fromJson(e)).toList();

        return Result.success(noticeDataList);
      } else {
        return Result.error(
            '서버 error : status code : ${response.data['status']}');
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}

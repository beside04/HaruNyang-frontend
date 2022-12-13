import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/Emoticon/emoticon_data.dart';

class EmoticonApi {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final Dio _client = Dio();

  Future<Result<List<EmoticonData>>> getEmoticons(int limit, int page) async {
    try {
      String emoticonUrl = '$_baseUrl/v1/emotions';
      Response response;
      response = await _client.get(
        emoticonUrl,
        queryParameters: {
          'limitCount': limit,
          'page': page,
        },
      );

      if (response.data['status'] == 200) {
        final Iterable emoticonList = response.data['data']['data'];
        final List<EmoticonData> emoticonData =
            emoticonList.map((e) => EmoticonData.fromJson(e)).toList();

        return Result.success(emoticonData);
      } else {
        return Result.error(
            '서버 error : status code : ${response.data['status']}');
      }
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}

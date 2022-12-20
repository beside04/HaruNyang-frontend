import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/core/result.dart';
import 'package:http_parser/http_parser.dart';

class FileUploadApi {
  String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  final Dio _client = Dio();

  Future<Result<String>> uploadFile(
      Uint8List imageBytes, String fileName) async {
    String uploadUrl = '$baseUrl/v1/upload';
    try {
      Response response;
      final FormData formData = FormData.fromMap(
        {
          'file': MultipartFile.fromBytes(
            imageBytes,
            filename: fileName,
            contentType: MediaType('image', 'jpg'),
          ),
        },
      );

      response = await _client.post(
        uploadUrl,
        data: formData,
      );
      final String result = response.data;
      return Result.success(result);
    } on DioError catch (e) {
      String errMessage = '';

      if (e.response != null) {
        if (e.response!.statusCode != 200) {
          errMessage =
              'upload api의 응답 코드가 200이 아닙니다. statusCode=${e.response!.statusCode}';
        }
      } else {
        errMessage = e.message;
      }
      return Result.error(errMessage);
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}

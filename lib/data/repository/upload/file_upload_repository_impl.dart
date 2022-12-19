import 'dart:typed_data';

import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/file_upload_api.dart';
import 'package:frontend/domain/repository/upload/file_upload_repository.dart';

class FileUploadRepositoryImpl implements FileUploadRepository {
  final FileUploadApi _fileUploadApi = FileUploadApi();

  @override
  Future<Result<String>> uploadFile(
      Uint8List imageBytes, String fileName) async {
    return await _fileUploadApi.uploadFile(imageBytes, fileName);
  }
}

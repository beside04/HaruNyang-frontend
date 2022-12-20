import 'package:flutter/foundation.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/repository/upload/file_upload_repository.dart';

class FileUploadUseCase {
  final FileUploadRepository fileUploadRepository;

  FileUploadUseCase({
    required this.fileUploadRepository,
  });

  Future<Result<String>> call(Uint8List imageBytes, String fileName) async {
    return await fileUploadRepository.uploadFile(imageBytes, fileName);
  }
}

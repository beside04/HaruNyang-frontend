import 'dart:typed_data';

import 'package:frontend/core/result.dart';

abstract class FileUploadRepository {
  Future<Result<String>> uploadFile(Uint8List imageBytes, String fileName);
}

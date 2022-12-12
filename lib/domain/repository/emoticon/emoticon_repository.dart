import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/Emoticon/emoticon_data.dart';

abstract class EmoticonRepository {
  Future<Result<List<EmoticonData>>> getEmoticon(int limit, int page);
}

import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/emoticon_api.dart';
import 'package:frontend/domain/model/Emoticon/emoticon_data.dart';
import 'package:frontend/domain/repository/emoticon/emoticon_repository.dart';

class EmoticonRepositoryImpl implements EmoticonRepository {
  final EmoticonApi _dataSource = EmoticonApi();

  @override
  Future<Result<List<EmoticonData>>> getEmoticon(int limit, int page) async {
    return await _dataSource.getEmoticons(limit, page);
  }
}

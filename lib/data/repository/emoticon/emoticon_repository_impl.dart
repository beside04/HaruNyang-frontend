import 'package:frontend/core/result.dart';
import 'package:frontend/data/data_source/remote_data/emoticon_api.dart';
import 'package:frontend/domain/model/Emoticon/emoticon_data.dart';
import 'package:frontend/domain/repository/emoticon/emoticon_repository.dart';

class EmoticonRepositoryImpl implements EmoticonRepository {
  final EmoticonApi _dataSource = EmoticonApi();

  @override
  Future<Result<List<EmoticonData>>> getEmoticon(int limit, int page) async {
    if (emoticons.isEmpty) {
      final result = await _dataSource.getEmoticons(limit, page);
      result.when(
        success: (data) {
          emoticons = List.from(data);
        },
        error: (message) {},
      );

      return result;
    } else {
      return Result.success(emoticons);
    }
  }
}

List<EmoticonData> emoticons = [];

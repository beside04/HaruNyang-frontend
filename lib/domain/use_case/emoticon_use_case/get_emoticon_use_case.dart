import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/Emoticon/emoticon_data.dart';
import 'package:frontend/domain/repository/emoticon/emoticon_repository.dart';

class GetEmoticonUseCase {
  final EmoticonRepository emoticonRepository;

  GetEmoticonUseCase({
    required this.emoticonRepository,
  });

  Future<Result<List<EmoticonData>>> call(int limit, int page) async {
    return await emoticonRepository.getEmoticon(limit, page);
  }
}

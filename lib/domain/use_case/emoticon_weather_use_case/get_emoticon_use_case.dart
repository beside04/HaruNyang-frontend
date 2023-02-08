import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/emoticon_weather/emoticon_data.dart';
import 'package:frontend/domain/repository/emoticon_weather/emoticon_repository.dart';

class GetEmoticonUseCase {
  final EmoticonWeatherRepository emoticonRepository;

  GetEmoticonUseCase({
    required this.emoticonRepository,
  });

  Future<Result<List<EmoticonData>>> call(int limit, int page) async {
    return await emoticonRepository.getEmoticon(limit, page);
  }
}

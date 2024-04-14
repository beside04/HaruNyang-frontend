import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/notice/notice_data.dart';
import 'package:frontend/domain/repository/notice/notice_repository.dart';

class GetNoticeUseCase {
  final NoticeRepository noticeRepository;

  GetNoticeUseCase({
    required this.noticeRepository,
  });

  Future<ResponseResult<List<NoticeData>>> call(int limit, int page) async {
    return await noticeRepository.getNotices(limit, page);
  }
}

import 'package:frontend/apis/notice_api.dart';
import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/notice/notice_data.dart';
import 'package:frontend/domain/repository/notice/notice_repository.dart';

class NoticeRepositoryImpl extends NoticeRepository {
  final NoticeApi noticeApi;

  NoticeRepositoryImpl({
    required this.noticeApi,
  });

  @override
  Future<Result<List<NoticeData>>> getNotices(int limit, int page) async {
    return await noticeApi.getNotices(limit, page);
  }
}

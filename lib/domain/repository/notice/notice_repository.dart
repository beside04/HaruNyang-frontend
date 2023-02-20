import 'package:frontend/core/result.dart';
import 'package:frontend/domain/model/notice/notice_data.dart';

abstract class NoticeRepository {
  Future<Result<List<NoticeData>>> getNotices(int limit, int page);
}

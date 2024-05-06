import 'package:frontend/apis/response_result.dart';
import 'package:frontend/domain/model/notice/notice_data.dart';

abstract class NoticeRepository {
  Future<ResponseResult<List<NoticeData>>> getNotices(int limit, int page);
}

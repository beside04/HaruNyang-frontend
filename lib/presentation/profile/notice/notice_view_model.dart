import 'package:frontend/domain/model/notice/notice_data.dart';
import 'package:frontend/domain/use_case/notice_use_case/get_notice_use_case.dart';
import 'package:get/get.dart';

class NoticeViewModel extends GetxController {
  final GetNoticeUseCase getNoticeUseCase;

  NoticeViewModel({
    required this.getNoticeUseCase,
  }) {
    getNotice();
  }

  RxList<NoticeData> noticeData = <NoticeData>[].obs;

  Future<void> getNotice() async {
    int page = 0;
    int limit = 20;

    final result = await getNoticeUseCase(limit, page);

    result.when(
      success: (data) {
        noticeData.value = data;
      },
      error: (message) {},
    );
  }
}

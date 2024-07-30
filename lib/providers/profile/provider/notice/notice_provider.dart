import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/di/dependency_injection.dart';
import 'package:frontend/domain/model/notice/notice_data.dart';
import 'package:frontend/domain/use_case/notice_use_case/get_notice_use_case.dart';

final noticeProvider = StateNotifierProvider<NoticeNotifier, List<NoticeData>>((ref) {
  return NoticeNotifier(
    ref,
    getNoticeUseCase,
  );
});

class NoticeNotifier extends StateNotifier<List<NoticeData>> {
  NoticeNotifier(this.ref, this.getNoticeUseCase) : super([]);

  final Ref ref;
  final GetNoticeUseCase getNoticeUseCase;

  Future<void> getNotice() async {
    int page = 0;
    int limit = 20;

    final result = await getNoticeUseCase(limit, page);

    result.when(
      success: (data) {
        state = data;
      },
      error: (message) {},
    );
  }
}

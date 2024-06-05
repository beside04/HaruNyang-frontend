import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/domains/bookmark/bookmark_list_state_provider.dart';
import 'package:frontend/domains/main/provider/main_provider.dart';

final bookmarkListProvider =
    StateNotifierProvider<BookmarkListNotifier, BookmarkListState>((ref) {
  return BookmarkListNotifier();
});

class BookmarkListNotifier extends StateNotifier<BookmarkListState> {
  BookmarkListNotifier() : super(BookmarkListState());
}

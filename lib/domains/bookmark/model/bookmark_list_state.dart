import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/domains/bookmark/bookmark_list_state_provider.dart';

part 'bookmark_list_state.freezed.dart';
part 'bookmark_list_state.g.dart';

enum ListAPIStatus {
  idle,
  loading,
  loaded,
  error,
}

@freezed
class BookmarkListState with _$BookmarkListState {
  factory BookmarkListState({
    required int lastPage,
    required ListAPIStatus apiStatus,
    String? searchWord,
    String? emotionValue,
  }) = _BookmarkListState;

  factory BookmarkListState.fromJson(Map<String, dynamic> json) =>
      _$BookmarkListStateFromJson(json);

  // TODO : from default 만들기
  
  // BookmarkListState({
  //   this.lastPage = 0,
  //   this.apiStatus = ListAPIStatus.idle,
  //   this.searchWord,
  //   this.emotionValue,
  // });

  // BookmarkListState.fromDefault()
  //     : lastPage = 0,
  //       apiStateus = ListAPIStatus.idle,
  //       searchWord = null,
  //       emotionValue = null;
}

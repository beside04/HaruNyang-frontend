import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_state.freezed.dart';
part 'main_state.g.dart';

@freezed
class MainState with _$MainState {
  factory MainState({
    required ThemeMode themeMode,
    required bool pushMessagePermission,
    required bool marketingConsentAgree,
    required DateTime pushMessageTime,
  }) = _MainState;

  factory MainState.fromJson(Map<String, dynamic> json) => _$MainStateFromJson(json);
}

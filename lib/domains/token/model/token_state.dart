import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_state.freezed.dart';
part 'token_state.g.dart';

@freezed
class TokenState with _$TokenState {
  factory TokenState({
    String? accessToken,
  }) = _TokenState;

  factory TokenState.fromJson(Map<String, dynamic> json) => _$TokenStateFromJson(json);
}

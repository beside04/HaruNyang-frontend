import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

part 'profile_state.g.dart';

@freezed
class ProfileState with _$ProfileState {
  factory ProfileState({
    @Default('') String socialId,
    String? nickname,
    String? job,
    String? age,
    String? loginType,
    String? email,
  }) = _ProfileState;

  factory ProfileState.fromJson(Map<String, dynamic> json) =>
      _$ProfileStateFromJson(json);
}

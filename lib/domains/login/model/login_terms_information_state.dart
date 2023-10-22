import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_terms_information_state.freezed.dart';

part 'login_terms_information_state.g.dart';

@freezed
class LoginTermsInformationState with _$LoginTermsInformationState {
  factory LoginTermsInformationState({
    @Default(false) bool isAllCheckAgree,
    @Default(false) bool isTermsAgree,
    @Default(false) bool isPrivacyPolicyAgree,
    @Default(false) bool isMarketingConsentAgree,
    @Default(false) bool isOverseasRelocationConsentAgree,
  }) = _LoginTermsInformationState;

  factory LoginTermsInformationState.fromJson(Map<String, dynamic> json) => _$LoginTermsInformationStateFromJson(json);
}

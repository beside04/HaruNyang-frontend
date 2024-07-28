class KakaoLogin {
  final bool isSignup;
  final bool isSocialKakao;
  final String email;
  final String socialId;

  const KakaoLogin({
    required this.isSignup,
    required this.isSocialKakao,
    required this.email,
    required this.socialId,
  });

  KakaoLogin.fromDefault()
      : isSignup = false,
        isSocialKakao = false,
        email = '',
        socialId = '';

  KakaoLogin copyWith({
    bool? isSignup,
    bool? isSocialKakao,
    String? email,
    String? socialId,
  }) {
    return KakaoLogin(
      isSignup: isSignup ?? this.isSignup,
      isSocialKakao: isSocialKakao ?? this.isSocialKakao,
      email: email ?? this.email,
      socialId: socialId ?? this.socialId,
    );
  }
}

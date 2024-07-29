import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/repository/token_repository_impl.dart';
import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:frontend/providers/token/model/token_state.dart';

final tokenProvider = StateNotifierProvider<TokenNotifier, TokenState>((ref) {
  return TokenNotifier(
    tokenUseCase: TokenUseCase(
      tokenRepository: TokenRepositoryImpl(),
    ),
  )..init();
});

class TokenNotifier extends StateNotifier<TokenState> {
  final TokenUseCase tokenUseCase;

  TokenNotifier({required this.tokenUseCase}) : super(TokenState());

  void init() async {
    final token = await tokenUseCase.getAccessToken();
    state = TokenState(accessToken: token);
  }

  Future<String?> getAccessToken() async {
    return await tokenUseCase.getAccessToken();
  }
}

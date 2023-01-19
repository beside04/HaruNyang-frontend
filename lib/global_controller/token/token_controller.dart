import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:get/get.dart';

class TokenController extends GetxController {
  final TokenUseCase tokenUseCase;

  TokenController({
    required this.tokenUseCase,
  });

  Future<String?> getAccessToken() async {
    return await tokenUseCase.getAccessToken();
  }
}

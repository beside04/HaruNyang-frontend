import 'package:frontend/domain/use_case/token_use_case.dart';
import 'package:get/get.dart';

class MainViewModel extends GetxController {
  final TokenUseCase tokenUseCase;

  MainViewModel({
    required this.tokenUseCase,
  });

  String? token;

  Future<void> getAccessToken() async {
    token = await tokenUseCase.getAccessToken();
  }
}

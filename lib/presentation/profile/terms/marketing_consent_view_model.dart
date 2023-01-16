import 'package:get/get.dart';

class MarketingConsentViewModel extends GetxController {
  final isMarketingValue = true.obs;

  toggleMarketingValue() {
    isMarketingValue.value = !isMarketingValue.value;
  }
}

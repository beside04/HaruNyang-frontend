import 'package:get/get.dart';

class GlobalService extends GetxService {
  final RxString usingServer = RxString("");
  final RxBool isBannerOpen = RxBool(false);
  final RxString bannerUrl = RxString("");
}

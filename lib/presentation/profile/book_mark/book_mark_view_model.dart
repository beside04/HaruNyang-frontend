import 'package:get/get.dart';

class BookMarkViewModel extends GetxController {
  final RxBool isBookmark = false.obs;

  void toggleBookmark() {
    isBookmark.value = !isBookmark.value;
  }
}

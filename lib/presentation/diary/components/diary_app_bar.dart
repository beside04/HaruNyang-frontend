import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiaryAppBar extends GetView<DiaryViewModel>
    implements PreferredSizeWidget {
  final DateTime date;

  const DiaryAppBar({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor:
            Get.find<MainViewModel>().themeMode.value == ThemeMode.light
                ? const Color(0xffffac60)
                : kGrayColor950,
        title: Text(
          DateFormat('MM월 dd일').format(date),
          style: Theme.of(context).textTheme.headline3,
        ),
        leading: controller.isEmotionModal.value
            ? null
            : IconButton(
                onPressed: () {
                  controller.popUpEmotionModal();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20.w,
                ),
              ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

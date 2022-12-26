import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PastDiaryAppBar extends GetView<DiaryViewModel>
    implements PreferredSizeWidget {
  final DateTime date;

  const PastDiaryAppBar({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppBar(
        backgroundColor: const Color(0xffE69954),
        elevation: 0,
        centerTitle: true,
        title: Text(
          DateFormat('MM월 dd일').format(date),
          style: kHeader3BlackStyle,
        ),
        leading: controller.isEmotionModal.value
            ? IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: kBlackColor,
                  size: 20.w,
                ),
              )
            : IconButton(
                onPressed: () {
                  controller.swapStackChildren2();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: kBlackColor,
                  size: 20.w,
                ),
              ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

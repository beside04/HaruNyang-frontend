import 'package:flutter/material.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/components/back_icon.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/ui/screen/home/home_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DiaryAppBar extends GetView<DiaryViewModel> implements PreferredSizeWidget {
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
        backgroundColor: Theme.of(context).colorScheme.brightness == Brightness.dark ? kGrayColor950 : const Color(0xffffac60),
        title: Text(
          DateFormat('M월 d일').format(date),
          style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
        ),
        leading: controller.isEmotionModal.value
            ? BackIcon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                },
              )
            : BackIcon(
                onPressed: () {
                  controller.popUpEmotionModal();
                },
              ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

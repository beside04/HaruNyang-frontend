import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domains/diary/provider/diary_select_provider.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/screen/home/home_screen.dart';
import 'package:intl/intl.dart';

class DiaryAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final DateTime date;

  const DiaryAppBar({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, child) {
      return AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).colorScheme.backgroundModal,
          systemNavigationBarDividerColor: Theme.of(context).colorScheme.backgroundModal,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.brightness == Brightness.dark
            ? kGrayColor950
            :
            // const Color(0xff09B56C),
            const Color(0xffffac60),
        title: Text(
          DateFormat('M월 d일').format(date),
          style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
        ),
        leading: ref.watch(diarySelectProvider).isEmotionModal
            ? BackIcon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                },
              )
            : BackIcon(
                onPressed: () {
                  ref.watch(diarySelectProvider.notifier).popUpEmotionModal();
                },
              ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

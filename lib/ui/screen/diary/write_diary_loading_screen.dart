import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:lottie/lottie.dart';

class WriteDiaryLoadingScreen extends ConsumerStatefulWidget {
  final DiaryData diaryData;
  final DateTime date;
  final bool isEditScreen;

  const WriteDiaryLoadingScreen({
    Key? key,
    required this.diaryData,
    required this.date,
    this.isEditScreen = false,
  }) : super(key: key);

  @override
  WriteDiaryLoadingScreenState createState() => WriteDiaryLoadingScreenState();
}

class WriteDiaryLoadingScreenState extends ConsumerState<WriteDiaryLoadingScreen> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.isEditScreen) {
        ref.watch(diaryProvider.notifier).updateDiaryDetail(widget.diaryData, widget.date);
      } else {
        ref.watch(diaryProvider.notifier).saveDiaryDetail(widget.diaryData, widget.date);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 60.0.w),
              child: Lottie.asset(
                'lib/config/assets/lottie/loading.json',
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "당신을 위로할 쪽지를 쓰고 있어요",
              style: kHeader5Style.copyWith(
                color: Theme.of(context).colorScheme.textTitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

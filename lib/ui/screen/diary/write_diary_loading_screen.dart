import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:lottie/lottie.dart';

class WriteDiaryLoadingScreen extends ConsumerStatefulWidget {
  final DiaryDetailData diaryData;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).colorScheme.brightness == Brightness.dark ? kGrayColor950 : kWhiteColor,
          systemNavigationBarDividerColor: Theme.of(context).colorScheme.brightness == Brightness.dark ? kGrayColor950 : kWhiteColor,
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.top + 56),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'lib/config/assets/lottie/loading.json',
                height: 160,
                width: 160,
                fit: BoxFit.fill,
              ),
              Text(
                "당신을 위한 편지를 쓰고 있어요",
                style: kHeader5Style.copyWith(
                  color: Theme.of(context).colorScheme.textTitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/presentation/diary/write_diary_loading_view_model.dart';
import 'package:get/get.dart';

class WriteDiaryLoadingScreen extends StatefulWidget {
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
  // ignore: library_private_types_in_public_api
  _WriteDiaryLoadingScreenState createState() =>
      _WriteDiaryLoadingScreenState();
}

class _WriteDiaryLoadingScreenState extends State<WriteDiaryLoadingScreen> {
  final writeDiaryLoadingViewModelController =
      Get.find<WriteDiaryLoadingViewModel>();
  final diaryController = Get.find<DiaryController>();

  Timer? _timer;
  bool _shouldShowWidget = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEditScreen) {
      writeDiaryLoadingViewModelController.updateDiaryDetail(
          widget.diaryData, widget.date);
    } else {
      writeDiaryLoadingViewModelController.saveDiaryDetail(
          widget.diaryData, widget.date);
    }

    if (mounted) {
      _timer = Timer(const Duration(seconds: 1), () {
        setState(() {
          _shouldShowWidget = true;
          _counterTest = 85;
        });
      });

      _startCounting();
    }
  }

  late Timer _countingTimer;

  void _startCounting() {
    _countingTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _counterTest = 100;
        });
      }
    });
  }

  double _counterTest = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _countingTimer.cancel();
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
            Stack(
              children: [
                AnimatedOpacity(
                  opacity: _shouldShowWidget ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "lib/config/assets/images/character/character6.png",
                          height: 260.h,
                        ),
                        Text(
                          "일기 작성이 끝났네요!",
                          style: kHeader3Style.copyWith(
                            color: Theme.of(context).colorScheme.textTitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: _shouldShowWidget ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: Column(
                    children: [
                      Text(
                        "하루냥이 한 마디를",
                        style: kHeader3Style.copyWith(
                          color: Theme.of(context).colorScheme.textTitle,
                        ),
                      ),
                      Text(
                        "준비하고 있어요",
                        style: kHeader3Style.copyWith(
                          color: Theme.of(context).colorScheme.textTitle,
                        ),
                      ),
                      Image.asset(
                        "lib/config/assets/images/character/character7.png",
                        height: 260.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0.h),
                        child: FAProgressBar(
                          currentValue: _counterTest,
                          animatedDuration: const Duration(milliseconds: 2500),
                          size: 15,
                          displayText: '',
                          progressColor: kOrange300Color,
                          backgroundColor: kGrayColor50,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "집사들이 슬퍼하면 고양이 숲에 비가 온답니다",
                        style: kBody1Style.copyWith(
                            color: Theme.of(context).colorScheme.textTitle),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

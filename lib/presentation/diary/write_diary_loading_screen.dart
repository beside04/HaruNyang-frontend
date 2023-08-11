import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/library/FAProgressBar.dart';
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

    SchedulerBinding.instance.addPostFrameCallback((_) {
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
    });
  }

  late Timer _countingTimer;

  void _startCounting() {
    _countingTimer = Timer(const Duration(milliseconds: 5000), () {
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
                          "lib/config/assets/images/character/character9.png",
                          height: 180.h,
                        ),
                        Text(
                          "하루냥에게 일기 전달 완료!",
                          style: kHeader5Style.copyWith(
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
                      Image.asset(
                        "lib/config/assets/images/character/character10.png",
                        height: 180.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.0.w),
                        child: FAProgressBar(
                          currentValue: _counterTest,
                          animatedDuration: const Duration(milliseconds: 5000),
                          size: 15,
                          displayText: '',
                          progressColor: kOrange300Color,
                          backgroundColor:
                              Theme.of(context).colorScheme.surface_02,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}

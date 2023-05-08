import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:get/get.dart';

class WriteDiaryLoadingScreen extends StatefulWidget {
  @override
  _WriteDiaryLoadingScreenState createState() =>
      _WriteDiaryLoadingScreenState();
}

class _WriteDiaryLoadingScreenState extends State<WriteDiaryLoadingScreen> {
  Timer? _timer;
  bool _shouldShowWidget = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 1), () {
      setState(() {
        _shouldShowWidget = true;
      });
    });
    Timer(Duration(seconds: 3), () {
      Get.back();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
            Image.asset(
              "lib/config/assets/images/character/rain_character1.png",
            ),
            Stack(
              children: [
                AnimatedOpacity(
                  opacity: _shouldShowWidget ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Text(
                    "일기 작성이 끝났네요!",
                    style: kHeader3Style.copyWith(
                      color: Theme.of(context).colorScheme.textTitle,
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
                        "물고 오는 중이에요",
                        style: kHeader3Style.copyWith(
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

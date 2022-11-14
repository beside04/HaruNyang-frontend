import 'package:flutter/material.dart';

class EmotionStampScreen extends StatelessWidget {
  const EmotionStampScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('감정 스탬프'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('감정 스탬프'),
          ],
        ),
      ),
    );
  }
}

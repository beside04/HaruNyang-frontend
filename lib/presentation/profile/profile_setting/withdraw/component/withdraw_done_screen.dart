import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';

class WithdrawDoneScreen extends StatelessWidget {
  const WithdrawDoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackGroundLightColor,
        elevation: 0,
      ),
      body: Padding(
        padding: kPrimaryPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '그동안',
              style: kHeader3BlackStyle,
            ),
            Text(
              '하루냥을 이용해 주셔서',
              style: kHeader3BlackStyle,
            ),
            Text(
              '감사합니다.',
              style: kHeader3BlackStyle,
            ),
            const Spacer(),
            Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '나를 성장 시킨건 이별이 아니었다.',
                  style: kBody1BlackStyle,
                ),
                Text(
                  '함께했던 시간이었지',
                  style: kBody1BlackStyle,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  '하상욱',
                  style: kHeader3BlackStyle,
                )
              ],
            )),
            const Spacer(),
            Padding(
              padding: kPrimaryPadding,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {},
                  child: Text('첫 화면으로'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

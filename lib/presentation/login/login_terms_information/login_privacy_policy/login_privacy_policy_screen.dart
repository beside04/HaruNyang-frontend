import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:get/get.dart';

class LoginPrivacyPolicyScreen extends StatelessWidget {
  const LoginPrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back(result: true);
        return Future(() => true);
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 64.h,
            ),
            IconButton(
              onPressed: () {
                Get.back(result: true);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 32.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    "개인정보 처리방침",
                    style: kHeader1BlackStyle,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mi bibendum sollicitudin nunc quis sit morbi diam. Eget ornare viverra quis risus. Semper et et sollicitudin erat lorem odio ipsum. Aliquet purus, neque, at pellentesque vitae lectus. Viverra nunc libero eu bibendum massa in vitae viverra. At amet elementum felis lectus nascetur vestibulum id. Nisl vulputate tellus morbi nec urna, nunc, sed massa. Semper blandit consequat diam cursus dictum. Aliquet libero in elit, morbi eget interdum. Pulvinar hendrerit fringilla viverra ipsum, gravida. Morbi sagittis tellus nunc gravida ornare. Est, gravida feugiat varius lectus quam sagittis ut ut in. Odio feugiat condimentum lacinia consectetur. Amet, augue ut hac duis pretium pellentesque nulla. Sagittis ullamcorper quam interdum blandit mattis magna est aliquam, convallis. Faucibus nec orci mauris, convallis ullamcorper. Nec faucibus vestibulum ornare iaculis eget. ",
                    style: kSubtitle3BlackStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

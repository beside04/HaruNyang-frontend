import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:get/get.dart';

class MarketingConsentScreen extends StatelessWidget {
  const MarketingConsentScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kBlackColor),
        backgroundColor: kWhiteColor,
        title: Text(
          "마케팅 정보 수신 동의",
          style: kHeader3BlackStyle,
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.close,
            ),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          thickness: 4.0,
          radius: const Radius.circular(8.0),
          child: Markdown(
            data: '''
마케팅 정보 수신 여부 및 마케팅을 위한 개인정보 수집이용을 거부하실 수 있으며, 거부 시에도 하루냥 서비스를 이용하실 수 있으나, 동의를 거부한 경우 각종 소식 및 이벤트 참여에 제한이 있을 수 있습니다.

1. 개인정보 수집 항목 : 카카오 계정, 이메일
2. 개인정보 수집 이용 목적 
    - 이벤트 운영 및 광고성 정보 전송
    - 서비스 관련 정보 전송
3. 보유 및 이용기간 : 이용자가 동의를 철회하거나, 탈퇴시까지 보유 및 이용

이 약관은 2023년 1월 29일에 업데이트 되었습니다.

---

 

Copyright © 하루냥. All rights reserved.''',
            styleSheet: MarkdownStyleSheet(
              h2: kHeader3BlackStyle,
              h3: kSubtitle1BlackStyle,
              p: kBody1BlackStyle,
            ),
          ),
        ),
      ),
    );
  }
}

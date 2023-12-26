import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domains/main/provider/main_provider.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:notification_permissions/notification_permissions.dart';

class MarketingConsentScreen extends ConsumerWidget {
  final bool isProfileScreen;

  const MarketingConsentScreen({
    Key? key,
    required this.isProfileScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_Terms_MarketingAgree',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "마케팅 정보 수신 동의",
            style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
          ),
          elevation: 0,
          leading: isProfileScreen
              ? BackIcon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null,
          actions: [
            isProfileScreen
                ? Container()
                : IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  )
          ],
          automaticallyImplyLeading: isProfileScreen ? true : false,
        ),
        body: SafeArea(
          child: Scrollbar(
            thumbVisibility: true,
            thickness: 4.0,
            radius: const Radius.circular(8.0),
            child: Stack(
              children: [
                Markdown(
                  shrinkWrap: true,
                  data: '''
마케팅 정보 수신 여부 및 마케팅을 위한 개인정보 수집이용을 거부하실 수 있으며, 거부 시에도 하루냥 서비스를 이용하실 수 있으나, 동의를 거부한 경우 각종 소식 및 이벤트 참여에 제한이 있을 수 있습니다.

1. 개인정보 수집 항목 : 카카오 계정, 이메일
2. 개인정보 수집 이용 목적 
    - 이벤트 운영 및 광고성 정보 전송
    - 서비스 관련 정보 전송
3. 보유 및 이용기간 : 이용자가 동의를 철회하거나, 탈퇴시까지 보유 및 이용

이 약관은 2023년 1월 29일에 업데이트 되었습니다.

---

 

# Copyright © 하루냥. All rights reserved.
''',
                  styleSheet: MarkdownStyleSheet(
                    h1: kBody3Style.copyWith(color: Theme.of(context).colorScheme.textLowEmphasis),
                    h1Align: WrapAlignment.center,
                    h2: kHeader2Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                    h2Padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    h3: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                    h3Padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    h4: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                    p: kBody2Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                    horizontalRuleDecoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 1.0,
                          color: Theme.of(context).colorScheme.border,
                        ),
                      ),
                    ),
                  ),
                ),
                isProfileScreen
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).colorScheme.border,
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Theme.of(context).colorScheme.border,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: kPrimaryPadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "하루냥의 마케팅 소식을 받아볼게요.",
                                  style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                ),
                                SizedBox(
                                  height: 32.0.h,
                                  child: Consumer(builder: (context, ref, child) {
                                    return FlutterSwitch(
                                      padding: 2,
                                      width: 52.0.w,
                                      activeColor: Theme.of(context).primaryColor,
                                      inactiveColor: kGrayColor250,
                                      toggleSize: 28.0.w,
                                      value: ref.watch(mainProvider).marketingConsentAgree,
                                      borderRadius: 50.0.w,
                                      onToggle: (val) async {
                                        Future<PermissionStatus> permissionStatus = NotificationPermissions.getNotificationPermissionStatus();
                                        if (await permissionStatus == PermissionStatus.denied || await permissionStatus == PermissionStatus.unknown) {
                                          permissionStatus = NotificationPermissions.requestNotificationPermissions();
                                        } else {
                                          ref.watch(mainProvider.notifier).toggleMarketingConsentCheck();
                                        }
                                      },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

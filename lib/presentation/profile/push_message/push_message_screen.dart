import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/library/date_time_spinner/date_picker_theme.dart';
import 'package:frontend/core/utils/library/date_time_spinner/date_time_spinner.dart';
import 'package:frontend/core/utils/library/date_time_spinner/i18n_model.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/main_view_model.dart';
import 'package:frontend/presentation/components/back_icon.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/components/toast.dart';
import 'package:frontend/presentation/profile/components/profile_button.dart';
import 'package:frontend/presentation/profile/push_message/push_message_view_model.dart';
import 'package:frontend/presentation/profile/terms/marketing_consent_screen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notification_permissions/notification_permissions.dart';

class PushMessageScreen extends GetView<PushMessageViewModel> {
  const PushMessageScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getPushMessageControllerBinding();
    final mainViewController = Get.find<MainViewModel>();

    return DefaultLayout(
      screenName: 'Screen Event : 프로필->푸쉬 메세지 설정 Screen',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '푸시메세지 설정',
            style: kHeader4Style.copyWith(
                color: Theme.of(context).colorScheme.textTitle),
          ),
          elevation: 0,
          leading: BackIcon(
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Divider(
                thickness: 12.h,
              ),
              Obx(
                    () => ProfileButton(
                  padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  icon: FlutterSwitch(
                    padding: 2,
                    width: 52.0.w,
                    height: 32.0.h,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: kGrayColor250,
                    toggleSize: 28.0.w,
                    value: mainViewController.pushMessagePermission.value,
                    borderRadius: 50.0.w,
                    onToggle: (val) async {
                      Future<PermissionStatus> permissionStatus =
                      NotificationPermissions
                          .getNotificationPermissionStatus();

                      if (!val) {
                        controller.cancelAllNotifications();
                      }

                      if (await permissionStatus == PermissionStatus.denied ||
                          await permissionStatus == PermissionStatus.unknown) {
                        permissionStatus = NotificationPermissions
                            .requestNotificationPermissions();
                      } else {
                        if (!mainViewController.marketingConsentAgree.value &&
                            !mainViewController.pushMessagePermission.value) {
                          // ignore: use_build_context_synchronously
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0),
                              ),
                            ),
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                  MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0.h, right: 18.0.w),
                                      child: IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: SvgPicture.asset(
                                          "lib/config/assets/images/profile/close.svg",
                                        ),
                                        color: kGrayColor500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "마케팅 정보 수신동의",
                                    style: kHeader4Style.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textTitle),
                                  ),
                                  Text(
                                    "마케팅 정보에 수신동의를 하셔야",
                                    style: kHeader6Style.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textSubtitle),
                                  ),
                                  Text(
                                    "푸시메시지를 받을 수 있어요",
                                    style: kHeader6Style.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .textSubtitle),
                                  ),
                                  SizedBox(
                                    height: 28.0.h,
                                  ),
                                  BottomButton(
                                    title: '수신 동의',
                                    onTap: () {
                                      Get.back();
                                      Get.to(
                                            () => const MarketingConsentScreen(
                                          isProfileScreen: true,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          mainViewController.togglePushMessageValue();
                        }
                      }
                    },
                  ),
                  title: '푸시메세지 알림',
                  titleColor: Theme.of(context).colorScheme.textTitle,
                  onPressed: null,
                ),
              ),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
              Obx(
                    () => ProfileButton(
                  icon: Text(
                    DateFormat('aa hh:mm', 'ko_KR')
                        .format(mainViewController.pushMessageTime.value),
                    style: kHeader5Style.copyWith(
                      color: mainViewController.pushMessagePermission.value
                          ? Theme.of(context).colorScheme.textTitle
                          : Theme.of(context).colorScheme.textDisabled,
                    ),
                  ),
                  title: '시간',
                  titleColor: mainViewController.pushMessagePermission.value
                      ? Theme.of(context).colorScheme.textTitle
                      : Theme.of(context).colorScheme.textDisabled,
                  onPressed: () {
                    if (mainViewController.pushMessagePermission.value) {
                      DatePicker.showTime12hPicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          mainViewController.setPushMessageTime(date.toString());

                          controller.dailyAtTimeNotification(
                            Time(date.hour, date.minute, 00),
                          );

                          toast(
                            context: context,
                            text: '변경을 완료했어요.',
                            isCheckIcon: true,
                          );
                        },
                        currentTime: mainViewController.pushMessageTime.value,
                        locale: LocaleType.ko,
                        theme: DatePickerTheme(
                          itemStyle: kSubtitle1Style.copyWith(
                              color: Theme.of(context).colorScheme.textBody),
                          backgroundColor:
                          Theme.of(context).colorScheme.backgroundModal,
                          title: "발송시간 변경",
                        ),
                      );
                    }
                  },
                ),
              ),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/library/date_time_spinner/date_picker_theme.dart' as picker_theme;
import 'package:frontend/core/utils/library/date_time_spinner/date_time_spinner.dart';
import 'package:frontend/core/utils/library/date_time_spinner/i18n_model.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domains/main/provider/main_provider.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/toast.dart';
import 'package:frontend/ui/screen/profile/components/profile_button.dart';
import 'package:intl/intl.dart';
import 'package:notification_permissions/notification_permissions.dart';

class PushMessageScreen extends ConsumerWidget {
  const PushMessageScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_PushMessage',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '푸시메세지 설정',
            style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
          ),
          elevation: 0,
          leading: BackIcon(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Divider(
                thickness: 12.h,
              ),
              Consumer(builder: (context, ref, child) {
                return ProfileButton(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  icon: FlutterSwitch(
                    padding: 2,
                    width: 52.0.w,
                    height: 32.0.h,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveColor: kGrayColor250,
                    toggleSize: 28.0.w,
                    value: ref.watch(mainProvider).pushMessagePermission,
                    borderRadius: 50.0.w,
                    onToggle: (val) async {
                      Future<PermissionStatus> permissionStatus = NotificationPermissions.getNotificationPermissionStatus();

                      if (!val) {
                        ref.watch(mainProvider.notifier).cancelAllNotifications();
                      }

                      if (await permissionStatus == PermissionStatus.denied || await permissionStatus == PermissionStatus.unknown) {
                        permissionStatus = NotificationPermissions.requestNotificationPermissions();
                      } else {
                        ref.watch(mainProvider.notifier).togglePushMessageValue();
                      }
                    },
                  ),
                  title: '푸시메세지 알림',
                  titleColor: Theme.of(context).colorScheme.textTitle,
                  onPressed: null,
                );
              }),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
              Consumer(builder: (context, ref, child) {
                return ProfileButton(
                  icon: Text(
                    DateFormat('aa hh:mm', 'ko_KR').format(ref.watch(mainProvider).pushMessageTime),
                    style: kHeader5Style.copyWith(
                      color: ref.watch(mainProvider).pushMessagePermission ? Theme.of(context).colorScheme.textTitle : Theme.of(context).colorScheme.textDisabled,
                    ),
                  ),
                  title: '시간',
                  titleColor: ref.watch(mainProvider).pushMessagePermission ? Theme.of(context).colorScheme.textTitle : Theme.of(context).colorScheme.textDisabled,
                  onPressed: () {
                    if (ref.watch(mainProvider).pushMessagePermission) {
                      DatePicker.showTime12hPicker(
                        context,
                        showTitleActions: true,
                        onConfirm: (date) {
                          ref.watch(mainProvider.notifier).setPushMessageTime(date.toString());

                          ref.watch(mainProvider.notifier).dailyAtTimeNotification(
                                Time(date.hour, date.minute, 00),
                              );

                          toast(
                            context: context,
                            text: '변경을 완료했어요.',
                            isCheckIcon: true,
                          );
                        },
                        currentTime: ref.watch(mainProvider).pushMessageTime,
                        locale: LocaleType.ko,
                        theme: picker_theme.DatePickerTheme(
                          itemStyle: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                          backgroundColor: Theme.of(context).colorScheme.backgroundModal,
                          title: "발송시간 변경",
                        ),
                      );
                    }
                  },
                );
              }),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domains/main/provider/main_provider.dart';
import 'package:frontend/domains/new_bagde/provider/password_provider.dart';
import 'package:frontend/domains/password/provider/password_provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/ui/screen/password/password_change_screen.dart';
import 'package:frontend/ui/screen/password/password_setting_screen.dart';
import 'package:frontend/ui/screen/profile/components/profile_button.dart';
import 'package:local_auth/local_auth.dart';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({super.key});

  @override
  PasswordScreenState createState() => PasswordScreenState();
}

class PasswordScreenState extends ConsumerState<PasswordScreen> {
  final LocalAuthentication auth = LocalAuthentication();

  _SupportState _supportState = _SupportState.unknown;

  @override
  void initState() {
    super.initState();

    ref.read(newBadgeProvider.notifier).setIsReadAppLock(true);

    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported ? _SupportState.supported : _SupportState.unsupported),
        );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Profile_Password',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '앱 잠금',
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
                    inactiveColor: Theme.of(context).colorScheme.iconSubColor,
                    toggleSize: 28.0.w,
                    value: ref.watch(mainProvider).isPasswordSet,
                    borderRadius: 50.0.w,
                    onToggle: (val) async {
                      if (!val) {
                        ref.read(mainProvider.notifier).disablePassword();
                      } else {
                        if (await ref.read(mainProvider.notifier).isPasswordStored()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PasswordSettingScreen(),
                            ),
                          );
                        } else {
                          showDialog(
                            barrierDismissible: false,
                            context: navigatorKey.currentContext!,
                            builder: (context) {
                              return WillPopScope(
                                onWillPop: () async => false,
                                child: DialogComponent(
                                  titlePadding: EdgeInsets.zero,
                                  title: "",
                                  content: Column(
                                    children: [
                                      Text(
                                        "비밀번호 설정",
                                        style: kHeader3Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                                      ),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      Text(
                                        "비밀번호를 분실하면 찾을 수 없으니\n신중하게 설정해주세요!",
                                        textAlign: TextAlign.center,
                                        style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                      ),
                                    ],
                                  ),
                                  actionContent: [
                                    DialogButton(
                                      title: "돌아가기",
                                      onTap: () async {
                                        Navigator.pop(context);
                                      },
                                      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                                      textStyle: kHeader5Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                    ),
                                    SizedBox(
                                      width: 12.w,
                                    ),
                                    DialogButton(
                                      title: "비밀번호 설정",
                                      onTap: () async {
                                        Navigator.pop(context);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const PasswordSettingScreen(),
                                          ),
                                        );
                                      },
                                      backgroundColor: kOrange200Color,
                                      textStyle: kHeader5Style.copyWith(color: kWhiteColor),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      }
                    },
                  ),
                  title: '비밀번호 설정',
                  titleColor: Theme.of(context).colorScheme.textTitle,
                  onPressed: null,
                );
              }),
              Visibility(
                visible: ref.watch(mainProvider).isPasswordSet == false,
                child: Divider(
                  thickness: 1.h,
                  height: 1.h,
                  color: Theme.of(context).colorScheme.border,
                ),
              ),
              Visibility(
                visible: ref.watch(mainProvider).isPasswordSet == true,
                child: Column(
                  children: [
                    if (_supportState == _SupportState.supported)
                      Column(
                        children: [
                          Divider(
                            thickness: 1.h,
                            height: 1.h,
                            color: Theme.of(context).colorScheme.border,
                          ),
                          Consumer(builder: (context, ref, child) {
                            return ProfileButton(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                              icon: FlutterSwitch(
                                padding: 2,
                                width: 52.0.w,
                                height: 32.0.h,
                                activeColor: Theme.of(context).primaryColor,
                                inactiveColor: Theme.of(context).colorScheme.iconSubColor,
                                toggleSize: 28.0.w,
                                value: ref.watch(mainProvider).isBioAuth,
                                borderRadius: 50.0.w,
                                onToggle: (val) async {
                                  if (!val) {
                                    ref.read(mainProvider.notifier).disableBioAuth();
                                  } else {
                                    if (await ref.read(passwordProvider.notifier).authenticateWithBiometrics(
                                          isAuthenticateToggle: true,
                                          context: context,
                                        )) {
                                      ref.read(mainProvider.notifier).enableBioAuth();
                                    }
                                  }
                                },
                              ),
                              title: '생체인증 잠금',
                              titleColor: Theme.of(context).colorScheme.textTitle,
                              onPressed: null,
                            );
                          }),
                        ],
                      )
                    else
                      Container(),
                    Divider(
                      thickness: 1.h,
                      height: 1.h,
                      color: Theme.of(context).colorScheme.border,
                    ),
                    Consumer(builder: (context, ref, child) {
                      return ProfileButton(
                        icon: SvgPicture.asset(
                          "lib/config/assets/images/profile/navigate_next.svg",
                          color: Theme.of(context).colorScheme.iconSubColor,
                        ),
                        title: '비밀번호 변경',
                        titleColor: Theme.of(context).colorScheme.textTitle,
                        onPressed: () {
                          if (ref.watch(mainProvider).password != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PasswordChangeScreen(),
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
            ],
          ),
        ),
      ),
    );
  }
}

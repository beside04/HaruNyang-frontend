import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/domains/home/provider/home_provider.dart';
import 'package:frontend/domains/on_boarding/provider/on_boarding_provider.dart';
import 'package:frontend/ui/components/toast.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    print("AAAKMAKAMKAMKAMAKAMK");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      args == null ? ref.watch(homeProvider.notifier).setSelectedIndex(0) : ref.watch(homeProvider.notifier).setSelectedIndex(args['index']);

      ref.watch(onBoardingProvider).age == '' || ref.watch(onBoardingProvider).age == null ? null : await ref.watch(homeProvider.notifier).goToBirthPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool backResult = GlobalUtils.onBackPressed();
        return await Future.value(backResult);
      },
      child: Consumer(builder: (context, ref, child) {
        return Scaffold(
          bottomNavigationBar: ref.watch(homeProvider).selectedIndex == 1
              ? null
              : MediaQuery(
                  data: MediaQueryData(padding: EdgeInsets.only(bottom: 0.h)),
                  child: Container(
                    padding: Platform.isAndroid ? EdgeInsets.only(bottom: 0.h) : EdgeInsets.only(bottom: 30.h),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.border,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: BottomNavigationBar(
                      elevation: 0,
                      items: [
                        BottomNavigationBarItem(
                          icon: ref.watch(homeProvider).selectedIndex == 0
                              ? Theme.of(context).colorScheme.brightness == Brightness.dark
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/tap_emotion_stamp.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/tap_emotion_stamp.svg",
                                    )
                              : Theme.of(context).colorScheme.brightness == Brightness.dark
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/emotion_stamp.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/emotion_stamp.svg",
                                    ),
                          label: '감정캘린더',
                        ),
                        BottomNavigationBarItem(
                          icon: ref.watch(homeProvider).selectedIndex == 1
                              ? Theme.of(context).colorScheme.brightness == Brightness.dark
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/tap_pen.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/tap_pen.svg",
                                    )
                              : Theme.of(context).colorScheme.brightness == Brightness.dark
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/pen.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/pen.svg",
                                    ),
                          label: '일기쓰기',
                        ),
                        BottomNavigationBarItem(
                          icon: ref.watch(homeProvider).selectedIndex == 2
                              ? Theme.of(context).colorScheme.brightness == Brightness.dark
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/tap_profile.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/tap_profile.svg",
                                    )
                              : Theme.of(context).colorScheme.brightness == Brightness.dark
                                  ? SvgPicture.asset(
                                      "lib/config/assets/images/home/dark_mode/profile.svg",
                                    )
                                  : SvgPicture.asset(
                                      "lib/config/assets/images/home/light_mode/profile.svg",
                                    ),
                          label: '마이',
                        ),
                      ],
                      currentIndex: ref.watch(homeProvider).selectedIndex,
                      onTap: (index) async {
                        final DiarySate diarySate = await ref.watch(homeProvider.notifier).onItemTapped(index);

                        print(diarySate);

                        if (diarySate == DiarySate.alreadySaved) {
                          // ignore: use_build_context_synchronously
                          toast(
                            context: context,
                            text: '오늘 날짜에 임시 저장된 일기가 있어요',
                            isCheckIcon: false,
                          );
                        }

                        if (diarySate == DiarySate.writtenToday) {
                          // ignore: use_build_context_synchronously
                          toast(
                            context: context,
                            text: '오늘 날짜에 이미 일기를 작성했어요',
                            isCheckIcon: false,
                          );
                        }
                      },
                    ),
                  ),
                ),
          body: ref.watch(homeProvider.notifier).widgetList[ref.watch(homeProvider).selectedIndex],
        );
      }),
    );
  }
}

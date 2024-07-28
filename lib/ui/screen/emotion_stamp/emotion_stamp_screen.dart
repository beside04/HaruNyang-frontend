import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/providers/diary/provider/diary_provider.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/ui/screen/emotion_stamp/components/emotion_calendar_widget.dart';
import 'package:frontend/ui/screen/emotion_stamp/components/emotion_list_widget.dart';
import 'package:frontend/utils/library/date_time_spinner/base_picker_model.dart';
import 'package:frontend/utils/library/date_time_spinner/date_picker_theme.dart' as picker_theme;
import 'package:frontend/utils/library/date_time_spinner/date_time_spinner.dart';
import 'package:frontend/utils/library/date_time_spinner/i18n_model.dart';
import 'package:frontend/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class YearMonthModel extends DatePickerModel {
  YearMonthModel({required DateTime currentTime, required DateTime maxTime, required DateTime minTime, required LocaleType locale})
      : super(currentTime: currentTime, maxTime: maxTime, minTime: minTime, locale: locale);

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }
}

class EmotionStampScreen extends ConsumerStatefulWidget {
  const EmotionStampScreen({super.key});

  @override
  EmotionStampScreenState createState() => EmotionStampScreenState();
}

class EmotionStampScreenState extends ConsumerState<EmotionStampScreen> {
  @override
  Widget build(BuildContext context) {
    TargetPlatform os = Theme.of(context).platform;

    BannerAd banner = BannerAd(
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {},
        onAdLoaded: (_) {},
      ),
      size: AdSize.banner,
      adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
      request: const AdRequest(),
    )..load();

    return DefaultLayout(
      screenName: 'Screen_Event_Main_EmotionCalendar',
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            Consumer(builder: (context, ref, child) {
              return IconButton(
                onPressed: () {
                  ref.watch(diaryProvider.notifier).toggleCalendarMode();
                },
                icon: ref.watch(diaryProvider).isCalendar
                    ? SvgPicture.asset(
                        "lib/config/assets/images/diary/dark_mode/list.svg",
                        color: Theme.of(context).colorScheme.iconColor,
                      )
                    : SvgPicture.asset(
                        "lib/config/assets/images/diary/dark_mode/calendar.svg",
                        color: Theme.of(context).colorScheme.iconColor,
                      ),
              );
            }),
          ],
          title: Consumer(builder: (context, ref, child) {
            return InkWell(
              onTap: () {
                GlobalUtils.setAnalyticsCustomEvent('Click_Change_Month');
                DatePicker.showPicker(
                  context,
                  pickerModel: YearMonthModel(
                    currentTime: ref.watch(diaryProvider).focusedCalendarDate,
                    maxTime: DateTime.now(),
                    minTime: DateTime(2000, 1),
                    locale: LocaleType.ko,
                  ),
                  showTitleActions: true,
                  onConfirm: (date) {
                    ref.watch(diaryProvider.notifier).onPageChanged(date);
                  },
                  locale: LocaleType.ko,
                  theme: picker_theme.DatePickerTheme(
                    itemStyle: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                    backgroundColor: Theme.of(context).colorScheme.backgroundModal,
                    title: "다른 날짜 일기 보기",
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('yyyy년 M월').format(ref.watch(diaryProvider).focusedCalendarDate),
                      style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Image.asset(
                      "lib/config/assets/images/home/dark_mode/system-arrow.png",
                      width: 24,
                      height: 24,
                      color: Theme.of(context).colorScheme.iconColor,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  return PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 300),
                    reverse: !ref.watch(diaryProvider).isCalendar,
                    transitionBuilder: (Widget child, Animation<double> animation, Animation<double> secondaryAnimation) {
                      return SharedAxisTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.horizontal,
                        child: child,
                      );
                    },
                    child: ref.watch(diaryProvider).isCalendarLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ref.watch(diaryProvider).isCalendar
                            ? const EmotionCalendarWidget()
                            : const EmotionListWidget(),
                  );
                }),
              ),
              isBannerOpen
                  ?
                  // Padding(
                  //         padding: const EdgeInsets.all(20.0),
                  //         child: Container(
                  //           width: double.infinity,
                  //           height: 96,
                  //           decoration: BoxDecoration(
                  //             color: Theme.of(context).colorScheme.brightness == Brightness.dark ? Color(0xffF4D3B3) : Color(0xffffe9d5),
                  //             borderRadius: BorderRadius.all(
                  //               Radius.circular(16),
                  //             ),
                  //           ),
                  //           child: GestureDetector(
                  //             onTap: () async {
                  //               GlobalUtils.setAnalyticsCustomEvent('Click_Banner');
                  //               if (!await launch(bannerUrl)) {
                  //                 throw Exception('Could not launch');
                  //               }
                  //             },
                  //             child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(
                  //                     left: 24.0,
                  //                     top: 20,
                  //                   ),
                  //                   child: Column(
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       Text(
                  //                         "하루냥 사용자 단체 인터뷰 모집",
                  //                         style: TextStyle(
                  //                           fontFamily: pretendard,
                  //                           fontSize: 12,
                  //                           fontWeight: FontWeight.w600,
                  //                         ).copyWith(color: kGrayColor550),
                  //                       ),
                  //                       SizedBox(
                  //                         height: 2,
                  //                       ),
                  //                       Text(
                  //                         "하루냥 개발 크루를 만나고\n의견을 말해주세요!",
                  //                         style: kHeader5Style.copyWith(color: kBlackColor),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(
                  //                     right: 28.0,
                  //                   ),
                  //                   child: Image.asset(
                  //                     "lib/config/assets/images/character/character11.png",
                  //                     height: 74,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 96,
                        child: GestureDetector(
                          onTap: () async {
                            GlobalUtils.setAnalyticsCustomEvent('Click_Default_Banner');
                            // if (!await launch(bannerUrl)) {
                            if (!await launch("https://www.instagram.com/haru__nyang__/")) {
                              throw Exception('Could not launch');
                            }
                          },
                          child: Image.asset(
                            "lib/config/assets/images/home/banner/default_banner.png",
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 100,
                      child: GestureDetector(
                        onTap: () {
                          GlobalUtils.setAnalyticsCustomEvent('Click_AD');
                        },
                        child: AdWidget(
                          ad: banner,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

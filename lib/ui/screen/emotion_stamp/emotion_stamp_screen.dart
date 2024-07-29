import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  late BannerAd _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBannerAd();
    });
  }

  void _loadBannerAd() {
    TargetPlatform os = Theme.of(context).platform;
    _bannerAd = BannerAd(
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
      ),
      size: AdSize.banner,
      adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
      request: const AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerList = ref.watch(diaryProvider).bannerList;

    List<Widget> carouselItems = bannerList.isEmpty
        ? [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: double.infinity,
                height: 96,
                child: GestureDetector(
                  onTap: () async {
                    GlobalUtils.setAnalyticsCustomEvent('Click_Default_Banner');
                    if (!await launch("https://www.instagram.com/haru__nyang__/")) {
                      throw Exception('Could not launch');
                    }
                  },
                  child: Image.asset(
                    "lib/config/assets/images/home/banner/default_banner.png",
                  ),
                ),
              ),
            ),
          ]
        : bannerList.map((banner) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 96,
                    child: GestureDetector(
                      onTap: () async {
                        GlobalUtils.setAnalyticsCustomEvent('Click_Default_Banner');
                        if (!await launch(banner.landingUrl)) {
                          throw Exception('Could not launch');
                        }
                      },
                      child: Image.network(
                        banner.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList();

    if (_isBannerAdLoaded) {
      carouselItems.add(
        Builder(
          builder: (BuildContext context) {
            return SizedBox(
              width: double.infinity,
              height: 96,
              child: GestureDetector(
                onTap: () {
                  GlobalUtils.setAnalyticsCustomEvent('Click_AD');
                },
                child: AdWidget(ad: _bannerAd),
              ),
            );
          },
        ),
      );
    }

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
              CarouselSlider(
                options: CarouselOptions(
                  height: 100,
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: carouselItems,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

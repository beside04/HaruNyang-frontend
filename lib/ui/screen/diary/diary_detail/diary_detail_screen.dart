import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/core/utils/letter_paper_painter.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/domains/diary/provider/diary_provider.dart';
import 'package:frontend/domains/font/provider/font_provider.dart';
import 'package:frontend/main.dart';
import 'package:frontend/res/constants.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/ui/components/dialog_button.dart';
import 'package:frontend/ui/components/dialog_component.dart';
import 'package:frontend/ui/components/weather_emotion_badge_writing_diary.dart';
import 'package:frontend/ui/screen/diary/components/diary_popup_menu_item.dart';
import 'package:frontend/ui/screen/diary/diary_detail/diary_result_screen.dart';
import 'package:frontend/ui/screen/diary/write_diary_screen.dart';
import 'package:frontend/ui/screen/home/home_screen.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' as rive;

class DiaryDetailScreen extends ConsumerStatefulWidget {
  final int diaryId;
  final DateTime date;
  final CroppedFile? imageFile;
  final bool isNewDiary;

  final bool isFromBookmarkPage;

  const DiaryDetailScreen({
    Key? key,
    required this.diaryId,
    required this.date,
    required this.isNewDiary,
    this.imageFile,
    required this.isFromBookmarkPage,
  }) : super(key: key);

  @override
  DiaryDetailScreenState createState() => DiaryDetailScreenState();
}

class DiaryDetailScreenState extends ConsumerState<DiaryDetailScreen> {
  Future<DiaryDetailData?>? _diaryDataFuture;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _diaryDataFuture = _fetchDiaryDataData();

      init();
    });
    super.initState();
  }

  init() async {
    ref.watch(diaryProvider.notifier).setIsNote(true);

    widget.isNewDiary
        // ignore: use_build_context_synchronously
        ? await Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => DiaryResultScreen(),
            ),
          )
        : null;
  }

  Future<DiaryDetailData?> _fetchDiaryDataData() async {
    try {
      return await ref.watch(diaryProvider.notifier).getDiaryDetail(widget.diaryId);
    } catch (e) {
      print("e ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var fontNotifier = ref.watch(fontProvider.notifier);
    return DefaultLayout(
      screenName: 'Screen_Event_DiaryRead',
      child: WillPopScope(
        onWillPop: () async {
          widget.isFromBookmarkPage ? Navigator.of(context).pop() : Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);

          ref.watch(diaryProvider.notifier).resetDiary();
          return false;
        },
        child: Consumer(builder: (context, ref, _) {
          final diaryDetailData = ref.watch(diaryProvider);
          return FutureBuilder(
              future: _diaryDataFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('error');
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Lottie.asset(
                      'lib/config/assets/lottie/loading_haru.json',
                      fit: BoxFit.fill,
                    ),
                  );
                }

                final DiaryDetailData data = snapshot.data!;

                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      DateFormat('M월 d일').format(widget.date),
                      style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                    ),
                    leading: IconButton(
                      onPressed: () {
                        widget.isFromBookmarkPage
                            ? Navigator.of(context).pop()
                            : Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);

                        ref.watch(diaryProvider.notifier).resetDiary();
                      },
                      icon: SvgPicture.asset(
                        "lib/config/assets/images/diary/dark_mode/close.svg",
                        color: Theme.of(context).colorScheme.iconColor,
                      ),
                    ),
                    centerTitle: true,
                    elevation: 0,
                    actions: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerTheme: DividerThemeData(
                            color: Theme.of(context).colorScheme.border,
                          ),
                        ),
                        child: PopupMenuButton(
                          icon: SvgPicture.asset(
                            "lib/config/assets/images/diary/dark_mode/kebab.svg",
                            color: Theme.of(context).colorScheme.iconColor,
                          ),
                          onSelected: (id) {
                            if (id == 'edit') {
                              GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Update');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WriteDiaryScreen(
                                    date: widget.date,
                                    emotion: data.feeling,
                                    diaryData: data.id == null ? null : data,
                                    weather: data.weather,
                                    isEditScreen: true,
                                    isAutoSave: false,
                                  ),
                                ),
                              );
                            }
                            if (id == 'delete') {
                              GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Delete');
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return DialogComponent(
                                    title: "삭제 하실래요?",
                                    content: Text(
                                      "삭제 후 일기를 복원 할 수 없어요",
                                      style: kHeader6Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                    ),
                                    actionContent: [
                                      DialogButton(
                                        title: "아니요",
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                                        textStyle: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                      ),
                                      SizedBox(
                                        width: 12.w,
                                      ),
                                      DialogButton(
                                        title: "예",
                                        onTap: () async {
                                          Navigator.pop(context);

                                          await ref.watch(diaryProvider.notifier).deleteDiary(data.id!);

                                          await showDialog(
                                            barrierDismissible: false,
                                            context: navigatorKey.currentContext!,
                                            builder: (ctx) {
                                              return WillPopScope(
                                                onWillPop: () async => false,
                                                child: DialogComponent(
                                                  title: "삭제 완료",
                                                  content: Text(
                                                    "일기를 삭제했어요.",
                                                    style: kHeader6Style.copyWith(color: Theme.of(ctx).colorScheme.textSubtitle),
                                                  ),
                                                  actionContent: [
                                                    DialogButton(
                                                      title: "확인",
                                                      onTap: () {
                                                        navigatorKey.currentState!.pop();
                                                        navigatorKey.currentState!.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);

                                                        ref.watch(diaryProvider.notifier).resetDiary();
                                                      },
                                                      backgroundColor: kOrange200Color,
                                                      textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        backgroundColor: kOrange200Color,
                                        textStyle: kHeader4Style.copyWith(color: kWhiteColor),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          offset: Offset(0.0, AppBar().preferredSize.height),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16.0),
                              bottomRight: Radius.circular(16.0),
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),
                          itemBuilder: (context) {
                            final list = <PopupMenuEntry>[];
                            list.add(
                              diaryPopUpMenuItem(
                                'edit',
                                '일기 수정',
                                context,
                                SvgPicture.asset(
                                  "lib/config/assets/images/diary/dark_mode/edit.svg",
                                  color: Theme.of(context).colorScheme.iconColor,
                                ),
                              ),
                            );
                            list.add(
                              const PopupMenuDivider(
                                height: 10,
                              ),
                            );
                            list.add(
                              diaryPopUpMenuItem(
                                'delete',
                                '일기 삭제',
                                context,
                                SvgPicture.asset(
                                  "lib/config/assets/images/diary/dark_mode/trash.svg",
                                  color: Theme.of(context).colorScheme.iconColor,
                                ),
                              ),
                            );
                            return list;
                          },
                        ),
                      ),
                    ],
                  ),
                  body: Stack(
                    children: [
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: SafeArea(
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  children: [
                                    SizedBox(
                                      height: 164,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Image.asset(
                                              getWeatherCharacter(data.weather),
                                              height: 140,
                                            ),
                                          ),
                                          getWeatherAnimation(data.weather) == ""
                                              ? Container()
                                              : rive.RiveAnimation.asset(
                                                  getWeatherAnimation(data.weather),
                                                  fit: BoxFit.fill,
                                                ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20.0),
                                        child: Container(
                                          color: Theme.of(context).colorScheme.surface_01,
                                          child: Stack(
                                            children: [
                                              Align(
                                                alignment: Alignment.center,
                                                child: SizedBox(
                                                  height: 72.0,
                                                  child: WeatherEmotionBadgeWritingDiary(
                                                    emoticon: getEmoticonImage(data.feeling),
                                                    emoticonDesc: getEmoticonValue(data.feeling),
                                                    weatherIcon: getWeatherChipImage(data.weather),
                                                    weatherIconDesc: getWeatherValue(data.weather),
                                                    color: Theme.of(context).colorScheme.letterBackgroundLineColor,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 70,
                                                child: Consumer(builder: (context, ref, child) {
                                                  return ref.watch(diaryProvider).diaryDetailData?.image == '' || ref.watch(diaryProvider).diaryDetailData == null
                                                      ? Container()
                                                      : Center(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  color: kImageBackgroundColor,
                                                                  width: MediaQuery.of(context).size.width - 100,
                                                                  height: MediaQuery.of(context).size.width - 100,
                                                                  child: Image.network(
                                                                    "${ref.watch(diaryProvider).diaryDetailData?.image}",
                                                                    width: MediaQuery.of(context).size.width - 100,
                                                                    height: MediaQuery.of(context).size.width - 100,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                }),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: ref.watch(diaryProvider).diaryDetailData?.image == '' || ref.watch(diaryProvider).diaryDetailData == null ? 70 : 350, left: 30, right: 30),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                    minHeight: 500,
                                                    minWidth: MediaQuery.of(context).size.width,
                                                  ),
                                                  child: CustomPaint(
                                                    painter: LetterPaperPainter(
                                                      color: Theme.of(context).colorScheme.letterBackgroundLineColor,
                                                    ),
                                                    child: Text(
                                                      data.diaryContent,
                                                      style: fontNotifier.getFontStyle().copyWith(
                                                            color: Theme.of(context).colorScheme.textBody,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom), // 아이폰 같은 경우에는 하단에 safe area가 있기 때문에 추가
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).colorScheme.whiteBlackColor.withOpacity(0),
                                Theme.of(context).colorScheme.whiteBlackColor.withOpacity(1),
                              ],
                            ),
                          ),
                          child: BottomButton(
                            title: "하루냥 편지 보기",
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => DiaryResultScreen(),
                                ),
                              );
                            },
                            bottomPadding: 16,
                            buttonWidth: 160,
                            buttonHeight: 48,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        }),
      ),
    );
  }
}

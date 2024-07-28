import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/providers/diary/provider/diary_provider.dart';
import 'package:frontend/providers/font/provider/font_provider.dart';
import 'package:frontend/ui/components/toast.dart';
import 'package:frontend/ui/layout/default_layout.dart';
import 'package:frontend/utils/letter_paper_painter.dart';
import 'package:frontend/utils/utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class DiaryResultScreen extends ConsumerStatefulWidget {
  const DiaryResultScreen({super.key});

  @override
  DiaryResultScreenState createState() => DiaryResultScreenState();
}

class DiaryResultScreenState extends ConsumerState<DiaryResultScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    var fontNotifier = ref.watch(fontProvider.notifier);
    return DefaultLayout(
      screenName: 'Screen_Event_DiaryRead_HaruNyangReply',
      child: Scaffold(
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0, top: 28.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
                      if (image != null) {
                        final directory = await getApplicationDocumentsDirectory();
                        final imagePath = await File('${directory.path}/image.png').create();
                        await imagePath.writeAsBytes(image);

                        final result = await Share.shareXFiles([XFile(imagePath.path)], text: '하루냥 편지');

                        GlobalUtils.setAnalyticsCustomEvent('Click_Share_Button');

                        if (result.status == ShareResultStatus.success) {
                          toast(
                            context: context,
                            text: '이미지 공유를 성공했습니다!',
                            isCheckIcon: true,
                          );
                        }
                      }
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Theme.of(context).colorScheme.secondaryColor,
                    ),
                    child: Center(
                      child: Text(
                        "공유하기",
                        style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () async {
                    await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
                      if (image != null) {
                        final directory = await getApplicationDocumentsDirectory();
                        final imagePath = await File('${directory.path}/image.png').create();
                        await imagePath.writeAsBytes(image);

                        final result = await ImageGallerySaver.saveFile(imagePath.path, name: "하루냥");

                        GlobalUtils.setAnalyticsCustomEvent('Click_Save_Image');

                        result["isSuccess"]
                            ? toast(
                                context: context,
                                text: '이미지가 저장되었습니다!',
                                isCheckIcon: true,
                              )
                            : toast(
                                context: context,
                                text: '이미지 저장을 실패했습니다.',
                                isCheckIcon: false,
                              );
                      }
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: Theme.of(context).colorScheme.secondaryColor,
                    ),
                    child: Center(
                      child: Text(
                        "이미지 저장",
                        style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            "하루냥의 편지",
            style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
          ),
          leading: IconButton(
            onPressed: () {
              GlobalUtils.setAnalyticsCustomEvent('Click_Diary_Letter_Close_Icon');
              Navigator.of(context).pop();
            },
            icon: SvgPicture.asset(
              "lib/config/assets/images/diary/dark_mode/close.svg",
              color: Theme.of(context).colorScheme.iconColor,
              width: 24,
              height: 24,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Consumer(
                builder: (context, ref, child) {
                  return ref.watch(diaryProvider).diaryDetailData!.comments![0].isFavorite
                      ? InkWell(
                          onTap: () {
                            GlobalUtils.setAnalyticsCustomEvent('Click_Delete_BookMark');
                            ref.watch(diaryProvider.notifier).deleteBookmarkByBookmarkId(
                                  ref.watch(diaryProvider).diaryDetailData!.comments![0].id!,
                                  0,
                                );
                            toast(
                              context: context,
                              text: '편지 보관함에서 편지를 삭제했어요.',
                              isCheckIcon: true,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              "lib/config/assets/images/diary/write_diary/bookmark_check.svg",
                              width: 18,
                              height: 18,
                              color: kOrange250Color,
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            GlobalUtils.setAnalyticsCustomEvent('Click_Save_BookMark');
                            ref.watch(diaryProvider.notifier).saveBookmark(
                                  ref.watch(diaryProvider).diaryDetailData!.comments![0].id!,
                                  0,
                                );
                            toast(
                              context: context,
                              text: '편지 보관함에 편지를 보관했어요.',
                              isCheckIcon: true,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              "lib/config/assets/images/diary/write_diary/bookmark.svg",
                              width: 18,
                              height: 18,
                              color: kOrange250Color,
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
        body: Screenshot(
          controller: screenshotController,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                color: ref.watch(diaryProvider).diaryDetailData!.comments![0].author == "harunyang"
                    ? getLetterModalColor(ref.watch(diaryProvider).diaryDetailData!.feeling, context)
                    : Theme.of(context).colorScheme.wiseSayingModalColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(
                        10,
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 37.0,
                              right: 37,
                              top: 18,
                            ),
                            child: Image.asset(
                              ref.watch(diaryProvider).diaryDetailData!.comments![0].author == "harunyang"
                                  ? getLetterModalImage(ref.watch(diaryProvider).diaryDetailData!.feeling)
                                  : 'lib/config/assets/images/character/letter/wise_saying.png',
                              height: 140,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 15.0, bottom: 20),
                        child: RawScrollbar(
                          thickness: 6,
                          thumbColor: kWhiteColor.withOpacity(0.6),
                          radius: const Radius.circular(10.0),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15.0),
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                CustomPaint(
                                  painter: LetterPaperPainter(
                                    color: kWhiteColor,
                                    lineCount: 7,
                                  ),
                                  child: Text(
                                    ref.watch(diaryProvider).diaryDetailData!.comments![0].message,
                                    style: fontNotifier.getFontStyle().copyWith(
                                          color: kGrayColor850,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: ref.watch(diaryProvider).diaryDetailData!.comments![0].author == "harunyang"
                          ? getLetterModalColor(ref.watch(diaryProvider).diaryDetailData!.feeling, context)
                          : Theme.of(context).colorScheme.wiseSayingModalColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 24.0,
                              bottom: 30,
                            ),
                            child: ref.watch(diaryProvider).diaryDetailData!.comments![0].author == "harunyang"
                                ? Text(
                                    'From. 하루냥',
                                    style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                  )
                                : Text(
                                    "From. ${ref.watch(diaryProvider).diaryDetailData!.comments![0].author}",
                                    style: kSubtitle1Style.copyWith(color: Theme.of(context).colorScheme.textSubtitle),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/domains/font/model/font_state.dart';
import 'package:frontend/domains/font/provider/font_provider.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/components/round_radio_checkbox.dart';
import 'package:frontend/ui/screen/profile/font_change/components/font_size_checkbox.dart';

class FontChangeScreen extends ConsumerStatefulWidget {
  const FontChangeScreen({super.key});

  @override
  ConsumerState<FontChangeScreen> createState() => _FontChangeScreenState();
}

class _FontChangeScreenState extends ConsumerState<FontChangeScreen> {
  @override
  Widget build(BuildContext context) {
    final fontState = ref.watch(fontProvider);
    final fontNotifier = ref.watch(fontProvider.notifier);

    final List<Font> fontList = [
      Font(
        title: '시스템 폰트(Pretendard)',
        value: 'pretendard',
        size: 16,
        height: 2.1,
      ),
      Font(
        title: '따악단단',
        value: 'nanum_ddaacdandan',
        size: 20,
        height: 1.7,
      ),
      Font(
        title: '마루부리',
        value: 'maruburi',
        size: 16,
        height: 2.1,
      ),
      Font(
        title: '이서윤체',
        value: 'leeSeoyun',
        size: 16,
        height: 2.1,
      ),
      Font(
        title: '중학생',
        value: 'nanum_junghacsang',
        size: 20,
        height: 1.7,
      ),
      Font(
        title: '비상체',
        value: 'nanum_bisang',
        size: 20,
        height: 1.7,
      ),
    ];

    return DefaultLayout(
      screenName: 'Screen_Event_Profile_FontChange',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '폰트 변경',
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
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                color: Theme.of(context).colorScheme.surface_01,
                child: Center(
                  child: Text(
                    '하루를 위로해주는 \n모바일 속 작은 내 친구',
                    style: fontNotifier.getFontStyle().copyWith(
                          height: 1.2,
                          color: Theme.of(context).colorScheme.textBody,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Text(
                  '폰트 크기',
                  style: kHeader4Style.copyWith(
                    color: Theme.of(context).colorScheme.textTitle,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                            child: Divider(
                              thickness: 2.h,
                              height: 2.h,
                              color: Theme.of(context).colorScheme.border,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FontSizeCheckBox(
                                label: '작게',
                                isSelected:
                                    fontState.changedFontSize == fontState.selectedFontDefaultSize - 2 ? true : false,
                                onPressed: fontNotifier.handleDownFontSize,
                              ),
                              FontSizeCheckBox(
                                label: '기본',
                                isSelected:
                                    fontState.selectedFontDefaultSize == fontState.changedFontSize ? true : false,
                                onPressed: fontNotifier.handleSetDefaultFontSize,
                              ),
                              FontSizeCheckBox(
                                label: '크게',
                                isSelected:
                                    fontState.changedFontSize == fontState.selectedFontDefaultSize + 2 ? true : false,
                                onPressed: fontNotifier.handleUpFontSize,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1.h,
                height: 1.h,
                color: Theme.of(context).colorScheme.border,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Text(
                  '폰트 종류',
                  style: kHeader4Style.copyWith(
                    color: Theme.of(context).colorScheme.textTitle,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: fontList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return GestureDetector(
                      onTap: () => fontNotifier.handleChangeFont(fontList[i]),
                      behavior: HitTestBehavior.translucent,
                      child: SizedBox(
                        height: 56,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 17,
                            horizontal: 24,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                fontList[i].title,
                                style: kHeader6Style.copyWith(
                                  color: fontState.selectedFontValue == fontList[i].value
                                      ? Theme.of(context).colorScheme.textPrimary
                                      : Theme.of(context).colorScheme.textLowEmphasis,
                                ),
                              ),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: RoundRadioCheckbox(
                                  isSelected: fontState.selectedFontValue == fontList[i].value ? true : false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

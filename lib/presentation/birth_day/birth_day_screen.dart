import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/components/bottom_button.dart';
import 'package:frontend/presentation/home/home_view_model.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class BirthDayScreen extends StatelessWidget {
  String name;

  BirthDayScreen({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Birth_Day',
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 12.h,
                    ),
                    Padding(
                      padding: kPrimarySidePadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 24.h,
                          ),
                          Text(
                            "$name님",
                            style: kHeader1Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
                          ),
                          Text(
                            '생일을 축하해요!',
                            style: kHeader1Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                "lib/config/assets/images/character/birthday.png",
                                width: 264.w,
                              ),
                            ),
                          ),
                          Text(
                            '남들에겐 그저 흘러갈 수 있는 날일 수도 있지만 \n오늘은 그 무엇보다도 특별한 날이에요.\n$name님이 태어났기에\n우리가 만날 수 있었으니까요.',
                            style: kBody1Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            '$name님이 써 주신 일기에 명언을 건네며\n저도 행복한 시간을 보낼 수 있었어요.\n오늘 행복한 하루 되시고 앞으로도 계속 만나요 우리!',
                            style: kBody1Style.copyWith(
                                color: Theme.of(context).colorScheme.textTitle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BottomButton(
                    title: '확인',
                    bottomPadding: 13,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 37,
                      ),
                      child: InkWell(
                        onTap: () async {
                          Get.back();
                          String time = DateTime.now().toIso8601String();
                          Get.find<HomeViewModel>().isBirthDayPopup.value =
                              true;
                          await popUpUseCase.setLastBirthDayPopUpDate(time);
                        },
                        child: Text(
                          "오늘 하루 그만 볼래요",
                          style: kBody1Style.copyWith(
                              color:
                                  Theme.of(context).colorScheme.textSubtitle),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

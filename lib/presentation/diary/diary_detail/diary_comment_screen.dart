import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/size_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/domain/model/diary/diary_data.dart';
import 'package:frontend/domain/model/diary/diary_detail_data.dart';
import 'package:frontend/global_controller/diary/diary_controller.dart';
import 'package:frontend/main.dart';
import 'package:frontend/presentation/components/back_icon.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/components/weather_emotion_badge_writing_diary.dart';
import 'package:frontend/presentation/diary/components/diary_loading_widget.dart';
import 'package:frontend/presentation/diary/components/diary_popup_menu_item.dart';
import 'package:frontend/presentation/diary/write_diary_screen.dart';
import 'package:frontend/presentation/diary/write_diary_screen_test.dart';
import 'package:frontend/presentation/diary/write_diary_view_model.dart';
import 'package:frontend/presentation/home/home_screen.dart';
import 'package:frontend/res/constants.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

class DiaryCommentScreen extends StatelessWidget {
  final DateTime date;
  final DiaryDetailData diaryDetailData;

  const DiaryCommentScreen({
    Key? key,
    required this.date,
    required this.diaryDetailData,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_DiaryRead',
      child: WillPopScope(
        onWillPop: () async {
          Get.offAll(
            () => const HomeScreen(),
            binding: BindingsBuilder(
              getHomeViewModelBinding,
            ),
          );
          return false;
        },
        child: Scaffold(
          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: Column(
                children: [
                  Image.asset(
                    "lib/config/assets/images/character/write_character.png",
                    height: 200.h,
                    width: 200.h,
                  ),
                  Text("${diaryDetailData.comments[0].message}"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

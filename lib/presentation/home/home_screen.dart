import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/diary/diary_screen.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_screen.dart';
import 'package:frontend/presentation/home/home_view_model.dart';
import 'package:frontend/presentation/profile/profile_screen.dart';
import 'package:get/get.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getHomeViewModelBinding();
    Get.find<HomeViewModel>().getMyInformation();

    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> widgetList = const [
    EmotionStampScreen(),
    DiaryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool backResult = GlobalUtils.onBackPressed();
        return await Future.value(backResult);
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: SvgPicture.asset(
                      "lib/config/assets/images/home/light_mode/emotion_stamp.svg",
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
              label: '감정캘린더',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: SvgPicture.asset(
                      "lib/config/assets/images/home/light_mode/pen.svg",
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
              label: '일기쓰기',
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: SvgPicture.asset(
                      "lib/config/assets/images/home/light_mode/profile.svg",
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
              label: '프로필',
            ),
          ],
          selectedLabelStyle: kBody4BlackStyle,
          unselectedLabelStyle: kBody4BlackStyle,
          currentIndex: _selectedIndex,
          unselectedItemColor: kBlackColor,
          selectedItemColor: kBlackColor,
          onTap: _onItemTapped,
        ),
        body: widgetList[_selectedIndex],
      ),
    );
  }
}

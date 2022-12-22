import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/diary/diary_detail/diary_detail_screen.dart';
import 'package:frontend/presentation/diary/diary_screen.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_screen.dart';
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

    super.initState();

    // 탭의 위치로 이동하는 코드
    if (Get.arguments == null) {
      _selectedIndex = 0;
    } else if (Get.arguments['index'] != null) {
      _selectedIndex = Get.arguments['index'];
    } else if (Get.arguments['diaryData'] != null) {
      _selectedIndex = 0;
      final date = Get.arguments['date'];
      final isStamp = Get.arguments['isStamp'];
      final diaryData = Get.arguments['diaryData'];
      final imageFile = Get.arguments['imageFile'];
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async {
          bool result = await Get.to(
            () => DiaryDetailScreen(
              date: date,
              isStamp: isStamp,
              diaryData: diaryData,
              imageFile: imageFile,
            ),
          );
          _onItemTapped(0);
          print(result);
        },
      );
    }
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
          selectedLabelStyle: kBody2BlackStyle,
          unselectedLabelStyle: kBody2BlackStyle,
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

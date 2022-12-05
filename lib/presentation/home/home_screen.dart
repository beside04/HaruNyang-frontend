import 'package:flutter/material.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/presentation/diary/diary_screen.dart';
import 'package:frontend/presentation/emotion_stamp/emotion_stamp_screen.dart';
import 'package:frontend/presentation/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> widgetList = const [
    DiaryScreen(),
    EmotionStampScreen(),
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              label: '다이어리',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_emotions),
              label: '감정 스탬프',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '프로필',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.black26,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
        body: widgetList[_selectedIndex],
      ),
    );
  }
}

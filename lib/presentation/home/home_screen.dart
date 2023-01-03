import 'package:flutter/material.dart';
import 'package:frontend/config/assets/font/customIcons/my_flutter_app_icons.dart';
import 'package:frontend/core/utils/utils.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/components/dialog_button.dart';
import 'package:frontend/presentation/components/dialog_component.dart';
import 'package:frontend/presentation/home/home_view_model.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel controller;

  @override
  void initState() {
    Get.delete<HomeViewModel>();
    controller = getHomeViewModelBinding();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool backResult = GlobalUtils.onBackPressed();
        return await Future.value(backResult);
      },
      child: Obx(
        () => Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  CustomIcons.emotionStamp,
                  size: 20,
                ),
                label: '감정캘린더',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CustomIcons.pen,
                  size: 20,
                ),
                label: '일기쓰기',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  CustomIcons.profile,
                  size: 20,
                ),
                label: '프로필',
              ),
            ],
            currentIndex: controller.selectedIndex.value,
            onTap: (index) async {
              final result = await controller.onItemTapped(index);
              if (!result) {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return DialogComponent(
                      title: "알림",
                      content: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          "일기는 하루에 한번만 작성 할 수 있어요.",
                          style: Theme.of(context).textTheme.headline6!,
                        ),
                      ),
                      actionContent: [
                        DialogButton(
                          title: "확인",
                          onTap: () {
                            Get.back();
                          },
                          backgroundColor: Theme.of(context).primaryColor,
                          textStyle: Theme.of(context).textTheme.headline4!,
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          body: controller.widgetList[controller.selectedIndex.value],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/color_data.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/global_controller/on_boarding/on_boarding_controller.dart';
import 'package:frontend/main_view_model.dart';
import 'package:get/get.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
    required this.titleColor,
    this.isBirth = false,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget icon;
  final String title;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final Color titleColor;
  final bool isBirth;

  @override
  Widget build(BuildContext context) {
    final mainViewController = Get.find<MainViewModel>();
    final onBoardingController = Get.find<OnBoardingController>();

    return InkWell(
      onTap: onPressed,
      child: Container(
        color: Theme.of(context).colorScheme.backgroundColor,
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Text(
                    "${title}   ",
                    style: kHeader5Style.copyWith(
                      color: titleColor,
                    ),
                  ),

                  //onBoardingController.state.value.age == null
                  // isBirth == false 두개 조건일때 아이콘 발생

                  onBoardingController.state.value.age == null &&
                          isBirth == true
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 6.0.w,
                            height: 6.0.h,
                            decoration: const BoxDecoration(
                              color: kRed300Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              onBoardingController.state.value.age == null && isBirth == true
                  ? Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryColor
                            .withOpacity(0.1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0.h, horizontal: 8.0.w),
                        child: Text(
                          "생일을 알려주시면 생일을 축하해드려요!",
                          style: kBody3Style.copyWith(
                              color:
                                  Theme.of(context).colorScheme.primaryColor),
                        ),
                      ),
                    )
                  : Container(),
              icon
            ],
          ),
        ),
      ),
    );
  }
}

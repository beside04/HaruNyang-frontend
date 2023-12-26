import 'package:flutter/material.dart';

class SwipeDetector extends StatelessWidget {
  static const double minMainDisplacement = 0;
  static const double maxCrossRatio = 10;
  static const double minVelocity = 0;

  final Widget child;

  final VoidCallback? onSwipeUp;
  final VoidCallback? onSwipeDown;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;

  const SwipeDetector({
    super.key,
    required this.child,
    this.onSwipeUp,
    this.onSwipeDown,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  Widget build(BuildContext context) {
    PointerDownEvent? panStartDetails;
    PointerMoveEvent? panUpdateDetails;

    return Listener(
      behavior: HitTestBehavior.opaque,
      child: child,
      onPointerDown: (startDetails) => panStartDetails = startDetails,
      onPointerMove: (updateDetails) => panUpdateDetails = updateDetails,
      onPointerUp: (endDetails) {
        if (panStartDetails == null || panUpdateDetails == null) return;

        double dx = panUpdateDetails!.delta.dx - panStartDetails!.delta.dx;
        double dy = panUpdateDetails!.delta.dy - panStartDetails!.delta.dy;

        int panDurationMiliseconds =
            panUpdateDetails!.timeStamp.inMilliseconds -
                panStartDetails!.timeStamp.inMilliseconds;

        double mainDis, crossDis, mainVel;
        bool isHorizontalMainAxis = dx.abs() > dy.abs();

        if (isHorizontalMainAxis) {
          mainDis = dx.abs();
          crossDis = dy.abs();
        } else {
          mainDis = dy.abs();
          crossDis = dx.abs();
        }

        mainVel = 1000 * mainDis / panDurationMiliseconds;

        if (mainDis < minMainDisplacement) {
          debugPrint(
              "SWIPE DEBUG | Displacement too short. Real: $mainDis - Min: $minMainDisplacement");
          return;
        }
        if (crossDis > maxCrossRatio * mainDis) {
          debugPrint(
              "SWIPE DEBUG | Cross axis displacemnt bigger than limit. Real: $crossDis - Limit: ${mainDis * maxCrossRatio}");
          return;
        }
        if (mainVel < minVelocity) {
          debugPrint(
              "SWIPE DEBUG | Swipe velocity too slow. Real: $mainVel - Min: $minVelocity");
          return;
        }

        // dy < 0 => UP -- dx > 0 => RIGHT
        if (isHorizontalMainAxis) {
          if (dx > 0) {
            onSwipeRight?.call();
          } else {
            onSwipeLeft?.call();
          }
        } else {
          if (dy < 0) {
            onSwipeUp?.call();
          } else {
            onSwipeDown?.call();
          }
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/core/utils/utils.dart';

  class DefaultLayout extends StatefulWidget {
  final String screenName;
  final Widget child;

  const DefaultLayout({
    Key? key,
    required this.screenName,
    required this.child,
  }) : super(key: key);

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  @override
  void initState() {
    super.initState();
    GlobalUtils.setAnalyticsCustomScreenViewEvent(widget.screenName);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

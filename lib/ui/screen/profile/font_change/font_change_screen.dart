import 'package:flutter/material.dart';
import 'package:frontend/common/layout/default_layout.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/ui/components/back_icon.dart';
import 'package:frontend/ui/screen/profile/font_change/font_select.dart';
import 'package:frontend/ui/screen/profile/font_change/font_size_change.dart';
import 'package:frontend/ui/screen/profile/font_change/font_viewer.dart';

class FontChangeScreen extends StatelessWidget {
  const FontChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      screenName: 'Screen_Event_Main_Font_Change',
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '폰트 변경',
            style: kHeader4Style.copyWith(
                color: Theme.of(context).colorScheme.textTitle),
          ),
          elevation: 0,
          leading: BackIcon(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FontViewer(),
              FontSizeChange(),
              FontSelect(),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class FontSizeChange extends StatelessWidget {
  const FontSizeChange({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '폰트 크기',
            style: kHeader4Style.copyWith(
              color: Theme.of(context).colorScheme.textTitle,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 16,
          ),
          Divider(
            thickness: 1.h,
            height: 1.h,
            color: Theme.of(context).colorScheme.border,
          ),
        ],
      ),
    );
  }
}

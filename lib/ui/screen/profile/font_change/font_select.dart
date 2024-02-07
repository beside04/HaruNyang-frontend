import 'package:flutter/material.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';

class FontSelect extends StatelessWidget {
  const FontSelect({super.key});

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
            '폰트 종류',
            style: kHeader4Style.copyWith(
              color: Theme.of(context).colorScheme.textTitle,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 16,
          ),
          // ListView.builder(itemBuilder: (_) {
          //   return Container(
          //     child: Text('ddd'),
          //   )
          // }),
        ],
      ),
    );
  }
}

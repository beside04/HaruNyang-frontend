import 'package:flutter/material.dart';
import 'package:frontend/config/theme/theme_data.dart';

class FontViewer extends StatelessWidget {
  const FontViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Theme.of(context).colorScheme.borderModal,
      child: Center(
        child: Text('text'),
      ),
    );
  }
}

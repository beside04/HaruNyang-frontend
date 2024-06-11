import 'package:flutter/material.dart';

class LetterPaperPainter extends CustomPainter {
  final Color color;
  final int lineCount;

  LetterPaperPainter({
    required this.color,
    required this.lineCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // You can calculate the line height based on the text style.
    const lineHeight = 34.0;
    const lineSpace = 34.0; // The space between lines

    // Draw lines based on the number of lines of the text
    for (var i = 0; i < (size.height / lineHeight) + lineCount; i++) {
      final y = i * lineHeight + lineSpace;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

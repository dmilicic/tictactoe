import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe2/ui/colors.dart';

class SymbolPainter extends CustomPainter {
  final String symbol;
  final Animation<double> animation;

  static const strokeWidth = 20.0;

  late Paint paintForX = Paint()
    ..color = AppColors.colorX
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth;

  late Paint arcPaint = Paint()
    ..color = AppColors.colorX
    ..style = PaintingStyle.fill
    ..strokeWidth = strokeWidth;

  late Paint paintForO = Paint()
    ..color = AppColors.colorO
    ..style = PaintingStyle.stroke
    ..strokeWidth = 15.0;

  SymbolPainter({required this.symbol, required this.animation});

  void paintX(Canvas canvas, Size size) {

    final path1Value = animation.value < 0.5 ? min(animation.value * 2, 1.0) : 1.0;
    final path1 = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * path1Value, size.height * path1Value);
    canvas.drawPath(path1, paintForX);

    final path2Value = animation.value > 0.5 ? min((animation.value - 0.5) * 2, 1.0) : 0.0;
    final path2 = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width - size.width * path2Value, size.height * path2Value);

    // Draw shadows for the paths
    // TODO: fix shadow
    // canvas.drawShadow(path1, Colors.black, 6.0, false);
    // canvas.drawShadow(path2, Colors.black, 6.0, false);

    canvas.drawPath(path2, paintForX);

    canvas.drawCircle(const Offset(0, 0), strokeWidth / 2, arcPaint);

    if (animation.value > 0.5) {
      canvas.drawCircle(Offset(size.width, size.height), strokeWidth / 2, arcPaint);
      canvas.drawCircle(Offset(size.width, 0), strokeWidth / 2, arcPaint);
    }

    if (animation.value > 0.99) {
      canvas.drawCircle(Offset(0, size.height), strokeWidth / 2, arcPaint);
    }
  }

  void paintO(Canvas canvas, Size size) {
    final sweepAngle = animation.value * 2 * pi;
    final arcRect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2);

    // Draw shadow for the arc TODO: fix shadow
    // final arcPath = Path()..addArc(arcRect, 90, sweepAngle);
    // canvas.drawShadow(arcPath, Colors.green, 5.0, false);

    canvas.drawArc(arcRect, 0, sweepAngle, false, paintForO);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (symbol == "X") {
      paintX(canvas, size);
    } else if (symbol == "O") {
      paintO(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

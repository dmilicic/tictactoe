import 'dart:math';

import 'package:flutter/material.dart';

class BoardPainter extends CustomPainter {

  final _paint = Paint()
    ..color = const Color(0xFF0D4458)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10.0;

  final _circlePaint = Paint()
    ..color = const Color(0xFF0D4458)
    ..style = PaintingStyle.fill;

  final double _circleRadius = 5.0;

  @override
  void paint(Canvas canvas, Size size) {

    final double width = size.width;
    final double height = size.height;

    // Draw horizontal lines
    canvas.drawLine(Offset(0, height / 3), Offset(width, height / 3), _paint);
    canvas.drawLine(Offset(0, 2 * height / 3), Offset(width, 2 * height / 3), _paint);

    // Draw vertical lines
    canvas.drawLine(Offset(width / 3, 0), Offset(width / 3, height), _paint);
    canvas.drawLine(Offset(2 * width / 3, 0), Offset(2 * width / 3, height), _paint);

    // Draw circles at the ends of the lines
    canvas.drawCircle(Offset(0, height / 3), _circleRadius, _circlePaint);
    canvas.drawCircle(Offset(width, height / 3), _circleRadius, _circlePaint);
    canvas.drawCircle(Offset(0, 2 * height / 3), _circleRadius, _circlePaint);
    canvas.drawCircle(Offset(width, 2 * height / 3), _circleRadius, _circlePaint);
    canvas.drawCircle(Offset(width / 3, 0), _circleRadius, _circlePaint);
    canvas.drawCircle(Offset(width / 3, height), _circleRadius, _circlePaint);
    canvas.drawCircle(Offset(2 * width / 3, 0), _circleRadius, _circlePaint);
    canvas.drawCircle(Offset(2 * width / 3, height), _circleRadius, _circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

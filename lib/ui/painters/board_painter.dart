import 'dart:math';

import 'package:flutter/material.dart';

import '../colors.dart';

class BoardPainter extends CustomPainter {

  late double strokeWidth;

  BoardPainter({
    this.strokeWidth = 10.0,
  });

  late final _paint = Paint()
    ..color = AppColors.board
    ..style = PaintingStyle.stroke
    ..strokeWidth = strokeWidth;

  final _circlePaint = Paint()
    ..color = AppColors.board
    ..style = PaintingStyle.fill;

  late final double _circleRadius = strokeWidth / 2;

  @override
  void paint(Canvas canvas, Size size) {

    final double width = size.width;
    final double height = size.height;

    // Draw horizontal lines
    canvas.drawLine(Offset(0, height / 3), Offset(width, height / 3), _paint);
    canvas.drawLine(Offset(0, 2 * height / 3), Offset(width, 2 * height / 3), _paint);

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

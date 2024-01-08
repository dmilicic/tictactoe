import 'dart:math';

import 'package:flutter/material.dart';

import '../colors.dart';

class WinningLinePainter extends CustomPainter {

  final _paint = Paint()
    ..color = AppColors.board
    ..style = PaintingStyle.fill
    ..strokeWidth = 10.0;

  // Add a new variable to store the winning line's start and end points
  final Offset? winLineStart;
  final Offset? winLineEnd;

  WinningLinePainter({this.winLineStart, this.winLineEnd});

  @override
  void paint(Canvas canvas, Size size) {

    // Draw the winning line if the start and end points are not null
    if (winLineStart != null && winLineEnd != null) {
      canvas.drawLine(winLineStart!, winLineEnd!, _paint);
      canvas.drawCircle(winLineStart!, 5, _paint);
      canvas.drawCircle(winLineEnd!, 5, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is WinningLinePainter) {
      return oldDelegate.winLineStart != winLineStart || oldDelegate.winLineEnd != winLineEnd;
    }

    return false;
  }
}

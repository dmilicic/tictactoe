import 'dart:math';

import 'package:flutter/material.dart';

import '../../ai/ai.dart';
import '../../utils/Pair.dart';
import '../colors.dart';

class WinningLinePainter extends CustomPainter {

  final Animation<double>? animation;

  final _paint = Paint()
    ..color = AppColors.board
    ..style = PaintingStyle.fill
    ..strokeWidth = 10.0;

  // Add a new variable to store the winning line's start and end points
  final int winLineIdx;
  final double boardSize;

  WinningLinePainter({required this.boardSize, this.winLineIdx = 0, this.animation});

  @override
  void paint(Canvas canvas, Size size) {

    if (winLineIdx >= Ai.winningLines.length || winLineIdx < 0) {
      return;
    }

    final element = Ai.winningLines[winLineIdx];

    var startOffset = element.first * boardSize;
    var endOffset = element.second * boardSize;

    // determine which coordinate value to animate
    if (element.first.dy == element.second.dy) {
      endOffset = Offset(endOffset.dx * (animation?.value ?? 0), endOffset.dy);

    } else if(element.first.dx == element.second.dx) {
      endOffset = Offset(endOffset.dx, endOffset.dy * (animation?.value ?? 0));

    } else if (element.first.dy == element.first.dx && element.second.dx == element.second.dy) {
      endOffset = Offset(endOffset.dx * (animation?.value ?? 0), endOffset.dy * (animation?.value ?? 0));

    } else {
      endOffset = Offset(endOffset.dx + startOffset.dx * (1 - (animation?.value ?? 0)), endOffset.dy * (animation?.value ?? 0));
    }

    canvas.drawLine(startOffset, endOffset, _paint);
    canvas.drawCircle(startOffset, 5, _paint);
    canvas.drawCircle(endOffset, 5, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';

import '../../ai/ai.dart';
import '../painters/winning_line_painter.dart';

class WinningLine extends StatefulWidget {

  final winningLineIdx;
  final boardSize;

  const WinningLine({super.key, this.winningLineIdx, this.boardSize});

  @override
  State<WinningLine> createState() => _WinningLineState();
}

class _WinningLineState extends State<WinningLine> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {

    if (widget.winningLineIdx >= Ai.winningLines.length || widget.winningLineIdx < 0) {
      _controller.reset();
      return Container();
    }

    _controller.forward();

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          painter: WinningLinePainter(
            boardSize: widget.boardSize,
            winLineIdx: widget.winningLineIdx,
            animation: _controller,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

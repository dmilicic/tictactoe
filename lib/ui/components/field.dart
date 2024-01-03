import 'package:flutter/material.dart';
import 'package:tictactoe2/ui/painters/symbol_painter.dart';

class Field extends StatefulWidget {
  final int idx;
  final Function(int idx) onTap;
  final String playerSymbol;

  const Field(
      {super.key,
      required this.idx,
      required this.onTap,
      required this.playerSymbol});

  @override
  State<Field> createState() => _FieldState();
}

class _FieldState extends State<Field> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _handleTap() {
    // only send tap events if the field is empty
    if (widget.playerSymbol == "") {
      _controller.forward();
      widget.onTap(widget.idx);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if (widget.playerSymbol == "") {
      _controller.reset();
    }

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
          margin: const EdgeInsets.all(0.0),
          child: Center(
              child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {

              if (widget.playerSymbol == "O") {
                _controller.forward();
              }

              return CustomPaint(
                  painter: SymbolPainter(
                    symbol: widget.playerSymbol,
                    animation: _controller,
                  ),
                  size: const Size(50, 50));
            },
          ))),
    );
  }
}
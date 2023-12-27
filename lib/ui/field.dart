import 'package:flutter/material.dart';
import 'package:tictactoe2/providers/AnimationControllerProvider.dart';
import 'package:tictactoe2/ui/symbol_painter.dart';

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
  final BorderSide _borderSide = const BorderSide(
    color: Color(0xFF00d2c9),
    width: 2.0,
    style: BorderStyle.solid,
  );

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

  /// Returns a border to draw depending on this field index.
  Border _determineBorder() {
    Border determinedBorder = Border.all();

    switch (widget.idx) {
      case 0:
        determinedBorder = Border(bottom: _borderSide, right: _borderSide);
        break;
      case 1:
        determinedBorder =
            Border(left: _borderSide, bottom: _borderSide, right: _borderSide);
        break;
      case 2:
        determinedBorder = Border(left: _borderSide, bottom: _borderSide);
        break;
      case 3:
        determinedBorder =
            Border(bottom: _borderSide, right: _borderSide, top: _borderSide);
        break;
      case 4:
        determinedBorder = Border(
            left: _borderSide,
            bottom: _borderSide,
            right: _borderSide,
            top: _borderSide);
        break;
      case 5:
        determinedBorder =
            Border(left: _borderSide, bottom: _borderSide, top: _borderSide);
        break;
      case 6:
        determinedBorder = Border(right: _borderSide, top: _borderSide);
        break;
      case 7:
        determinedBorder =
            Border(left: _borderSide, top: _borderSide, right: _borderSide);
        break;
      case 8:
        determinedBorder = Border(left: _borderSide, top: _borderSide);
        break;
    }

    return determinedBorder;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
          margin: const EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            border: _determineBorder(),
          ),
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

// CustomPaint(
// painter: SymbolPainter(symbol: widget.playerSymbol, animation: _controller),
// size: const Size(50, 50),
// ),

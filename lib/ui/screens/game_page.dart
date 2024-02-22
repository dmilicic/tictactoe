import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe2/ai/ai.dart';
import 'package:tictactoe2/ui/components/buttons.dart';
import 'package:tictactoe2/ui/components/field.dart';
import 'package:tictactoe2/presenters/game_presenter.dart';
import 'package:tictactoe2/ui/painters/board_painter.dart';

import '../../ai/utils.dart';
import '../colors.dart';
import '../components/title.dart';
import '../components/winning_line.dart';

class GamePage extends StatefulWidget {
  final String title;

  const GamePage(this.title, {super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  late List<int> board;
  late int _currentPlayer;
  late GamePresenter _presenter;

  bool showWinningLine = false;

  GamePageState() {
    _presenter = GamePresenter(_movePlayed, _onGameEnd, _showWinningLine);
  }

  void _onGameEnd(int winner) {
    var title = "Game over!";
    var content = "You lost :(";
    const drawText = "Draw!";

    switch (winner) {
      case Ai.HUMAN: // will never happen :)
        title = "Congratulations!";
        content = "You managed to beat an unbeatable AI!";
        break;
      case Ai.AI_PLAYER:
        title = "Game Over!";
        content = "You lose :(";
        break;
      default:
        title = drawText;
        content = "No winners here.";
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,
                style: TextStyle(
                    fontSize: 30,
                    color: title == drawText
                        ? AppColors.primary
                        : AppColors.tertiary)),
            content: Text(content, style: const TextStyle(fontSize: 20)),
            actions: <Widget>[
              AppButton(
                  text: "Restart",
                  size: const Size(80, 50),
                  onPressed: () {
                    setState(() {
                      reinitialize();
                      Navigator.of(context).pop();
                    });
                  })
            ],
          );
        });
  }

  void _movePlayed(int idx) {
    setState(() {
      board[idx] = _currentPlayer;

      if (_currentPlayer == Ai.HUMAN) {
        // switch to AI player
        _currentPlayer = Ai.AI_PLAYER;
        _presenter.onHumanPlayed(board);
      } else {
        _currentPlayer = Ai.HUMAN;
      }
    });
  }

  void _showWinningLine(int winningLineIdx) {
    setState(() {
      showWinningLine = true;
    });
  }

  String? getSymbolForIdx(int idx) {
    return Ai.SYMBOLS[board[idx]];
  }

  @override
  void initState() {
    super.initState();
    reinitialize();
  }

  void reinitialize() {
    _currentPlayer = Ai.HUMAN;
    // generate the initial board
    board = List.generate(9, (idx) => 0);
    showWinningLine = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final winningLineIdx = Utils.getWinningLineIdx(board);

    const double padding = 32;

    var fields = GridView.count(
        crossAxisCount: 3,
        // generate the widgets that will display the board
        children: List.generate(9, (idx) {
          return Field(
              idx: idx,
              onTap: _currentPlayer == Ai.HUMAN ? _movePlayed : (idx) => null,
              playerSymbol: getSymbolForIdx(idx) ?? "N");
        }));

    var stackedWidgets = <Widget>[];

    stackedWidgets.add(fields);

    return Scaffold(
      appBar: AppBar(
        title: const AppTitle(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(60),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'You are playing as ',
                  style: TextStyle(
                      fontSize: 30,
                      color: AppColors.black,
                      fontWeight: FontWeight.normal,
                      height: 1.5),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'X',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.colorX)),
                  ],
                ),
              ),
            ),
            Flexible(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {

                  final boardSize = min(constraints.maxWidth, screenSize.height / 1.5);
                  double boardSizeWithPadding =
                      boardSize - (2 * padding); // 32 is the padding on each side

                  if (showWinningLine) {
                    stackedWidgets.add(
                        WinningLine(
                            winningLineIdx: winningLineIdx,
                            boardSize: boardSizeWithPadding)
                    );
                  }

                  return Container(
                    width: boardSize,
                    height: boardSize,
                    constraints: BoxConstraints(
                      maxWidth: boardSize,
                      maxHeight: boardSize,
                    ),
                    padding: const EdgeInsets.all(padding),
                    child: CustomPaint(
                      painter: BoardPainter(),
                      child: Stack(
                        children: stackedWidgets,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

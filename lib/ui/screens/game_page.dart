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
import '../fonts.dart';
import '../ui_threshold.dart';

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
        title = "Congrats!";
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

    showEndGameDialog(title, content);
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

  void showEndGameDialog(String title, String content) {
    const drawText = "Draw!";

    showDialog(
        context: context,
        builder: (BuildContext context) {
          final screenWidth = MediaQuery.of(context).size.width;

          final restartButton = AppButton(
              text: "Restart",
              size: screenWidth < UIThreshold.widthThreshold ? const Size(40, 40) : const Size(80, 50),
              onPressed: () {
                setState(() {
                  reinitialize();
                  Navigator.of(context).pop();
                });
              });

          // center the button on smaller screens
          final actionWidget = screenWidth < UIThreshold.widthThreshold
              ? Center(child: restartButton)
              : restartButton;

          return AlertDialog(
            insetPadding: const EdgeInsets.all(8.0),
            title: Text(title,
                style: TextStyle(
                    fontSize: screenWidth < UIThreshold.widthThreshold ? FontSize.small : FontSize.extraLarge,
                    color: title == drawText
                        ? AppColors.primary
                        : AppColors.tertiary)),

            contentPadding: screenWidth < UIThreshold.widthThreshold
                ? const EdgeInsets.all(8.0)
                : const EdgeInsets.all(16.0),

            content: SizedBox(
              width: screenWidth < UIThreshold.widthThreshold ? 800 : 400,
              child: Text(
                  content,
                  style: TextStyle(
                      fontSize: screenWidth < UIThreshold.widthThreshold ? FontSize.small : FontSize.large
                  )
              ),
            ),


            actionsPadding: screenWidth < UIThreshold.widthThreshold
                ? const EdgeInsets.all(8.0)
                : const EdgeInsets.all(16.0),

            actions: <Widget>[
              actionWidget,
            ],
          );
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

    final padding = screenSize.width < UIThreshold.widthThreshold ? 8.0 : 32.0;
    final backIconSize = screenSize.width < UIThreshold.widthThreshold ? 16.0 : 24.0;

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
        leading: IconButton(
          padding: const EdgeInsets.all(0),
          iconSize: backIconSize,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(padding * 2),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'You are playing as ',
                  style: TextStyle(
                      fontSize: screenSize.width < UIThreshold.widthThreshold ? FontSize.small : FontSize.large,
                      color: AppColors.black,
                      fontWeight: FontWeight.normal,
                      height: 1.5),
                  children: const <TextSpan>[
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
                    padding: EdgeInsets.all(padding),
                    child: CustomPaint(
                      painter: BoardPainter(
                        strokeWidth: screenSize.width < UIThreshold.widthThreshold ? 5 : 10,
                      ),
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

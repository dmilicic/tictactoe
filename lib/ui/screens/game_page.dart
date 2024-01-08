import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tictactoe2/ai/ai.dart';
import 'package:tictactoe2/ui/components/buttons.dart';
import 'package:tictactoe2/ui/components/field.dart';
import 'package:tictactoe2/presenters/game_presenter.dart';
import 'package:tictactoe2/ui/painters/board_painter.dart';
import 'package:tictactoe2/ui/painters/winning_line_painter.dart';

import '../../ai/utils.dart';
import '../colors.dart';
import '../components/title.dart';

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

  GamePageState() {
    _presenter = GamePresenter(_movePlayed, _onGameEnd);
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
  }

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final boardSize = min(screenSize.width, screenSize.height);
    final winningLine = Utils.getWinningLine(board);

    final winningLineWidget = winningLine != null ?
      CustomPaint(
        painter: WinningLinePainter(
          winLineStart: winningLine.first * boardSize,
          winLineEnd: winningLine.second * boardSize,
        ),
      ) : Container();

    return Scaffold(
      appBar: AppBar(
        title: const AppTitle(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          Container(
            width: boardSize,
            height: boardSize,
            padding: const EdgeInsets.all(32),
            child: CustomPaint(
              painter: BoardPainter(),
              child: Stack(
                children: <Widget>[GridView.count(
                  crossAxisCount: 3,
                  // generate the widgets that will display the board
                  children: List.generate(9, (idx) {
                    return Field(
                        idx: idx,
                        onTap: _currentPlayer == Ai.HUMAN
                            ? _movePlayed
                            : (idx) => null,
                        playerSymbol: getSymbolForIdx(idx) ?? "N");
                  }),
                ),

                  winningLineWidget,

                  // winLineStart: Offset(boardSize / 7, boardSize / 20),
                  // winLineEnd: Offset(boardSize / 7, boardSize * 16 / 20),



                ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}

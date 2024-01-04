import 'package:flutter/material.dart';
import 'package:tictactoe2/ai/ai.dart';
import 'package:tictactoe2/ui/components/field.dart';
import 'package:tictactoe2/presenters/game_presenter.dart';
import 'package:tictactoe2/ui/painters/board_painter.dart';

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
    var content = "You lose :(";
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
        title = "Draw!";
        content = "No winners here.";
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      reinitialize();
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text("Restart"))
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
    return Scaffold(
      appBar: AppBar(
        title: const AppTitle(),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(60),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'You are playing as ',
                style: TextStyle(fontSize: 30, color: AppColors.black, fontWeight: FontWeight.normal, height: 1.5),
                children: <TextSpan>[
                  TextSpan(text: 'X', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.colorX)),
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(32),
            child: CustomPaint(
              painter: BoardPainter(),
              child: GridView.count(
                crossAxisCount: 3,
                // generate the widgets that will display the board
                children: List.generate(9, (idx) {

                  final padding = getPaddingForField(idx);

                  return Padding(
                    padding: padding,
                    child: Field(
                        idx: idx,
                        onTap: _movePlayed,
                        playerSymbol: getSymbolForIdx(idx) ?? "N"),
                  );
                }),
              ),
            ),
          )),
        ],
      ),
    );
  }

  EdgeInsets getPaddingForField(int idx) {
    switch(idx + 1) {
      case 1:
      case 2:
      case 3:
        return const EdgeInsets.only(top: 0);
      case 4:
      case 5:
      case 6:
        return const EdgeInsets.only(top: 30);
      case 7:
      case 8:
      case 9:
        return const EdgeInsets.only(top: 60);
      default:
        return const EdgeInsets.only(left: 0);
    }
  }

}

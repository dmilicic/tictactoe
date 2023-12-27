import 'package:flutter/material.dart';
import 'package:tictactoe2/ai/ai.dart';
import 'package:tictactoe2/providers/AnimationControllerProvider.dart';
import 'package:tictactoe2/ui/field.dart';
import 'package:tictactoe2/ui/game_presenter.dart';

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
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(60),
            child: Text(
              "You are playing as X",
              style: TextStyle(fontSize: 25),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(32),
            child: GridView.count(
              crossAxisCount: 3,
              // generate the widgets that will display the board
              children: List.generate(9, (idx) {
                return Field(
                    idx: idx,
                    onTap: _movePlayed,
                    playerSymbol: getSymbolForIdx(idx) ?? "N");
              }),
            ),
          )),
        ],
      ),
    );
  }
}

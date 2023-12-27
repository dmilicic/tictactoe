import 'package:flutter/material.dart';
import 'package:tictactoe2/ui/game_page.dart';
import 'package:tictactoe2/ui/home_presenter.dart';

class HomePage extends StatefulWidget {
  const HomePage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomePresenter _presenter;

  _HomePageState() {
    _presenter = HomePresenter();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.amber,
      backgroundColor: Colors.grey[300],
      minimumSize: const Size(200, 80),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.amber, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text(
            "Welcome to Flutter Tic Tac Toe!",
            style: TextStyle(fontSize: 20),
          ),
          Center(
            child: ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GamePage(widget.title)));
              },
              child: const Text(
                "New game!",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          StreamBuilder(
              stream: _presenter.buildVictoriesStream(),
              builder: (context, snapshot) {
                var playerCount =
                    _presenter.getVictoryCountFromStream(snapshot);
                if (playerCount <= 0) {
                  return const Text("No AI wins yet!",
                      style: TextStyle(fontSize: 15));
                }

                return Text("Number of AI wins: $playerCount",
                    style: const TextStyle(fontSize: 15));
              }),
        ],
      ),
    );
  }
}

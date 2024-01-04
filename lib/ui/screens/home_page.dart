import 'package:flutter/material.dart';
import 'package:tictactoe2/main.dart';
import 'package:tictactoe2/ui/colors.dart';
import 'package:tictactoe2/ui/components/title.dart';
import 'package:tictactoe2/ui/screens/game_page.dart';

import '../../presenters/home_presenter.dart';

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
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primary,
      minimumSize: const Size(200, 80),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const AppTitle(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: 'Welcome to a simple unwinnable game written in ',
                style: TextStyle(fontSize: 20, color: AppColors.black, fontWeight: FontWeight.normal, height: 1.5),
                children: <TextSpan>[
                  TextSpan(text: 'Flutter', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.colorO)),
                  TextSpan(text: '!', style: TextStyle(fontWeight: FontWeight.normal, color: AppColors.black)),
                ],
              ),
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

                  return RichText(
                    text: TextSpan(
                      text: 'Number of AI wins: ',
                      style: const TextStyle(fontSize: 20, color: AppColors.black),
                      children: <TextSpan>[
                        TextSpan(text: "$playerCount", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.tertiary)),
                      ],
                    ),
                  );

                  // return Text("Number of AI wins: $playerCount",
                  //     style: const TextStyle(fontSize: 15));
                }),
          ],
        ),
      ),
    );
  }
}

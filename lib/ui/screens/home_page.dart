import 'package:flutter/material.dart';
import 'package:tictactoe2/ui/colors.dart';
import 'package:tictactoe2/ui/components/title.dart';
import 'package:tictactoe2/ui/screens/game_page.dart';

import '../../presenters/home_presenter.dart';
import '../fonts.dart';
import '../ui_threshold.dart';

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

  ButtonStyle getButtonStyle(double screenWidth) {
    var style = ElevatedButton.styleFrom(
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primary,
      minimumSize: const Size(200, 80),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );

    if (screenWidth < UIThreshold.widthThreshold) {
      style = style.copyWith(
        minimumSize: MaterialStateProperty.all(const Size(100, 40)),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 4)),
      );
    }

    return style;
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    final fontSize = screenWidth < UIThreshold.widthThreshold ? FontSize.small : FontSize.medium;
    final ButtonStyle raisedButtonStyle = getButtonStyle(screenWidth);
    final edgePadding = screenWidth < UIThreshold.widthThreshold ? 8.0 : 48.0;

    return Scaffold(
      appBar: AppBar(
        title: const AppTitle(),
      ),
      body: Padding(
        padding: EdgeInsets.all(edgePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Welcome to a simple unwinnable game written in ',
                style: TextStyle(fontSize: fontSize, color: AppColors.black, fontWeight: FontWeight.normal, height: 1.5),
                children: const <TextSpan>[
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
                child: Text(
                  "New game!",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
            StreamBuilder(
                stream: _presenter.buildVictoriesStream(),
                builder: (context, snapshot) {
                  var playerCount =
                      _presenter.getVictoryCountFromStream(snapshot);
                  if (playerCount <= 0) {
                    return Text("No AI wins yet!",
                        style: TextStyle(
                            fontSize: screenWidth < UIThreshold.widthThreshold
                                ? FontSize.verySmall
                                : FontSize.small
                        ));
                  }

                  return RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Number of AI wins: ',
                      style: TextStyle(fontSize: fontSize, color: AppColors.black),
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

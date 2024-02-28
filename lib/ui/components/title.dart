
import 'package:flutter/cupertino.dart';
import 'package:tictactoe2/ui/ui_threshold.dart';

import '../colors.dart';
import '../fonts.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < UIThreshold.widthThreshold ? FontSize.small : FontSize.extraLarge;

    return RichText(
      text: TextSpan(
        text: 'Flutter ',
        style: TextStyle(fontSize: fontSize, color: AppColors.black),
        children: const <TextSpan>[
          TextSpan(text: 'Tic', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.colorO)),
          TextSpan(text: '-', style: TextStyle(fontWeight: FontWeight.normal)),
          TextSpan(text: 'Tac', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.colorX)),
          TextSpan(text: '-', style: TextStyle(fontWeight: FontWeight.normal)),
          TextSpan(text: 'Toe', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        ],
      ),
    );
  }
}

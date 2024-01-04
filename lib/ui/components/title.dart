
import 'package:flutter/cupertino.dart';

import '../colors.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        text: 'Flutter ',
        style: TextStyle(fontSize: 25, color: AppColors.black),
        children: <TextSpan>[
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

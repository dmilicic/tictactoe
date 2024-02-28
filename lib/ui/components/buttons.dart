
import 'package:flutter/material.dart';
import 'package:tictactoe2/ui/ui_threshold.dart';

import '../colors.dart';
import '../fonts.dart';

class AppButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;
  final Size size;

  const AppButton({super.key,
    required this.text,
    required this.onPressed,
    required this.size
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth < UIThreshold.widthThreshold ? FontSize.small : FontSize.large;

    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primary,
      minimumSize: size,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );

    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: fontSize)),
    );
  }
}

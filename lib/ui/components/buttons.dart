
import 'package:flutter/material.dart';

import '../colors.dart';

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
      child: Text(text, style: const TextStyle(fontSize: 20)),
    );
  }
}

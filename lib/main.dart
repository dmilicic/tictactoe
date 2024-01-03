import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tictactoe2/ui/screens/home_page.dart';
import 'firebase_options.dart';

String title = "Flutter Tic Tac Toe";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage(key: const Key("key"), title: title),
    );
  }
}
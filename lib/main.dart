import 'package:flutter/material.dart';
import 'ui/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

String title = "Flutter Tic Tac Toe";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(TicTacToe());
}

class TicTacToe extends StatelessWidget {
  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage(key: Key("key"), title: title),
    );
  }
}
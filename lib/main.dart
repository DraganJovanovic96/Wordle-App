import 'package:flutter/material.dart';
import 'package:recko/screens/start_game_screen.dart';

void main() => runApp(const ReckoApp());

class ReckoApp extends StatelessWidget {
  const ReckoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Речко',
      debugShowCheckedModeBanner: false,
      home: StartGameScreen(),
    );
  }
}

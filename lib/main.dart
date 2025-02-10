import 'package:flutter/material.dart';
import 'screens/wordle_game.dart';

void main() => runApp(const ReckoApp());

class ReckoApp extends StatelessWidget {
  const ReckoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  'Речко',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.bar_chart, color: Colors.white, size: 30),
              Spacer(),
              Icon(Icons.lightbulb, color: Colors.white, size: 30),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: const SafeArea(child: WordleGame()),
      ),
    );
  }
}

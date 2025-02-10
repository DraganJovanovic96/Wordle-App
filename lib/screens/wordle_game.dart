// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../widgets/wordle_board.dart';
import '../widgets/wordle_keyboard.dart';

class WordleGame extends StatefulWidget {
  const WordleGame({super.key});

  @override
  _WordleGameState createState() => _WordleGameState();
}

class _WordleGameState extends State<WordleGame> {
  List<List<String>> board =
      List.generate(6, (_) => List.generate(5, (_) => ''));
  int currentRow = 0;
  int currentCol = 0;

  void onKeyPressed(String letter) {
    setState(() {
      if (letter == 'ENTER') {
        if (currentCol == 5) {
          if (currentRow < 5) {
            currentRow++;
            currentCol = 0;
          }
        }
      } else if (letter == 'BACK') {
        if (currentCol > 0) {
          currentCol--;
          board[currentRow][currentCol] = '';
        }
      } else {
        if (currentCol < 5) {
          board[currentRow][currentCol] = letter;
          currentCol++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: WordleBoard(board: board)),
        WordleKeyboard(letterStates: const {}, onKeyPressed: onKeyPressed),
      ],
    );
  }
}

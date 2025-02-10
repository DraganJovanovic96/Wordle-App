import 'package:flutter/material.dart';
import 'wordle_key.dart';

enum LetterState { correct, present, absent }

class WordleKeyboard extends StatelessWidget {
  final Map<String, LetterState> letterStates;
  final Function(String) onKeyPressed;

  const WordleKeyboard(
      {super.key, required this.letterStates, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildRow('ЉЊЕРТЗУИОПШ'),
        _buildRow('АСДФГХЈКЛЧЋ'),
        _buildRow('ЏЦВБНМЂЖ', isLastRow: true),
      ],
    );
  }

  Widget _buildRow(String letters, {bool isLastRow = false}) {
    final rowLetters = letters.split('');
    if (isLastRow) {
      rowLetters.insert(0, 'ENTER');
      rowLetters.add('BACK');
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: rowLetters.map((letter) {
          final int flexValue = (letter == 'ENTER' || letter == 'BACK') ? 2 : 1;
          return Expanded(
            flex: flexValue,
            child: WordleKey(
              letter: letter,
              onTap: () => onKeyPressed(letter),
              baseColor: _getKeyColor(letter),
              content: _getKeyContent(letter),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getKeyColor(String letter) {
    if (letter == 'ENTER' || letter == 'BACK') {
      return Colors.grey.shade600;
    }
    final state = letterStates[letter];
    switch (state) {
      case LetterState.correct:
        return Colors.green;
      case LetterState.present:
        return Colors.amber;
      case LetterState.absent:
        return Colors.grey.shade900;
      default:
        return Colors.grey.shade600;
    }
  }

  Widget _getKeyContent(String letter) {
    if (letter == 'BACK') {
      return const Icon(Icons.backspace, color: Colors.white);
    }
    if (letter == 'ENTER') {
      return const Text(
        '⏎',
        style: TextStyle(color: Colors.white, fontSize: 20),
      );
    }
    return Text(
      letter,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

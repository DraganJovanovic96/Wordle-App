import 'package:flutter/material.dart';
import 'package:recko/models/letter_state.dart';
import 'wordle_key.dart'; // Make sure to import the file where WordleKey is defined

class WordleKeyboard extends StatelessWidget {
  final Map<String, LetterState> letterStates;
  final Function(String) onKeyPressed;

  const WordleKeyboard({
    super.key,
    required this.letterStates,
    required this.onKeyPressed,
  });

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
          return WordleKey(
            letter: letter,
            onTap: () => onKeyPressed(letter),
            baseColor: _getKeyColor(letter),
            content: _getKeyContent(letter),
          );
        }).toList(),
      ),
    );
  }

  Color _getKeyColor(String letter) {
    // Special keys get a default grey.
    if (letter == 'ENTER' || letter == 'BACK') {
      return Colors.grey.shade600;
    }
    // Look up the letter state in the map.
    final state = letterStates[letter];
    switch (state) {
      case LetterState.correct:
        return const Color(0xFF588B56); // Custom green (#588B56)
      case LetterState.present:
        return const Color(0xFFB39D4D); // Custom amber/gold
      case LetterState.absent:
        return const Color(0xFF3A3A3C); // Custom dark grey
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

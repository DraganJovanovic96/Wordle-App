import 'package:flutter/material.dart';
import 'package:recko/models/letter_state.dart';

class WordleBoard extends StatelessWidget {
  final List<List<String>> board;
  final List<List<LetterState?>>? states; // Optional cell states

  const WordleBoard({super.key, required this.board, this.states});

  Color? _getCellColor(LetterState state) {
    switch (state) {
      case LetterState.correct:
        return const Color(0xFF588B56);
      case LetterState.present:
        return const Color(0xFFB39D4D);
      case LetterState.absent:
        return const Color(0xFF3A3A3C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: List.generate(6, (rowIndex) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: List.generate(5, (colIndex) {
                      Color? cellColor;
                      if (states != null &&
                          states![rowIndex][colIndex] != null) {
                        cellColor = _getCellColor(states![rowIndex][colIndex]!);
                      }
                      return Expanded(
                        child: AspectRatio(
                          aspectRatio: 0.6,
                          child: Container(
                            margin: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: cellColor, // Will be null if not set
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                board[rowIndex][colIndex],
                                style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

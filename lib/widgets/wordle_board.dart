import 'package:flutter/material.dart';

class WordleBoard extends StatelessWidget {
  final List<List<String>> board;

  const WordleBoard({super.key, required this.board});

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
                      return Expanded(
                        child: AspectRatio(
                          aspectRatio: 0.6,
                          child: Container(
                            margin: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
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

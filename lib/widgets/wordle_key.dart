// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class WordleKey extends StatefulWidget {
  final String letter;
  final VoidCallback onTap;
  final Color baseColor;
  final Widget content;

  const WordleKey({
    super.key,
    required this.letter,
    required this.onTap,
    required this.baseColor,
    required this.content,
  });

  @override
  _WordleKeyState createState() => _WordleKeyState();
}

class _WordleKeyState extends State<WordleKey> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // When pressed, darken the color slightly.
    Color displayedColor =
        _isPressed ? darken(widget.baseColor, 0.3) : widget.baseColor;

    return Expanded(
      flex: (widget.letter == 'ENTER' || widget.letter == 'BACK') ? 2 : 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: InkWell(
          onTap: widget.onTap,
          onHighlightChanged: (isHighlighted) {
            setState(() {
              _isPressed = isHighlighted;
            });
          },
          borderRadius: BorderRadius.circular(4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: 58,
            decoration: BoxDecoration(
              color: displayedColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(child: widget.content),
          ),
        ),
      ),
    );
  }
}

/// Helper function to darken a color by [amount].
Color darken(Color color, [double amount = .3]) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

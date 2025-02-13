// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class WordleKey extends StatefulWidget {
  final String letter;
  final VoidCallback onTap;
  final Color baseColor;
  final Widget content;
  final bool disabled; // New property

  const WordleKey({
    super.key,
    required this.letter,
    required this.onTap,
    required this.baseColor,
    required this.content,
    this.disabled = false,
  });

  @override
  _WordleKeyState createState() => _WordleKeyState();
}

class _WordleKeyState extends State<WordleKey> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // If disabled, do not darken the key.
    Color displayedColor = widget.disabled
        ? widget.baseColor
        : (_isPressed ? darken(widget.baseColor, 0.4) : widget.baseColor);

    return Expanded(
      flex: (widget.letter == 'ENTER' || widget.letter == 'BACK') ? 2 : 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: InkWell(
          // Disable tap when the key is disabled.
          onTap: widget.disabled ? null : widget.onTap,
          // Disable the highlight effect when disabled.
          onHighlightChanged: widget.disabled
              ? null
              : (isHighlighted) {
                  setState(() {
                    _isPressed = isHighlighted;
                  });
                },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
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

/// Helper function to darken a color by a given [amount].
Color darken(Color color, [double amount = .3]) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

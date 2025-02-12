// start_over.dart
import 'package:flutter/material.dart';

class StartOver extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onStartOver;

  const StartOver({
    Key? key,
    required this.onCancel,
    required this.onStartOver,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(
          child: Text('Нова игра',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
      content: const Text('Да ли желите да започнете новy игру?'),
      actions: [
        ElevatedButton(
          onPressed: onCancel,
          child: const Text(
            'Откажи',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onStartOver,
          child: const Text(
            'Започни',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

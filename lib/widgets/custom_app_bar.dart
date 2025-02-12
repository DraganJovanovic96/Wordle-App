import 'package:flutter/material.dart';
import 'package:recko/widgets/instructions.dart';
import 'package:recko/widgets/start_over.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onResetGame;

  const CustomAppBar({
    Key? key,
    required this.onResetGame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Речко',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.bar_chart, color: Colors.white, size: 30),
          IconButton(
            icon: const Icon(Icons.help, color: Colors.white, size: 30),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const Instructions(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.restart_alt_rounded,
                color: Colors.white, size: 30),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => StartOver(
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onStartOver: () {
                    Navigator.of(context).pop();
                    onResetGame();
                  },
                ),
              );
            },
          ),
          const Spacer(),
          const Icon(Icons.lightbulb, color: Colors.white, size: 30),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

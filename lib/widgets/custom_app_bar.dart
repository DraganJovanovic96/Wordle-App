import 'package:flutter/material.dart';
import 'package:recko/widgets/instructions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The "Речко" title with styling
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
          const Spacer(),
          // const Text(
          //   'ПОМОЋ',
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.white,
          //   ),
          // ),
          // const Icon(Icons.keyboard_double_arrow_right,
          //     color: Colors.white, size: 30),
          const Icon(Icons.lightbulb, color: Colors.white, size: 30),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

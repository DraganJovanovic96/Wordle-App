import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.black,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The "Речко" title with styling
          Center(
            child: Text(
              'Речко',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.bar_chart, color: Colors.white, size: 30),
          Spacer(),
          Text(
            'ПОМОЋ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Icon(Icons.keyboard_double_arrow_right,
              color: Colors.white, size: 30),
          Icon(Icons.lightbulb, color: Colors.white, size: 30),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

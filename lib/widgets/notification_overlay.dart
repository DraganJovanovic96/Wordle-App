// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class NotificationOverlay extends StatefulWidget {
  final String message;
  final bool isError;

  const NotificationOverlay({
    super.key,
    required this.message,
    this.isError = false,
  });

  @override
  _NotificationOverlayState createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<NotificationOverlay> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _visible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          widget.message,
          style: TextStyle(
            color: widget.isError
                ? const Color.fromARGB(255, 0, 0, 0)
                : Colors.green,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

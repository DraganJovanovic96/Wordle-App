// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:recko/widgets/custom_app_bar.dart';
import 'package:recko/widgets/instructions.dart';
import '../services/game_service.dart';
import 'wordle_game.dart'; // Import the instructions widget

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({super.key});

  @override
  _StartGameScreenState createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Auto open the instructions after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => const Instructions(),
      );
    });
  }

  Future<void> _startGame() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final gameService = GameService();
    final playerId = await gameService.startGame();

    if (playerId != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WordleGame()),
        );
      }
    } else {
      setState(() {
        _errorMessage = "Failed to start game. Please try again.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onResetGame: () {}, gameOver: false,
        // gameOver: _gameOver,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_errorMessage != null) ...[
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  // "ПОКРЕНИ" button to start the game
                  ElevatedButton(
                    onPressed: _isLoading ? null : _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                    ),
                    child: const Text(
                      'ПОКРЕНИ',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

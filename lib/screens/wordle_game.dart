// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:recko/widgets/custom_app_bar.dart';
import '../widgets/wordle_board.dart';
import '../widgets/wordle_keyboard.dart';
import '../services/submit_guess_service.dart';
import '../services/game_service.dart';
import '../widgets/notification_overlay.dart';
import '../widgets/start_over.dart'; // Import the StartOver dialog widget
import 'package:recko/models/letter_state.dart';

class WordleGame extends StatefulWidget {
  const WordleGame({super.key});

  @override
  _WordleGameState createState() => _WordleGameState();
}

class _WordleGameState extends State<WordleGame> {
  // Board letters (initially empty)
  List<List<String>> board =
      List.generate(6, (_) => List.generate(5, (_) => ''));
  // Board cell states (null means not yet set)
  List<List<LetterState?>> letterStatesBoard =
      List.generate(6, (_) => List.filled(5, null));

  // Keyboard state map: each letter maps to its best state so far.
  final Map<String, LetterState> _keyboardStates = {};

  int currentRow = 0;
  int currentCol = 0;
  String? _notificationMessage;
  bool _isNotificationError = false;

  // Flag to disable typing after the game is over.
  bool _gameOver = false;

  final SubmitGuessService _submitGuessService = SubmitGuessService();
  final GameService _gameService = GameService();

  @override
  void initState() {
    super.initState();
    _loadActiveGame();
  }

  /// Loads active game state from the server (via /start) and populates the board
  /// as well as the keyboard states.
  Future<void> _loadActiveGame() async {
    final gameData = await _gameService.startGame();
    if (gameData != null) {
      final guessedWordsDto = gameData['guessedWordsDto'] as List<dynamic>?;
      if (guessedWordsDto != null && guessedWordsDto.isNotEmpty) {
        setState(() {
          // Process each previous guess (one per row).
          for (int row = 0; row < guessedWordsDto.length && row < 6; row++) {
            final guessResponse = guessedWordsDto[row];
            String guessedWord = guessResponse['guessedWord'] as String? ?? '';
            guessedWord = guessedWord.toUpperCase();
            final Map<String, dynamic> charStates =
                guessResponse['characters'] as Map<String, dynamic>;

            for (int i = 0; i < 5; i++) {
              if (i < guessedWord.length) {
                // Populate the board.
                board[row][i] = guessedWord[i];
                // Determine the letter state.
                final state =
                    _mapResponseStateToLetterState(charStates[i.toString()]);
                letterStatesBoard[row][i] = state;
                // Update keyboard state for this letter.
                _keyboardStates[guessedWord[i]] =
                    _combineLetterState(_keyboardStates[guessedWord[i]], state);
              }
            }
          }
          currentRow = guessedWordsDto.length;
          currentCol = 0;
        });
      }
    }
  }

  /// Displays a notification overlay.
  void _showNotification(String message, {bool isError = false}) {
    setState(() {
      _notificationMessage = message;
      _isNotificationError = isError;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _notificationMessage = null;
        });
      }
    });
  }

  void onKeyPressed(String letter) async {
    // If the game is over, ignore further input.
    if (_gameOver) return;

    // Clear any existing notification.
    setState(() {
      _notificationMessage = null;
    });

    if (letter == 'ENTER') {
      if (currentCol == 5) {
        String guessedWord = board[currentRow].join();
        try {
          final result = await _submitGuessService.submitGuess(guessedWord);
          if (result != null) {
            // Check game status returned from the backend.
            final String gameStatus = result['gameStatus'];
            final guessedWordsDto = result['guessedWordsDto'] as List<dynamic>;
            if (guessedWordsDto.isNotEmpty) {
              final guessResponse = guessedWordsDto.last;
              final Map<String, dynamic> charStates =
                  guessResponse['characters'] as Map<String, dynamic>;
              for (int i = 0; i < 5; i++) {
                final stateStr = charStates[i.toString()] as String;
                final state = _mapResponseStateToLetterState(stateStr);
                letterStatesBoard[currentRow][i] = state;
                // Update the keyboard state for the guessed letter.
                final letterChar = board[currentRow][i];
                _keyboardStates[letterChar] =
                    _combineLetterState(_keyboardStates[letterChar], state);
              }
            }
            if (gameStatus == 'WIN') {
              setState(() {
                _gameOver = true;
              });
              // Show game-over dialog after a win.
              Future.delayed(Duration.zero, _showGameOverDialog);
            } else {
              if (currentRow < 5) {
                setState(() {
                  currentRow++;
                  currentCol = 0;
                });
              } else {
                // Last row and not win: game lost.
                setState(() {
                  _gameOver = true;
                });
                Future.delayed(Duration.zero, _showGameOverDialog);
              }
            }
          }
        } catch (e) {
          String errorMessage = e.toString().replaceFirst('Exception: ', '');
          if (errorMessage.contains("Word not found")) {
            errorMessage = "Та реч није у нашој бази података.";
          } else if (errorMessage.contains("This word was already submitted")) {
            errorMessage = "Реч је већ коришћена.";
          } else {
            errorMessage = "Дошло је до грешке. Покушајте поново.";
          }
          _showNotification(errorMessage, isError: true);
          setState(() {
            board[currentRow] = List.filled(5, '');
            currentCol = 0;
          });
        }
      }
    } else if (letter == 'BACK') {
      if (currentCol > 0) {
        setState(() {
          currentCol--;
          board[currentRow][currentCol] = '';
        });
      }
    } else {
      if (currentCol < 5) {
        setState(() {
          board[currentRow][currentCol] = letter;
          currentCol++;
        });
      }
    }
  }

  /// Converts the backend state string to our [LetterState] enum.
  LetterState _mapResponseStateToLetterState(String stateStr) {
    switch (stateStr) {
      case 'CORRECT':
        return LetterState.correct;
      case 'PRESENT_BUT_MISPLACED':
        return LetterState.present;
      case 'NOT_PRESENT':
        return LetterState.absent;
      default:
        return LetterState.absent;
    }
  }

  /// Combines two letter states, keeping the higher priority one.
  /// Priorities: absent (0) < present (1) < correct (2)
  LetterState _combineLetterState(LetterState? current, LetterState newState) {
    int currentPriority = current == null ? -1 : _statePriority(current);
    int newPriority = _statePriority(newState);
    return newPriority > currentPriority ? newState : (current ?? newState);
  }

  int _statePriority(LetterState state) {
    switch (state) {
      case LetterState.absent:
        return 0;
      case LetterState.present:
        return 1;
      case LetterState.correct:
        return 2;
    }
  }

  /// Shows the game-over dialog with options to cancel or start over.
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Force the user to choose.
      builder: (BuildContext context) {
        return StartOver(
          onCancel: () {
            Navigator.of(context).pop();
          },
          onStartOver: () {
            Navigator.of(context).pop();
            _resetGame();
          },
        );
      },
    );
  }

  /// Resets the game board and state, and starts a new game.
  void _resetGame() {
    setState(() {
      board = List.generate(6, (_) => List.generate(5, (_) => ''));
      letterStatesBoard = List.generate(6, (_) => List.filled(5, null));
      _keyboardStates.clear();
      currentRow = 0;
      currentCol = 0;
      _notificationMessage = null;
      _isNotificationError = false;
      _gameOver = false;
    });
    _loadActiveGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              // Pass the _resetGame callback to the CustomAppBar:
              CustomAppBar(onResetGame: _resetGame),
              Expanded(
                child: WordleBoard(
                  board: board,
                  states: letterStatesBoard,
                ),
              ),
              WordleKeyboard(
                letterStates: _keyboardStates,
                onKeyPressed: onKeyPressed,
                disabled: _gameOver,
              ),
            ],
          ),
          if (_notificationMessage != null)
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.1),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: NotificationOverlay(
                    message: _notificationMessage!,
                    isError: _isNotificationError,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

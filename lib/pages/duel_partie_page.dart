import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Observer.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';

/// The gameplay screen for the Duel mode of Wordle.
///
/// The `DuelPartiePage` widget provides the gameplay layout for the Duel mode.
/// It utilizes the `Observer` state management to handle game logic and updates.
///
/// Features:
/// - Displays a grid for players to input guesses.
/// - Includes a virtual keyboard split into rows for player input.
/// - Dynamically updates the UI based on the `Observer` state.
///
/// Parameters:
/// - [wordLength]: The length of the word to guess.
/// - [attempts]: The maximum number of attempts allowed for each player.
class DuelPartiePage extends StatelessWidget {
  /// The length of the word to guess.
  final int wordLength;

  /// The maximum number of attempts allowed.
  final int attempts;

  /// Creates a `DuelPartiePage` widget.
  const DuelPartiePage({
    Key? key,
    required this.wordLength,
    required this.attempts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the existing Observer instance from the Provider.
    final observer = Provider.of<Observer>(context);

    return Column(
      children: [
        // Player Info Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAF3E0), // Soft Cream background
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Display current player
                Text(
                  observer.isPlayer1Turn ? 'Player 1\'s Turn' : 'Player 2\'s Turn',
                  style: const TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF6B8E23), // Olive Green
                  ),
                ),
                // Display scores
                Row(
                  children: [
                    _buildScoreDisplay(
                      label: 'P1',
                      score: observer.player1Score,
                      color: const Color(0xFF6B8E23),
                    ),
                    const SizedBox(width: 16),
                    _buildScoreDisplay(
                      label: 'P2',
                      score: observer.player2Score,
                      color: const Color(0xFFD2691E), // Orange-brown
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Grid Section
        Expanded(
          flex: 6,
          child: Container(
            color: Colors.white10,
            child: observer.currentRow < observer.maxAttempts // Ensure the player stays on the grid
                ? Grid(
              wordLength: wordLength,
              attempts: attempts,
            )
                : Center(
              child: Text(
                "Attempts exhausted! Waiting for the next turn.",
                style: const TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ),

        // Keyboard Section
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.white10,
            child: const Column(
              children: [
                Flexible(child: keyBoardRow(min: 1, max: 7)),
                Flexible(child: keyBoardRow(min: 8, max: 15)),
                Flexible(child: keyBoardRow(min: 16, max: 23)),
                Flexible(child: keyBoardRow(min: 24, max: 29)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreDisplay({
    required String label,
    required int score,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          score.toString(),
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}


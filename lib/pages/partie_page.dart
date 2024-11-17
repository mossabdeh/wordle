import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Observer.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';
import '../components/Partiedialogue.dart';

/// The game screen for Wordle, supporting both Classic and Survival modes.
///
/// The `PartiePage` widget dynamically adjusts its UI based on the game mode:
/// - **Classic Mode**: A standard Wordle gameplay with a fixed word length and attempts.
/// - **Survival Mode**: A progressive challenge with increasing word lengths and limited attempts.
///
/// This widget uses the `Observer` state manager for managing game logic and UI updates.
class PartiePage extends StatelessWidget {
  /// The length of the word to guess.
  final int wordLength;

  /// The maximum number of attempts allowed.
  final int attempts;

  /// Indicates if the game is in Survival Mode.
  final bool isSurvivalMode;

  /// Creates a `PartiePage` widget.
  ///
  /// Parameters:
  /// - [wordLength]: Length of the word to guess (required).
  /// - [attempts]: Maximum number of attempts (required).
  /// - [isSurvivalMode]: Whether the game is in Survival Mode (optional, default is `false`).
  const PartiePage({
    Key? key,
    required this.wordLength,
    required this.attempts,
    this.isSurvivalMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      /// Provides the `Observer` state to manage game logic.
      create: (_) => Observer(
        wordLength: wordLength,
        maxAttempts: attempts,
      )..isSurvivalMode = isSurvivalMode,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAF3E0),
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF6B8E23)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isSurvivalMode
                  ? Row(
                children: [
                  const Icon(Icons.shield, color: Color(0xFFD2691E), size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    "Survival Mode",
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF6B8E23),
                    ),
                  ),
                ],
              )
                  : const Text(
                "Wordle",
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF6B8E23),
                ),
              ),
              if (isSurvivalMode)
                Consumer<Observer>(
                  /// Displays the player's score in Survival Mode.
                  builder: (context, observer, child) {
                    return Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFD2691E), size: 24),
                        const SizedBox(width: 4),
                        Text(
                          "${observer.score}",
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF6B8E23),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline, color: Color(0xFF6B8E23)),
              onPressed: () {
                _showGameExplanationDialog(context, isSurvivalMode);
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFAF3E0), Color(0xFFDCE7C5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Consumer<Observer>(
            /// Builds the UI dynamically based on the game state.
            builder: (context, observer, child) {
              if (observer.loading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF6B8E23)),
                );
              }

              if (observer.hasWon) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showWinDialog(context, observer); // Show win dialog
                });
              }

              if (observer.hasLost) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showLossDialog(context, observer, observer.winningWord); // Show loss dialog
                });
              }

              return Column(
                children: [
                  if (isSurvivalMode)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      child: _buildSurvivalStats(observer),
                    ),
                  Expanded(
                    flex: 7,
                    child: Grid(
                      wordLength: observer.wordLength,
                      attempts: observer.maxAttempts,
                    ),
                  ),
                  const Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        keyBoardRow(min: 1, max: 7),
                        keyBoardRow(min: 8, max: 15),
                        keyBoardRow(min: 16, max: 23),
                        keyBoardRow(min: 24, max: 29),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds the Survival Mode stats card showing word length and attempts.
  Widget _buildSurvivalStats(Observer observer) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFE8F5E9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.text_snippet_outlined,
              label: "Word",
              value: "${observer.survivalWordLength} Letters",
              iconColor: const Color(0xFF6B8E23),
            ),
            _buildStatItem(
              icon: Icons.favorite_border,
              label: "Attempts",
              value: "${observer.survivalAttempts}",
              iconColor: const Color(0xFF6B8E23),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single stat item (e.g., Word Length, Attempts).
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 12, color: iconColor),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 8,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 8,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  /// Displays a game explanation dialog.
  void _showGameExplanationDialog(BuildContext context, bool isSurvivalMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: const Color(0xFFFAF3E0),
          title: const Center(
            child: Text(
              "Game Explanation",
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF6B8E23),
              ),
            ),
          ),
          content: Text(
            isSurvivalMode
                ? "In Survival Mode:\n\n- Guess words of increasing length.\n- Limited attempts for each word.\n- Progress through levels to score points."
                : "In Classic Mode:\n\n- Guess a fixed-length word.\n- Limited attempts.\n- Match letters to win.",
            style: const TextStyle(
              fontFamily: 'Raleway',
              fontSize: 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B8E23),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Got It!",
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

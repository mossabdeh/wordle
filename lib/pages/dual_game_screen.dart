import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Observer.dart';
import 'duel_partie_page.dart';

/// The main gameplay screen for Duel mode in the Wordle game.
///
/// The `DualGameScreen` widget allows two players to compete in a turn-based game.
/// It manages the gameplay rounds, secret word setting, and score tracking for both players.
///
/// Features:
/// - Allows each player to set a secret word for their opponent.
/// - Displays the gameplay grid and virtual keyboard for guessing.
/// - Shows the game-over screen with scores and the winner.
///
/// Parameters:
/// - [rounds]: Total number of rounds in the duel.
/// - [attempts]: Maximum attempts per round.
/// - [wordLength]: Length of the word to guess in each round.
class DualGameScreen extends StatefulWidget {
  /// Total number of rounds in the duel.
  final int rounds;

  /// Maximum attempts per round.
  final int attempts;

  /// Length of the word to guess in each round.
  final int wordLength;

  /// Creates a `DualGameScreen` widget.
  const DualGameScreen({
    super.key,
    required this.rounds,
    required this.attempts,
    required this.wordLength,
  });

  @override
  _DualGameScreenState createState() => _DualGameScreenState();
}

class _DualGameScreenState extends State<DualGameScreen> {
  /// Controller for managing the secret word input.
  final TextEditingController _secretWordController = TextEditingController();

  @override
  void dispose() {
    _secretWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      /// Provides the `Observer` state manager for game logic and UI updates.
      create: (_) => Observer(
        wordLength: widget.wordLength,
        maxAttempts: widget.attempts,
        isDuelMode: true,
        rounds: widget.rounds,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80), // Adjusted AppBar size
          child: AppBar(
            title: const Text(
              'Duel Mode',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Color(0xFF6B8E23), // Olive Green
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFFFAF3E0), // Soft Cream
            elevation: 0,
            iconTheme: const IconThemeData(color: Color(0xFF6B8E23)),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFAF3E0), Color(0xFFDCE7C5)], // Subtle gradient
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Consumer<Observer>(
            /// Dynamically updates the UI based on the game state.
            builder: (context, observer, child) {
              if (observer.isGameOver()) {
                return _buildGameOverScreen(observer);
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Round ${observer.currentRound} of ${observer.totalRounds}",
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF6B8E23), // Olive Green
                      ),
                    ),
                  ),
                  Expanded(
                    /// Displays either the secret word input screen or the guessing screen.
                    child: observer.isSettingSecretWord
                        ? _buildSecretWordInput(observer)
                        : DuelPartiePage(
                      key: ValueKey(
                          "Round-${observer.currentRound}-${observer.isPlayer1Turn}"), // Unique key for each turn
                      wordLength: widget.wordLength,
                      attempts: widget.attempts,
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

  /// Builds the UI for players to set a secret word for their opponent.
  Widget _buildSecretWordInput(Observer observer) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            observer.isPlayer1Turn
                ? "Player 1: Set a Secret Word for Player 2 (Length: ${widget.wordLength})"
                : "Player 2: Set a Secret Word for Player 1 (Length: ${widget.wordLength})",
            style: const TextStyle(
              fontFamily: 'Raleway',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B8E23), // Olive Green
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _secretWordController,
            inputFormatters: [
              UpperCaseTextInputFormatter(),
              LengthLimitingTextInputFormatter(widget.wordLength),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE8F5E9), // Light Green background
              hintText: "Enter secret word",
              hintStyle: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16,
                color: Colors.black54,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6B8E23), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6B8E23), width: 2.5),
              ),
            ),
            style: const TextStyle(
              fontFamily: 'Raleway',
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B8E23), // Olive Green
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              if (_secretWordController.text.length == widget.wordLength) {
                observer.setSecretWordForOpponent(_secretWordController.text);
                print("Secret Word Set: ${_secretWordController.text}");
                _secretWordController.clear();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFFD2691E), // Brown accent
                    content: Text(
                      'Please enter a word with exactly ${widget.wordLength} letters.',
                      style: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }
            },
            child: const Text(
              "Set Secret Word",
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the game-over screen showing the final scores and winner.
  Widget _buildGameOverScreen(Observer observer) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "🏆 Game Over!",
            style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color(0xFFD2691E), // Brown accent
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Player 1 Score: ${observer.player1Score}",
            style: const TextStyle(
              fontFamily: 'Raleway',
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          Text(
            "Player 2 Score: ${observer.player2Score}",
            style: const TextStyle(
              fontFamily: 'Raleway',
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            observer.player1Score > observer.player2Score
                ? "Player 1 Wins! 🎉"
                : observer.player2Score > observer.player1Score
                ? "Player 2 Wins! 🎉"
                : "It's a Tie! 🤝",
            style: const TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xFF6B8E23), // Olive Green
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B8E23), // Olive Green
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Back to Menu",
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

/// A custom `TextInputFormatter` to convert input text to uppercase.
class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

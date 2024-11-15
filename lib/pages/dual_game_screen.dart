import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../Observer.dart';
import 'duel_partie_page.dart';

class DualGameScreen extends StatefulWidget {
  final int rounds;
  final int attempts;
  final int wordLength;

  const DualGameScreen({
    Key? key,
    required this.rounds,
    required this.attempts,
    required this.wordLength,
  }) : super(key: key);

  @override
  _DualGameScreenState createState() => _DualGameScreenState();
}

class _DualGameScreenState extends State<DualGameScreen> {
  final TextEditingController _secretWordController = TextEditingController();

  @override
  void dispose() {
    _secretWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Observer(
        wordLength: widget.wordLength,
        maxAttempts: widget.attempts,
        isDuelMode: true,
        rounds: widget.rounds,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Duel Mode'),
        ),
        body: Consumer<Observer>(
          builder: (context, observer, child) {
            if (observer.isGameOver()) {
              return _buildGameOverScreen(observer);
            }

            // Show secret word input or guessing page based on the state
            return observer.isSettingSecretWord
                ? _buildSecretWordInput(observer)
                : DuelPartiePage(
              key: ValueKey("Round-${observer.currentRound}-${observer.isPlayer1Turn}"), // Unique key for each turn
              wordLength: widget.wordLength,
              attempts: widget.attempts,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSecretWordInput(Observer observer) {
    return Column(
      children: [
        Text(
          observer.isPlayer1Turn
              ? "Player 1: Set a Secret Word for Player 2 (Length: ${widget.wordLength})"
              : "Player 2: Set a Secret Word for Player 1 (Length: ${widget.wordLength})",
          style: TextStyle(fontSize: 16),
        ),
        TextField(
          controller: _secretWordController,
          inputFormatters: [
            UpperCaseTextInputFormatter(),
            LengthLimitingTextInputFormatter(widget.wordLength),
          ],
          decoration: const InputDecoration(hintText: "Enter secret word"),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            if (_secretWordController.text.length == widget.wordLength) {
              observer.setSecretWordForOpponent(_secretWordController.text);
              print("Secret Word Set: ${_secretWordController.text}");
              _secretWordController.clear();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please enter a word with exactly ${widget.wordLength} letters.')),
              );
            }
          },
          child: const Text("Set Secret Word"),
        ),
      ],
    );
  }

  Widget _buildGameOverScreen(Observer observer) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Game Over!", style: TextStyle(fontSize: 24)),
          Text("Player 1 Score: ${observer.player1Score}"),
          Text("Player 2 Score: ${observer.player2Score}"),
          Text(
            observer.player1Score > observer.player2Score
                ? "Player 1 Wins!"
                : observer.player2Score > observer.player1Score
                ? "Player 2 Wins!"
                : "It's a Tie!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Back to Menu"),
          ),
        ],
      ),
    );
  }
}




// Custom TextInputFormatter to convert input to uppercase
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

import 'package:flutter/material.dart';

void showWinDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Congratulations!"),
        content: const Text("You've guessed the word!"),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              // Reset the game or take other actions if needed
            },
          ),
        ],
      );
    },
  );
}

void showLossDialog(BuildContext context, String winningWord) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Game Over"),
        content: Text("You've used all attempts. The word was: $winningWord."),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              // Reset the game or take other actions if needed
            },
          ),
        ],
      );
    },
  );
}

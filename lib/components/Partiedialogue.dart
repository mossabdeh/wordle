import 'package:flutter/material.dart';
import 'package:wordle/Observer.dart';

void showWinDialog(BuildContext context, Observer observer) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Congratulations!"),
        content: Text("You've guessed the word!"),
        actions: [
          TextButton(
            child: Text("Restart"),
            onPressed: () {
              observer.resetGame(); // Use the passed observer instance to reset the game
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showLossDialog(BuildContext context, Observer observer, String winningWord) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Game Over"),
        content: Text("You've used all attempts. The word was: $winningWord."),
        actions: [
          TextButton(
            child: Text("Restart"),
            onPressed: () {
              observer.resetGame(); // Use the passed observer instance to reset the game
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

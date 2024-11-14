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
              observer.resetGame(); // Classic reset
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: Text("OK"),
            onPressed: () {
              if (observer.isSurvivalMode) {
                observer.incrementSurvivalLevel(); // Start the next level in Survival Mode
              } else {
                observer.resetGame(); // Classic Mode reset
              }
              Navigator.of(context).pop(); // Close the dialog
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
              observer.resetGame(); // Reset game in either mode
              Navigator.of(context).pop(); // Close dialog
            },
          ),
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
          ),
        ],
      );
    },
  );
}


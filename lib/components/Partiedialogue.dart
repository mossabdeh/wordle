import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Observer.dart';

void showWinDialog(BuildContext context) {
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
              Provider.of<Observer>(context, listen: false).resetGame();
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

void showLossDialog(BuildContext context, String winningWord) {
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
              Provider.of<Observer>(context, listen: false).resetGame();
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

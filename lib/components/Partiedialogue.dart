import 'package:flutter/material.dart';
import 'package:wordle/Observer.dart';

void showWinDialog(BuildContext context, Observer observer) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        backgroundColor: const Color(0xFFFAF3E0), // Soft Cream background
        title: const Center(
          child: Text(
            "🎉 Congratulations!",
            style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Color(0xFF6B8E23), // Olive Green
            ),
          ),
        ),
        content: const Text(
          "You've guessed the word correctly!",
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 16,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly, // Center-align buttons
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B8E23), // Olive Green
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              observer.resetGame(); // Classic reset
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              "Restart",
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E7C86), // Accent color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              if (observer.isSurvivalMode) {
                observer.incrementSurvivalLevel(); // Start the next level in Survival Mode
              } else {
                observer.resetGame(); // Classic Mode reset
              }
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text(
              "Next Level",
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        backgroundColor: const Color(0xFFFAF3E0), // Soft Cream background
        title: const Center(
          child: Text(
            "💔 Game Over",
            style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Color(0xFFD2691E), // Brown accent for emphasis
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "You've used all attempts.",
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16), // Space before the correct word section
            const Text(
              "The correct word was:",
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8), // Space before the word box
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF6B8E23), // Olive Green background
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Text(
                winningWord.toUpperCase(), // Display word in uppercase for emphasis
                style: const TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white, // White text for contrast
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16), // Space before the buttons
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly, // Center-align buttons
        actions: [
          // Restart Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B8E23), // Olive Green
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              observer.resetGame(); // Reset game in either mode
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text(
              "Restart",
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // OK Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, // White background for OK button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF6B8E23), width: 2), // Olive Green border
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text(
              "OK",
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF6B8E23), // Olive Green text color
              ),
            ),
          ),
        ],
      );
    },
  );
}






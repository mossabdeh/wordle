import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wordle/constants/letterState.dart';
import 'package:wordle/entities/letter.dart';
import 'package:wordle/services/loadJson.dart';

import 'constants/keyboard.dart';
import 'constants/letterValue.dart';

class Observer extends ChangeNotifier {
  int currentNode = 0;
  int currentRow = 0;
  List<Letter> letterTaped = [];
  late String winningWord;

  Observer() {
    _setWinningWord(); // Initialize the winning word when Observer is created
  }

  // Method to asynchronously fetch the winning word
  Future<void> _setWinningWord() async {
    final word = await getRandomWord(); // Assume getRandomWord is implemented elsewhere
    if (word != null) {
      winningWord = word;
      print(winningWord);
    } else {
      winningWord = "apple"; // Default word if no 5-letter word is found
      print("No 5-letter word found, using default.");
    }
    notifyListeners();
  }

  // Method to handle key input
  void setKeyTapped({required String value}) {
    if (value == 'ENTER') {
      // Only check if 5 letters have been entered in the current row
      if (currentNode == 5 * (currentRow + 1)) {
        _checkGuess();
        currentRow++; // Move to the next row after checking the guess
      }
    } else if (value == 'DEL') {
      if (currentNode > 5 * (currentRow + 1) - 5) {
        currentNode--;
        letterTaped.removeLast();
      }
    } else {
      if (currentNode < 5 * (currentRow + 1)) {
        letterTaped.add(Letter(char: value, status: LetterState.untouched));
        currentNode++;
      }
    }
    notifyListeners();
  }

  // Method to check the guessed word
  void _checkGuess() {
    // Collect the letters entered in the current row
    final guessedWord = letterTaped
        .skip(currentRow * 5)
        .take(5)
        .map((letter) => letter.char)
        .join();

    if (guessedWord == winningWord) {
      print("Congratulations! You've guessed the word.");
    } else {
      print("Try again!");
      _updateLetterStatus(guessedWord);
      currentRow++;
    }
  }

  // Update the letter statuses based on the winning word
  void _updateLetterStatus(String guessedWord) {
    for (int i = 0; i < guessedWord.length; i++) {
      // Find the matching LetterValue for each guessed character
      final letterValue = LetterValue.values.firstWhere(
            (e) => e.displayName == guessedWord[i].toUpperCase(),
      );
      if (guessedWord[i] == winningWord[i]) {
        letterTaped[currentRow * 5 + i].status = LetterState.correct;
        keyboardState[letterValue] = LetterState.correct;
      } else if (winningWord.contains(guessedWord[i])) {
        letterTaped[currentRow * 5 + i].status = LetterState.contains;
        if (keyboardState[letterValue] != LetterState.correct) {
          keyboardState[letterValue] = LetterState.contains;
        }
      } else {
        letterTaped[currentRow * 5 + i].status = LetterState.incorrect;
        if (keyboardState[letterValue] != LetterState.correct &&
            keyboardState[letterValue] != LetterState.contains) {
          keyboardState[letterValue] = LetterState.incorrect;
        }
      }
    }
  }


}

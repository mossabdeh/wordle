import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wordle/constants/letterState.dart';
import 'package:wordle/entities/letter.dart';
import 'package:wordle/services/loadJson.dart';
import 'components/Partiedialogue.dart';
import 'constants/keyboard.dart';
import 'constants/letterValue.dart';

class Observer extends ChangeNotifier {
  int currentNode = 0;
  int currentRow = 0;
  List<Letter> letterTaped = [];
  late String winningWord;
  bool loading = true;
  bool hasWon = false;
  bool hasLost = false;

  Observer() {
    _setWinningWord();
  }

  /* methode to reset the game */
  void resetGame() {
    currentNode = 0;
    currentRow = 0;
    letterTaped.clear();
    hasWon = false;
    hasLost = false;
    loading = true;
    // Fetch a new winning word and notify listeners when done
    _setWinningWord();
  }

  Future<void> _setWinningWord() async {
    final word = await getRandomWord();
    if (word != null) {
      winningWord = word.toUpperCase();
      print("Winning word selected: $winningWord");
    } else {
      winningWord = "APPLE";
      print("No 5-letter word found, using default: $winningWord.");
    }
    loading = false;
    notifyListeners();
  }

  void setKeyTapped({required String value}) {
    if (value == 'ENTER') {
      if (currentNode == 5 * (currentRow + 1)) {
        _checkGuess();
      }
    } else if (value == 'DEL') {
      if (currentNode > 5 * currentRow) {
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

  void _checkGuess() {
    final guessedWord = letterTaped
        .skip(currentRow * 5)
        .take(5)
        .map((letter) => letter.char)
        .join();

    if (guessedWord == winningWord) {
      for (int i = 0; i < guessedWord.length; i++) {
        final index = currentRow * 5 + i;
        letterTaped[index].status = LetterState.correct;
        keyboardState[LetterValue.fromChar(guessedWord[i]) ?? LetterValue.A] = LetterState.correct;
      }
      hasWon = true;
      notifyListeners();
      return;
    }

    for (int i = 0; i < guessedWord.length; i++) {
      final guessedLetter = guessedWord[i];
      final index = currentRow * 5 + i;

      if (winningWord.contains(guessedLetter)) {
        letterTaped[index].status = guessedLetter == winningWord[i] ? LetterState.correct : LetterState.contains;
        keyboardState[LetterValue.fromChar(guessedLetter) ?? LetterValue.A] = letterTaped[index].status;
      } else {
        letterTaped[index].status = LetterState.incorrect;
        keyboardState[LetterValue.fromChar(guessedLetter) ?? LetterValue.A] = LetterState.incorrect;
      }
    }

    currentRow++;
    if (currentRow >= 6) {
      hasLost = true;
    }
    notifyListeners();
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wordle/constants/letterState.dart';
import 'package:wordle/entities/letter.dart';
import 'package:wordle/services/loadJson.dart';
import 'constants/keyboard.dart';
import 'constants/letterValue.dart';
import 'dao/partie_dao.dart';
import 'entities/partie.dart';

class Observer extends ChangeNotifier {
  final PartieDAO _partieDAO = PartieDAO(); // Instance of PartieDAO
  int currentNode = 0;
  int currentRow = 0;
  List<Letter> letterTaped = [];
  late String winningWord;
  bool loading = true;
  bool hasWon = false;
  bool hasLost = false;
  int maxAttempts;
  int wordLength;

  /* Method to reset the game */
  void resetGame() {
    currentNode = 0;
    currentRow = 0;
    letterTaped.clear();
    hasWon = false;
    hasLost = false;
    loading = true;

    // Re-fetch a new winning word with the current wordLength setting
    _setWinningWord();
  }


  Observer({required this.wordLength, required this.maxAttempts}) {
    _setWinningWord();
  }

  Future<void> _setWinningWord() async {
    final word = await getRandomWord(wordLength: wordLength);
    if (word != null) {
      winningWord = word.toUpperCase();
      print("Winning word selected: $winningWord");
    } else {
      winningWord = "APPLE";
      print("No $wordLength-letter word found, using default: $winningWord.");
    }
    loading = false;
    notifyListeners();
  }

  void setKeyTapped({required String value}) {
    if (value == 'ENTER') {
      if (currentNode == wordLength * (currentRow + 1)) {
        _checkGuess();
      }
    } else if (value == 'DEL') {
      if (currentNode > wordLength * currentRow) {
        currentNode--;
        letterTaped.removeLast();
      }
    } else {
      if (currentNode < wordLength * (currentRow + 1)) {
        letterTaped.add(Letter(char: value, status: LetterState.untouched));
        currentNode++;
      }
    }
    notifyListeners();
  }

  void _checkGuess() {
    // Collect the guessed word for the current row
    final guessedWord = letterTaped
        .skip(currentRow * wordLength)
        .take(wordLength)
        .map((letter) => letter.char)
        .join();

    print("Guessed Word: $guessedWord, Winning Word: $winningWord"); // Debugging log

    // Check if the guessed word matches the winning word
    if (guessedWord == winningWord) {
      for (int i = 0; i < guessedWord.length; i++) {
        final index = currentRow * wordLength + i;
        letterTaped[index].status = LetterState.correct;
        keyboardState[LetterValue.fromChar(guessedWord[i]) ?? LetterValue.A] =
            LetterState.correct;
      }
      hasWon = true;
      print("Player won the game."); // Debugging log
    } else {
      // Update the colors for each letter based on the winning word
      for (int i = 0; i < guessedWord.length; i++) {
        final guessedLetter = guessedWord[i];
        final index = currentRow * wordLength + i;

        if (winningWord.contains(guessedLetter)) {
          letterTaped[index].status =
          guessedLetter == winningWord[i] ? LetterState.correct : LetterState.contains;
          keyboardState[LetterValue.fromChar(guessedLetter) ?? LetterValue.A] =
              letterTaped[index].status;
        } else {
          letterTaped[index].status = LetterState.incorrect;
          keyboardState[LetterValue.fromChar(guessedLetter) ?? LetterValue.A] =
              LetterState.incorrect;
        }
      }

      // Move to the next row and check for game over
      currentRow++;
      if (currentRow >= maxAttempts) {
        hasLost = true;
        print("Player lost the game."); // Debugging log
      }
    }

    // Check if game is won or lost, and save the game result
    if (hasWon || hasLost) {
      print("Saving completed game. hasWon: $hasWon, hasLost: $hasLost"); // Debugging log
      saveCompletedGame(hasWon);
    }

    notifyListeners();
  }



  // Call this when the game is completed

  Future<void> saveCompletedGame(bool won) async {
    try {
      print('Starting saveCompletedGame...');

      // Log game details
      print('Game details:');
      print('Winning Word: $winningWord');
      print('Date: ${DateTime.now()}');
      print('Attempts: $currentRow');
      print('Guessed Letters: ${letterTaped.map((e) => e.char).join()}');
      print('Game Mode: Classic');
      print('Word Length: $wordLength');

      final partie = PartieEntity(
        secretWord: winningWord,
        date: DateTime.now(),
        attempts: currentRow,
        guessedLetters: letterTaped.map((e) => e.char).join(),
        gameMode: 'Classic',
        wordLength: wordLength,
      );

      print('Attempting to insert PartieEntity into database...');
      final result = await _partieDAO.insertPartie(partie);

      if (result != -1) {
        print('Game saved to database successfully with id: $result');
      } else {
        print('Failed to save game to database');
      }
    } catch (e) {
      print('Error occurred while saving game to database: $e');
    }
  }


}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wordle/constants/letterState.dart';
import 'package:wordle/entities/letter.dart';
import 'package:wordle/services/loadJson.dart';
import 'dao/partie_dao.dart';
import 'entities/partie.dart';

class Observer extends ChangeNotifier {
  final PartieDAO _partieDAO = PartieDAO();
  int currentNode = 0;
  int currentRow = 0;
  List<Letter> letterTaped = [];
  late String winningWord;
  bool loading = true;
  bool hasWon = false;
  bool hasLost = false;
  int maxAttempts;
  int wordLength;

  // Survival Mode attributes
  int survivalWordLength = 3;
  int survivalAttempts = 10;
  int consecutiveCorrectGuesses = 0;
  int score = 0;
  bool isSurvivalMode = false;

  Observer({required this.wordLength, required this.maxAttempts, this.isSurvivalMode = false}) {
    print("Observer initialized with wordLength: $wordLength, maxAttempts: $maxAttempts, isSurvivalMode: $isSurvivalMode");
    if (isSurvivalMode) {
      startSurvivalMode();
    } else {
      _setWinningWord();
    }
  }

  // Initialize Survival Mode
  void startSurvivalMode() {
    print("Starting Survival Mode");
    isSurvivalMode = true;
    resetSurvivalGame();
  }

  // Start or reset survival mode attributes
  void resetSurvivalGame() {
    survivalWordLength = 3;
    survivalAttempts = 10;
    consecutiveCorrectGuesses = 0;
    score = 0;
    hasLost = false;
    wordLength = survivalWordLength;
    maxAttempts = survivalAttempts;
    _setNewSurvivalWord();
    notifyListeners();
  }

  // Set a new word for Survival Mode
  Future<void> _setNewSurvivalWord() async {
    final word = await getRandomWord(wordLength: survivalWordLength);
    winningWord = word?.toUpperCase() ?? "APPLE";
    loading = false;
    notifyListeners();
  }

  // Set a new word for Classic Mode
  Future<void> _setWinningWord() async {
    final word = await getRandomWord(wordLength: wordLength);
    winningWord = word?.toUpperCase() ?? "APPLE";
    loading = false;
    notifyListeners();
  }

  // Reset game based on the mode
  void resetGame() {
    if (isSurvivalMode) {
      resetSurvivalGame();
    } else {
      _resetClassicGame();
    }
    notifyListeners();
  }

  // Classic Mode game reset
  void _resetClassicGame() {
    currentNode = 0;
    currentRow = 0;
    letterTaped.clear();
    hasWon = false;
    hasLost = false;
    loading = true;
    _setWinningWord();
  }

  // Handle key taps for both modes
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

  // Check guess and determine win or loss
  void _checkGuess() {
    final guessedWord = letterTaped
        .skip(currentRow * wordLength)
        .take(wordLength)
        .map((letter) => letter.char)
        .join();

    print("Guessed Word: $guessedWord, Winning Word: $winningWord");

    if (guessedWord == winningWord) {
      print("Word guessed correctly");
      _markWin();
      if (isSurvivalMode) {
        incrementSurvivalLevel();
      }
    } else {
      print("Incorrect guess: $guessedWord");
      _markIncorrect(guessedWord);
    }

    if (hasWon || hasLost) {
      saveCompletedGame(hasWon);
    }

    notifyListeners();
  }

  // Mark win for both modes
  void _markWin() {
    for (int i = 0; i < winningWord.length; i++) {
      final index = currentRow * wordLength + i;
      letterTaped[index].status = LetterState.correct;
    }
    hasWon = true;
  }

  // Mark incorrect guesses
  void _markIncorrect(String guessedWord) {
    for (int i = 0; i < guessedWord.length; i++) {
      final guessedLetter = guessedWord[i];
      final index = currentRow * wordLength + i;

      if (winningWord.contains(guessedLetter)) {
        letterTaped[index].status = guessedLetter == winningWord[i]
            ? LetterState.correct
            : LetterState.contains;
      } else {
        letterTaped[index].status = LetterState.incorrect;
      }
    }

    currentRow++;
    if (currentRow >= maxAttempts) {
      hasLost = true;
    }
  }

  // Increment survival level for Survival Mode
  void incrementSurvivalLevel() {
    if (isSurvivalMode) {
      print("Survival Mode - incrementing level");
      score++;  // Increase the score for each correct guess
      consecutiveCorrectGuesses++;

      if (consecutiveCorrectGuesses >= (wordLength ~/ 2)) {
        survivalWordLength++;  // Increase the word length
        consecutiveCorrectGuesses = 0;  // Reset consecutive correct guesses

        // Reduce attempts with each word length increment, with a minimum of 3 attempts
        survivalAttempts = (survivalAttempts > 3) ? survivalAttempts - 1 : 3;
      }

      // Update the current game settings to reflect the new survival values
      wordLength = survivalWordLength;
      maxAttempts = survivalAttempts;

      // Set a new word for the next level and reset the game state for the grid
      _setNewSurvivalWord();  // Generate a new winning word based on the new word length
      resetSurvivalGrid();  // Clear the board for the new level

      // Log the updated settings to confirm
      print("New word length: $wordLength, New attempts: $maxAttempts, New winning word: $winningWord");
      notifyListeners();  // Notify UI to update with the new values
    } else {
      print("Not in Survival Mode");
    }
  }


  // Helper method to reset the grid state in Survival Mode
  void resetSurvivalGrid() {
    print("Resetting grid state for new level in Survival Mode");
    currentNode = 0;
    currentRow = 0;
    letterTaped.clear();
    hasWon = false;
    hasLost = false;
    loading = false;
  }

  // Save completed game
  Future<void> saveCompletedGame(bool won) async {
    try {
      final partie = PartieEntity(
        secretWord: winningWord,
        date: DateTime.now(),
        attempts: currentRow,
        guessedLetters: letterTaped.map((e) => e.char).join(),
        gameMode: isSurvivalMode ? 'Survival' : 'Classic',
        wordLength: wordLength,
      );

      await _partieDAO.insertPartie(partie);
    } catch (e) {
      print('Error saving game: $e');
    }
  }

  Future<List<PartieEntity>> getParties() async {
    return await _partieDAO.getParties();
  }

  Future<int> get totalGamesPlayed async {
    final games = await _partieDAO.getParties();
    return games.length;
  }

  Future<double> get winPercentage async {
    final games = await _partieDAO.getParties();
    final wonGames = games.where((partie) => partie.attempts <= maxAttempts).length;
    return (wonGames / games.length) * 100;
  }

  Future<double> get averageAttempts async {
    final games = await _partieDAO.getParties();
    if (games.isEmpty) return 0.0;

    final totalPercentage = games.fold(0.0, (sum, partie) {
      final attemptsPercentage = (partie.attempts / maxAttempts) * 100;
      return sum + attemptsPercentage;
    });

    return totalPercentage / games.length;
  }
}

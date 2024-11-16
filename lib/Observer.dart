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

  /* Duel Mode attributes */
  bool isDuelMode = false;
  int totalRounds = 0;
  int currentRound = 1;
  int player1Score = 0;
  int player2Score = 0;
  bool isPlayer1Turn = true;
  String? player1SecretWord;
  String? player2SecretWord;
  bool isSettingSecretWord = true; // Default to true for the first player
  bool isPlayer1GuessedCorrectly = false;
  bool isPlayer2GuessedCorrectly = false;


  Observer({
    required this.wordLength,
    required this.maxAttempts,
    this.isSurvivalMode = false,
    this.isDuelMode = false,
    int? rounds,  // Optional parameter for duel mode
  }) {
    print("àààààààààààààààààààààààààààààà   $isDuelMode");
    if (isSurvivalMode) {
      startSurvivalMode();
    } else if (isDuelMode) {
      if (rounds != null) {
        startDuelMode(rounds: rounds,wordLength: wordLength,attempts: maxAttempts);  // Start duel mode with specified rounds
      } else {
        print("Error: Duel mode requires a number of rounds.");
      }
    } else {
      _setWinningWord();
    }
  }

 /* Survie Mode  */

  void startDuelMode({required int rounds, required int attempts, required int wordLength}) {
    print("Starting Duel Mode with $rounds rounds, $attempts attempts, and word length of $wordLength");

    isDuelMode = true;
    totalRounds = rounds;
    maxAttempts = attempts;
    this.wordLength = wordLength;
    player1Score = 0;
    player2Score = 0;
    currentRound = 1;
    isPlayer1Turn = true;

    // Ensure words are null initially to avoid confusion
    player1SecretWord = null;
    player2SecretWord = null;

    resetGameForNextTurn();
  }
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
    print("worrrrrrrrrrrrrrrd $word" );
    winningWord = word?.toUpperCase() ?? "APPLE";
    loading = false;
    notifyListeners();
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





  // Set a new word for Classic Mode
  Future<void> _setWinningWord() async {
    final word = await getRandomWord(wordLength: wordLength);
    print("classic word '''''''''''' $word");
    winningWord = word?.toUpperCase() ?? "APPLE"; // Default to "APPLE" if no word is retrieved
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
        if (isDuelMode) {
          _checkGuessDuel(); // Call Duel Mode-specific logic
        } else {
          _checkGuess(); // Call Classic/Survival logic
        }
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

  // Update score for the current player
  void _updateScore() {
    if (isPlayer1Turn) {
      player1Score++;
    } else {
      player2Score++;
    }
  }

  // Proceed to the next turn in Duel Mode
  void _proceedToNextTurn() {
    _updateScore();

    if (currentRound < totalRounds) {
      if (!isPlayer1Turn) {
        currentRound++;
      }
      isPlayer1Turn = !isPlayer1Turn;  // Alternate turns
      resetGameForNextTurn();
    } else {
      print("Duel Mode ended. Player 1 Score: $player1Score, Player 2 Score: $player2Score");
      isDuelMode = false; // End Duel Mode
      notifyListeners();  // Notify to handle end game UI update
    }
  }

  // Check guess and determine win or loss
  void _checkGuess() {
    final guessedWord = letterTaped
        .skip(currentRow * wordLength)
        .take(wordLength)
        .map((letter) => letter.char)
        .join();

    print("Classic/Survival Mode - Guessed Word: $guessedWord, Winning Word: $winningWord");

    if (winningWord == null || winningWord.isEmpty) {
      print("Error: Winning word is not set.");
      return;
    }

    if (guessedWord == winningWord) {
      print("Word guessed correctly in Classic/Survival Mode!");
      _markWin(winningWord!); // Mark as win
      if (isSurvivalMode) {
        incrementSurvivalLevel(); // Proceed to the next level in Survival mode
      }
    } else {
      print("Incorrect guess in Classic/Survival Mode: $guessedWord");
      _markIncorrect(guessedWord, winningWord!); // Mark incorrect guesses
      if (currentRow >= maxAttempts) {
        hasLost = true; // Mark as lost if out of attempts
      }
    }

    if (hasWon || hasLost) {
      saveCompletedGame(hasWon); // Save the game state
    }

    notifyListeners(); // Notify UI of changes
  }


  void resetGameForNextTurn() {
    currentNode = 0;
    currentRow = 0;
    letterTaped.clear();
    hasWon = false;
    hasLost = false;
    loading = false; // No need to load a new word in Duel Mode
    notifyListeners();
  }





  // Mark win for both modes
  void _markWin(String targetWord) {
    for (int i = 0; i < targetWord.length; i++) {
      final index = currentRow * wordLength + i;
      letterTaped[index].status = LetterState.correct; // Mark all letters as correct
    }
    hasWon = true; // Mark the game as won
  }



  // Mark incorrect guesses
  void _markIncorrect(String guessedWord, String targetWord) {
    for (int i = 0; i < guessedWord.length; i++) {
      final guessedLetter = guessedWord[i];
      final index = currentRow * wordLength + i;

      // Check if the guessed letter is in the target word
      if (targetWord.contains(guessedLetter)) {
        letterTaped[index].status = guessedLetter == targetWord[i]
            ? LetterState.correct
            : LetterState.contains; // Mark as correct or contains
      } else {
        letterTaped[index].status = LetterState.incorrect; // Mark as incorrect
      }
    }

    // Increment the row after the guess
    currentRow++;
    if (currentRow >= maxAttempts) {
      hasLost = true; // Mark as lost if attempts are exhausted
      if (isDuelMode) {
        _proceedToNextTurn(); // Handle next turn in Duel Mode
      }
    }
  }




  // Save completed game
  Future<void> saveCompletedGame(bool won) async {
    try {
      final partie = PartieEntity(
        secretWord: winningWord,
        date: DateTime.now(),
        attempts: currentRow,
        guessedLetters: letterTaped.map((e) => e.char).join(),
        gameMode: isSurvivalMode ? 'Survival' : isDuelMode ? 'Duel' : 'Classic',
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

  void setSecretWordForOpponent(String word) {
    if (isPlayer1Turn) {
      player2SecretWord = word; // Player 1 sets the word for Player 2
      print("Player 1 set secret word for Player 2: $player2SecretWord");
    } else {
      player1SecretWord = word; // Player 2 sets the word for Player 1
      print("Player 2 set secret word for Player 1: $player1SecretWord");
    }
    isSettingSecretWord = false; // Toggle off after setting the word
    notifyListeners();
  }


  void submitGuess(String guess) {
    if (isPlayer1Turn) {
      // Evaluate Player 2's secret word
      bool correct = evaluateGuess(player2SecretWord!, guess);
      if (correct) {
        player1Score++;
        print("Player 1 guessed correctly!");
      }
    } else {
      // Evaluate Player 1's secret word
      bool correct = evaluateGuess(player1SecretWord!, guess);
      if (correct) {
        player2Score++;
        print("Player 2 guessed correctly!");
      }
    }
    _proceedToNextTurn();
    notifyListeners();
  }


  void switchTurn() {
    isPlayer1Turn = !isPlayer1Turn;
    if (!isPlayer1Turn) currentRound++;
  }

  bool evaluateGuess(String secretWord, String guess) {
    return secretWord == guess;
  }

  bool isGameOver() {
    return currentRound > totalRounds;
  }

  void transitionToNextTurn() {
    if (!isPlayer1Turn) {
      // Check round results when both players have taken their turns
      if (isPlayer1GuessedCorrectly && isPlayer2GuessedCorrectly) {
        print("Both players guessed correctly. Adding another round.");
        currentRound++;
      } else if (!isPlayer1GuessedCorrectly && !isPlayer2GuessedCorrectly) {
        print("Both players failed. This round is a tie.");
      } else {
        final winner = isPlayer1GuessedCorrectly ? "Player 1" : "Player 2";
        print("$winner wins this round.");
        if (isPlayer1GuessedCorrectly) player1Score++;
        if (isPlayer2GuessedCorrectly) player2Score++;
      }

      // Reset round results for the next round
      isPlayer1GuessedCorrectly = false;
      isPlayer2GuessedCorrectly = false;

      // Check for game over
      if (currentRound > totalRounds) {
        print("Game over!");
        notifyListeners();
        return;
      }
    }

    // Toggle player turns
    isPlayer1Turn = !isPlayer1Turn;
    isSettingSecretWord = true; // Prompt the next player to set the secret word

    // Reset the state for the next turn
    resetGameForNextTurn();

    notifyListeners();
  }


  void _checkGuessDuel() {
    final guessedWord = letterTaped
        .skip(currentRow * wordLength)
        .take(wordLength)
        .map((letter) => letter.char)
        .join();

    // Use the correct secret word for the current player's opponent
    String? targetWord = isPlayer1Turn ? player2SecretWord : player1SecretWord;

    print("Duel Mode - Guessed Word: $guessedWord, Target Word: $targetWord");

    if (targetWord == null || targetWord.isEmpty) {
      print("Error: Target word is not set for the current turn.");
      return; // Exit the method if the target word is not set
    }

    if (guessedWord == targetWord) {
      print("Word guessed correctly in Duel Mode!");
      _markWin(targetWord); // Mark as win
      if (isPlayer1Turn) {
        isPlayer1GuessedCorrectly = true;
      } else {
        isPlayer2GuessedCorrectly = true;
      }
      transitionToNextTurn(); // Move to the next turn
    } else {
      print("Incorrect guess in Duel Mode: $guessedWord");
      _markIncorrect(guessedWord, targetWord); // Mark incorrect letters
      if (currentRow >= maxAttempts) {
        transitionToNextTurn(); // Proceed to the next turn if out of attempts
      }
    }

    notifyListeners(); // Notify UI of changes
  }





}
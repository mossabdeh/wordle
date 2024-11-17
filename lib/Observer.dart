import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wordle/constants/letterState.dart';
import 'package:wordle/entities/letter.dart';
import 'package:wordle/services/loadJson.dart';
import 'dao/partie_dao.dart';
import 'entities/partie.dart';


/// Observer class that manages the state and logic of the Wordle-like game.
///
/// This class supports multiple modes, including:
/// - Classic Mode: Standard Wordle gameplay.
/// - Survival Mode: Progressive gameplay with increasing difficulty.
/// - Duel Mode: Multiplayer mode where players alternate guessing.
/// It also provides methods for saving and retrieving game statistics.
class Observer extends ChangeNotifier {
  /// Data access object for interacting with the database.
  final PartieDAO _partieDAO = PartieDAO();
  /// Current position of the cursor in the grid.
  int currentNode = 0;
  /// Current row being edited in the grid.
  int currentRow = 0;
  /// List of letters tapped during the game.
  List<Letter> letterTaped = [];
  /// The word to be guessed.
  late String winningWord;
  /// Indicates whether data is being loaded.
  bool loading = true;
  /// Indicates whether the game is won.
  bool hasWon = false;
  /// Indicates whether the game is lost.
  bool hasLost = false;
  /// Maximum number of attempts allowed in the current game.
  int maxAttempts;
  /// Length of the word to be guessed.
  int wordLength;

  // Survival Mode attributes
  bool isHardMode = false; // Default to easy mode
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

  /// Creates an `Observer` instance with specified game settings.
  ///
  /// Parameters:
  /// - [wordLength]: Length of the word to guess.
  /// - [maxAttempts]: Maximum attempts allowed in the game.
  /// - [isSurvivalMode]: Whether the game is in survival mode.
  /// - [isDuelMode]: Whether the game is in duel mode.
  Observer({
    required this.wordLength,
    required this.maxAttempts,
    this.isSurvivalMode = false,
    this.isDuelMode = false,
    int? rounds,  // Optional parameter for duel mode
  }) {
    print("--------------------->   $isDuelMode");
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

  /// Starts the Survival Mode with default settings.
  void startSurvivalMode() {
    print("Starting Survival Mode");
    isSurvivalMode = true;
    resetSurvivalGame();
  }
  /// Resets the game attributes for Survival Mode.
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
  /// Sets a new word for Survival Mode.
  Future<void> _setNewSurvivalWord() async {
    final word = await getRandomWord(wordLength: survivalWordLength);
    print("worrrrrrrrrrrrrrrd $word" );
    winningWord = word?.toUpperCase() ?? "APPLE";
    loading = false;
    notifyListeners();
  }
  /// Increments the survival level in Survival Mode by increasing word length and reducing attempts.
  ///
  /// This method applies the following progression principle:
  /// - For every `wordLength ÷ 2` consecutive correct guesses:
  ///   - **Word length** increases by 1.
  ///   - **Number of attempts** decreases by 1 (minimum of 3 attempts).
  ///   - Consecutive correct guesses are reset to 0.
  ///
  /// The method then updates the game state with the new word length and attempts,
  /// generates a new word, and resets the grid for the next level.
  ///
  /// Example:
  /// ```dart
  /// // Initial state:
  /// wordLength = 4, survivalAttempts = 10, consecutiveCorrectGuesses = 0
  ///
  /// // After 2 correct guesses (`4 ÷ 2`):
  /// survivalWordLength = 5, survivalAttempts = 9
  /// consecutiveCorrectGuesses = 0
  /// ```
  ///
  /// This method only operates if `isSurvivalMode` is enabled. If not, it logs a message and exits.
  void incrementSurvivalLevel() {
    if (isSurvivalMode) {
      print("Survival Mode - incrementing level");

      // Increment score and consecutive correct guesses
      score++; // Increase the score for each correct guess
      consecutiveCorrectGuesses++;

      // Check if the threshold for increasing word length is reached
      if (consecutiveCorrectGuesses >= (wordLength ~/ 2)) {
        survivalWordLength++; // Increase the word length
        consecutiveCorrectGuesses = 0; // Reset consecutive correct guesses

        // Reduce attempts with each word length increment, minimum of 3 attempts
        survivalAttempts = (survivalAttempts > 3) ? survivalAttempts - 1 : 3;
      }

      // Update game settings with the new values
      wordLength = survivalWordLength;
      maxAttempts = survivalAttempts;

      // Generate a new word and reset the game grid
      _setNewSurvivalWord(); // Generate a new winning word based on the new word length
      resetSurvivalGrid(); // Clear the board for the new level

      // Log the updated settings to confirm
      print("New word length: $wordLength, New attempts: $maxAttempts, New winning word: $winningWord");

      // Notify UI to update with the new values
      notifyListeners();
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


  /* -----------------------------------------------------------------------------------  */
  /* Classic Mode  */

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
    }
  }

  /* ----------------------------------------------------------------------------------- */
/* Dual Mode */

  /// Initializes Duel Mode with the specified settings.
  ///
  /// Parameters:
  /// - [rounds]: Total number of rounds in the duel.
  /// - [attempts]: Maximum attempts allowed per round.
  /// - [wordLength]: Length of the word to guess in each round.
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
    isSettingSecretWord = true; // Ensure the first step is to set a word

    // Ensure words are null initially to avoid confusion
    player1SecretWord = null;
    player2SecretWord = null;

    resetGameForNextTurn();
  }

  /// Resets the game state for the next turn in Duel Mode.
  ///
  /// Clears the board, resets flags, and prepares the game for the next turn.
  void resetGameForNextTurn() {
    currentNode = 0;
    currentRow = 0;
    letterTaped.clear();
    hasWon = false;
    hasLost = false;
    loading = false; // No need to load a new word in Duel Mode
    notifyListeners();
  }

  /// Sets the secret word for the opponent in Duel Mode.
  ///
  /// Parameters:
  /// - [word]: The word set by the current player for their opponent.
  void setSecretWordForOpponent(String word) {
    if (isPlayer1Turn) {
      player2SecretWord = word; // Player 1 sets the word for Player 2
      print("Player 1 set secret word for Player 2: $player2SecretWord");
    } else {
      player1SecretWord = word; // Player 2 sets the word for Player 1
      print("Player 2 set secret word for Player 1: $player1SecretWord");
    }
    // Reset the flag only after the word has been set
    isSettingSecretWord = false;
    notifyListeners();
  }

  /// Checks if the Duel Mode game is over.
  ///
  /// Returns `true` if the current round exceeds the total number of rounds; otherwise, `false`.
  bool isGameOver() {
    return currentRound > totalRounds;
  }
  /// Handles the transition to the next turn in Duel Mode.
  ///
  /// Checks the results of the current round, updates scores, and alternates turns.
  /// Resets the game state for the next turn if the game is not over.
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

    resetGameForNextTurn(); // Reset the state for the next turn
    notifyListeners();
  }
  /// Checks the player's guess against the opponent's secret word.
  ///
  /// Evaluates the guessed word and marks it as correct or incorrect.
  /// Proceeds to the next turn if the maximum attempts are reached or the word is guessed.
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
      _markCorrectForDuel(targetWord); // Handle correct guess
    } else {
      print("Incorrect guess in Duel Mode: $guessedWord");
      _markIncorrectForDuel(guessedWord, targetWord);

      // Check if the player has more attempts
      if (currentRow < maxAttempts) {
        print("Player still has attempts remaining. Let them guess again.");
      }
    }

    notifyListeners(); // Notify UI of changes
  }
  void _markCorrectForDuel(String targetWord) {
    // Highlight correct letters in the UI
    for (int i = 0; i < targetWord.length; i++) {
      final index = currentRow * wordLength + i;
      letterTaped[index].status = LetterState.correct; // Mark all letters as correct
    }

    if (isPlayer1Turn) {
      player1Score++; // Increment Player 1's score
      print("Player 1 guessed correctly. Score: $player1Score");
      isPlayer1GuessedCorrectly = true;
    } else {
      player2Score++; // Increment Player 2's score
      print("Player 2 guessed correctly. Score: $player2Score");
      isPlayer2GuessedCorrectly = true;
    }

    hasWon = true; // Mark this turn as a win
    transitionToNextTurn(); // Move to the next turn
    notifyListeners(); // Update the UI
  }
  void _markIncorrectForDuel(String guessedWord, String targetWord) {
    // Highlight incorrect or partially correct letters in the UI
    for (int i = 0; i < guessedWord.length; i++) {
      final guessedLetter = guessedWord[i];
      final index = currentRow * wordLength + i;

      // Check if the guessed letter is in the target word
      if (targetWord.contains(guessedLetter)) {
        letterTaped[index].status = guessedLetter == targetWord[i]
            ? LetterState.correct // Correct letter and position
            : LetterState.contains; // Correct letter but wrong position
      } else {
        letterTaped[index].status = LetterState.incorrect; // Letter not in the word
      }
    }

    currentRow++; // Move to the next row for the player's next guess

    if (currentRow >= maxAttempts) {
      // Player used all attempts; transition to the next turn
      if (isPlayer1Turn) {
        isPlayer1GuessedCorrectly = false;
        print("Player 1 failed to guess the word.");
      } else {
        isPlayer2GuessedCorrectly = false;
        print("Player 2 failed to guess the word.");
      }

      hasLost = true; // Mark the turn as a loss
      transitionToNextTurn(); // Move to the next turn
    } else {
      print("Player still has attempts remaining. Let them guess again.");
    }

    notifyListeners(); // Update the UI
  }





  /* -----------------------------------------------------------------------------------  */
  /* Save and Stats   */

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
  Future<int> get totalWins async {
    final games = await _partieDAO.getParties();
    return games.where((partie) => partie.attempts <= maxAttempts).length; // Won in allowed attempts
  }

  Future<int> get totalLosses async {
    final games = await _partieDAO.getParties();
    final wonGames = games.where((partie) => partie.attempts <= maxAttempts).length;
    return games.length - wonGames; // Losses = total games - wins
  }

  Future<List<PartieEntity>> getFilteredGames({required String mode}) async {
    final games = await _partieDAO.getParties();
    return games.where((partie) => partie.gameMode == mode).toList(); // Filter by mode
  }








}
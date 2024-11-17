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

  /// Indicates whether the game is in hard mode for Survival Mode.
  ///
  /// Defaults to `false` (easy mode). If set to `true`, the game becomes more challenging.
  bool isHardMode = false;

  /// Current word length in Survival Mode.
  ///
  /// Defaults to 3. The word length increases as the player progresses.
  int survivalWordLength = 3;

  /// Current attempt limit in Survival Mode.
  ///
  /// Defaults to 10. The number of attempts decreases as the word length increases.
  int survivalAttempts = 10;

  /// Number of consecutive correct guesses made in Survival Mode.
  ///
  /// Used to determine when to increase the word length and adjust the attempt limit.
  int consecutiveCorrectGuesses = 0;

  /// Total score achieved in Survival Mode.
  ///
  /// The score increases by 1 for every correct guess.
  int score = 0;

  /// Indicates whether the game is currently in Survival Mode.
  ///
  /// Defaults to `false`. Set to `true` when Survival Mode is enabled.
  bool isSurvivalMode = false;


  /// Indicates whether the game is in Duel Mode.
  ///
  /// Defaults to `false`. Set to `true` when Duel Mode is enabled.
  bool isDuelMode = false;

  /// Total number of rounds in Duel Mode.
  ///
  /// Defaults to 0. The total number of rounds is defined when the mode is initialized.
  int totalRounds = 0;

  /// Current round in Duel Mode.
  ///
  /// Starts at 1 and increments after both players complete their turns.
  int currentRound = 1;

  /// Score of Player 1 in Duel Mode.
  ///
  /// Increments by 1 for each correct guess by Player 1.
  int player1Score = 0;

  /// Score of Player 2 in Duel Mode.
  ///
  /// Increments by 1 for each correct guess by Player 2.
  int player2Score = 0;

  /// Indicates whether it is Player 1's turn in Duel Mode.
  ///
  /// Defaults to `true`. Alternates after each turn.
  bool isPlayer1Turn = true;

  /// Secret word set by Player 1 for Player 2 to guess in Duel Mode.
  ///
  /// This is `null` until Player 1 sets the word.
  String? player1SecretWord;

  /// Secret word set by Player 2 for Player 1 to guess in Duel Mode.
  ///
  /// This is `null` until Player 2 sets the word.
  String? player2SecretWord;

  /// Indicates whether a player is setting the secret word in Duel Mode.
  ///
  /// Defaults to `true` for the first player at the beginning of the game.
  /// Ensures that a player sets a word before guessing starts.
  bool isSettingSecretWord = true;

  /// Indicates whether Player 1 has correctly guessed Player 2's secret word.
  ///
  /// Defaults to `false`. Set to `true` if Player 1 guesses correctly.
  bool isPlayer1GuessedCorrectly = false;

  /// Indicates whether Player 2 has correctly guessed Player 1's secret word.
  ///
  /// Defaults to `false`. Set to `true` if Player 2 guesses correctly.
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
  ///
  /// This method:
  /// - Sets the `isSurvivalMode` flag to `true`.
  /// - Resets the game state for Survival Mode by calling `resetSurvivalGame`.
  /// - Logs a message indicating the start of Survival Mode.
  void startSurvivalMode() {
    print("Starting Survival Mode");
    isSurvivalMode = true;
    resetSurvivalGame();
  }

  /// Resets the game attributes for Survival Mode.
  ///
  /// This method:
  /// - Resets the `survivalWordLength` to 3 (starting word length).
  /// - Resets the `survivalAttempts` to 10 (starting number of attempts).
  /// - Clears `consecutiveCorrectGuesses` and `score` to start fresh.
  /// - Sets `hasLost` to `false` to indicate the game is not lost.
  /// - Updates the `wordLength` and `maxAttempts` to match the current survival mode settings.
  /// - Calls `_setNewSurvivalWord` to generate a new word for the player to guess.
  /// - Notifies listeners to update the UI.
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
  ///
  /// This asynchronous method:
  /// - Retrieves a random word with a length equal to `survivalWordLength` by calling `getRandomWord`.
  /// - Logs the retrieved word for debugging purposes.
  /// - Sets the `winningWord` to the retrieved word (converted to uppercase) or defaults to "APPLE" if no word is retrieved.
  /// - Updates the `loading` flag to `false` to indicate that the word has been set.
  /// - Notifies listeners to update the UI with the new word.
  Future<void> _setNewSurvivalWord() async {
    final word = await getRandomWord(wordLength: survivalWordLength);
    print("survival word is ---------> $word");
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

  /// Resets the grid state for a new level in Survival Mode.
  ///
  /// This method:
  /// - Resets `currentNode` and `currentRow` to 0, preparing for the new level.
  /// - Clears the `letterTaped` list, removing any previously entered letters.
  /// - Sets `hasWon` and `hasLost` to `false` to start fresh.
  /// - Updates the `loading` flag to `false` to indicate the grid is ready.
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

  /// Sets a new word for Classic Mode.
  ///
  /// This asynchronous method:
  /// - Retrieves a random word with a length equal to `wordLength` by calling `getRandomWord`.
  /// - Logs the retrieved word for debugging purposes.
  /// - Sets the `winningWord` to the retrieved word (converted to uppercase) or defaults to "APPLE" if no word is retrieved.
  /// - Updates the `loading` flag to `false` to indicate that the word has been set.
  /// - Notifies listeners to update the UI with the new word.
  Future<void> _setWinningWord() async {
    final word = await getRandomWord(wordLength: wordLength);
    print("classic word '''''''''''' $word");
    winningWord = word?.toUpperCase() ?? "APPLE"; // Default to "APPLE" if no word is retrieved
    loading = false;
    notifyListeners();
  }


  /// Resets the game based on the active mode.
  ///
  /// This method:
  /// - Calls `resetSurvivalGame` if the game is in Survival Mode (`isSurvivalMode` is `true`).
  /// - Calls `_resetClassicGame` if the game is in Classic Mode (`isSurvivalMode` is `false`).
  /// - Notifies listeners to update the UI after resetting the game state.
  void resetGame() {
    if (isSurvivalMode) {
      resetSurvivalGame();
    } else {
      _resetClassicGame();
    }
    notifyListeners();
  }

  /// Resets the game state for Classic Mode.
  ///
  /// This method:
  /// - Resets `currentNode` and `currentRow` to 0 to start a new game.
  /// - Clears the `letterTaped` list, removing any previous guesses.
  /// - Sets `hasWon` and `hasLost` to `false` to reset the win/loss state.
  /// - Sets `loading` to `true` while a new word is being retrieved.
  /// - Calls `_setWinningWord` to generate a new word for the game.
  void _resetClassicGame() {
    currentNode = 0;
    currentRow = 0;
    letterTaped.clear();
    hasWon = false;
    hasLost = false;
    loading = true;
    _setWinningWord();
  }


  /// Handles key taps during the game for all modes (Classic, Survival, Duel).
  ///
  /// This method processes three types of input:
  /// - `'ENTER'`: Submits the current guess if the row is complete.
  ///   - Calls `_checkGuessDuel` if the game is in Duel Mode.
  ///   - Calls `_checkGuess` for Classic or Survival Mode.
  /// - `'DEL'`: Deletes the last entered character if there are characters in the current row.
  /// - Any other value: Adds the character to the current row if the row is not yet full.
  ///
  /// Parameters:
  /// - [value]: The key value tapped by the player (`'ENTER'`, `'DEL'`, or a letter).
  ///
  /// After processing the input, this method notifies listeners to update the UI.
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


  /// Checks the player's guess and determines if they win or lose in Classic or Survival Mode.
  ///
  /// This method:
  /// - Constructs the `guessedWord` by combining the letters from the current row.
  /// - Logs the guessed word and the winning word for debugging purposes.
  /// - Checks the following conditions:
  ///   - If the `winningWord` is not set, logs an error and exits.
  ///   - If the `guessedWord` matches the `winningWord`:
  ///     - Marks the game as won using `_markWin`.
  ///     - If in Survival Mode, calls `incrementSurvivalLevel` to proceed to the next level.
  ///   - If the `guessedWord` is incorrect:
  ///     - Marks incorrect guesses using `_markIncorrect`.
  ///     - If the player runs out of attempts (`currentRow >= maxAttempts`), sets `hasLost` to `true`.
  /// - Saves the game state using `saveCompletedGame` if the game is won or lost.
  /// - Notifies listeners to update the UI with the latest state.
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

  /// Marks the game as won by updating the letter statuses for the winning row.
  ///
  /// Parameters:
  /// - [targetWord]: The correct word that was guessed.
  ///
  /// This method:
  /// - Iterates through each letter in the `targetWord`.
  /// - Updates the `status` of the corresponding letters in `letterTaped` to `LetterState.correct`.
  /// - Sets `hasWon` to `true` to indicate the game has been won.
  void _markWin(String targetWord) {
    for (int i = 0; i < targetWord.length; i++) {
      final index = currentRow * wordLength + i;
      letterTaped[index].status = LetterState.correct; // Mark all letters as correct
    }
    hasWon = true; // Mark the game as won
  }

  /// Marks incorrect guesses by updating the letter statuses for the guessed word.
  ///
  /// Parameters:
  /// - [guessedWord]: The word guessed by the player.
  /// - [targetWord]: The correct word to compare against.
  ///
  /// This method:
  /// - Iterates through each letter in the `guessedWord`.
  /// - For each letter:
  ///   - If the letter exists in the `targetWord`:
  ///     - Sets the `status` to `LetterState.correct` if the position matches.
  ///     - Sets the `status` to `LetterState.contains` if the position does not match.
  ///   - If the letter does not exist in the `targetWord`, sets the `status` to `LetterState.incorrect`.
  /// - Increments `currentRow` after the guess.
  /// - If the player has exhausted all attempts (`currentRow >= maxAttempts`), sets `hasLost` to `true`.
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
  /// This method:
  /// - Resets `currentNode` and `currentRow` to 0, preparing for the new turn.
  /// - Clears the `letterTaped` list to remove any previously entered letters.
  /// - Sets `hasWon` and `hasLost` to `false`, resetting the win/loss state.
  /// - Sets `loading` to `false`, as a new word is not required for Duel Mode turns.
  /// - Notifies listeners to update the UI for the next turn.
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
  /// This method:
  /// - Allows the current player to set a secret word for their opponent.
  /// - Updates `player2SecretWord` if it's Player 1's turn.
  /// - Updates `player1SecretWord` if it's Player 2's turn.
  /// - Logs the action for debugging purposes.
  /// - Sets `isSettingSecretWord` to `false` after the word has been set, indicating
  ///   that the word-setting phase is complete.
  /// - Notifies listeners to update the UI with the updated state.
  ///
  /// Parameters:
  /// - [word]: The word set by the current player for their opponent to guess.
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
  /// This method:
  /// - Checks the results of the current round when both players have taken their turns:
  ///   - If both players guessed correctly, increments `currentRound` and logs the outcome.
  ///   - If both players failed, logs that the round is a tie.
  ///   - If only one player guessed correctly, logs the winner of the round.
  /// - Resets the round results (`isPlayer1GuessedCorrectly` and `isPlayer2GuessedCorrectly`) for the next round.
  /// - Checks if the game is over by comparing `currentRound` to `totalRounds`:
  ///   - If the game is over, logs the game-over message and updates the UI without proceeding further.
  /// - Toggles the player's turn by switching `isPlayer1Turn`.
  /// - Sets `isSettingSecretWord` to `true`, prompting the next player to set their secret word.
  /// - Calls `resetGameForNextTurn` to reset the game state for the next turn.
  /// - Notifies listeners to update the UI with the new state.
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

  /// Checks the player's guess against the opponent's secret word in Duel Mode.
  ///
  /// This method:
  /// - Constructs the `guessedWord` based on the letters tapped in the current row.
  /// - Retrieves the correct `targetWord` for the current turn:
  ///   - Uses `player2SecretWord` if it is Player 1's turn.
  ///   - Uses `player1SecretWord` if it is Player 2's turn.
  /// - If the `targetWord` is not set or empty, logs an error and exits.
  /// - If the `guessedWord` matches the `targetWord`:
  ///   - Calls `_markCorrectForDuel` to handle a correct guess.
  /// - If the `guessedWord` is incorrect:
  ///   - Calls `_markIncorrectForDuel` to handle an incorrect guess.
  ///   - Logs whether the player has remaining attempts.
  /// - Notifies listeners to update the UI.
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

  /// Handles a correct guess in Duel Mode by marking the letters as correct and updating scores.
  ///
  /// This method:
  /// - Updates the `status` of all letters in the current row to `LetterState.correct`.
  /// - Increments the score for the current player:
  ///   - Increments `player1Score` if it is Player 1's turn and sets `isPlayer1GuessedCorrectly` to `true`.
  ///   - Increments `player2Score` if it is Player 2's turn and sets `isPlayer2GuessedCorrectly` to `true`.
  /// - Marks the turn as won by setting `hasWon` to `true`.
  /// - Calls `transitionToNextTurn` to proceed to the next turn.
  /// - Notifies listeners to update the UI.
  ///
  /// Parameters:
  /// - [targetWord]: The correct word guessed by the player.
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

  /// Handles an incorrect guess in Duel Mode by marking the letters and updating the turn state.
  ///
  /// This method:
  /// - Updates the `status` of each letter in the `guessedWord`:
  ///   - Sets `LetterState.correct` if the letter is in the correct position.
  ///   - Sets `LetterState.contains` if the letter exists in the `targetWord` but in the wrong position.
  ///   - Sets `LetterState.incorrect` if the letter does not exist in the `targetWord`.
  /// - Increments `currentRow` to move to the next attempt.
  /// - If the maximum attempts are reached:
  ///   - Sets `isPlayer1GuessedCorrectly` or `isPlayer2GuessedCorrectly` to `false` based on the current turn.
  ///   - Logs the failure for the current player.
  ///   - Marks the turn as lost by setting `hasLost` to `true`.
  ///   - Calls `transitionToNextTurn` to proceed to the next turn.
  /// - Logs whether the player has remaining attempts.
  /// - Notifies listeners to update the UI.
  ///
  /// Parameters:
  /// - [guessedWord]: The word guessed by the player.
  /// - [targetWord]: The correct word to compare against.
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

  /// Saves the completed game to the database.
  ///
  /// This method:
  /// - Creates a new `PartieEntity` with details about the game, such as:
  ///   - `secretWord`: The word to guess in the game.
  ///   - `date`: The date and time when the game was completed.
  ///   - `attempts`: The number of attempts taken in the game.
  ///   - `guessedLetters`: The letters guessed during the game.
  ///   - `gameMode`: The mode of the game (Classic, Survival, or Duel).
  ///   - `wordLength`: The length of the word in the game.
  /// - Inserts the entity into the database using `_partieDAO.insertPartie`.
  /// - Logs an error if the save operation fails.
  ///
  /// Parameters:
  /// - [won]: Indicates whether the game was won (`true`) or lost (`false`).
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

  /// Retrieves all saved games from the database.
  ///
  /// Returns:
  /// - A `Future` containing a list of `PartieEntity` objects.
  Future<List<PartieEntity>> getParties() async {
    return await _partieDAO.getParties();
  }

  /// Calculates the total number of games played.
  ///
  /// Returns:
  /// - A `Future` containing the total number of games as an integer.
  Future<int> get totalGamesPlayed async {
    final games = await _partieDAO.getParties();
    return games.length;
  }

  /// Calculates the win percentage across all games.
  ///
  /// Returns:
  /// - A `Future` containing the win percentage as a double.
  Future<double> get winPercentage async {
    final games = await _partieDAO.getParties();
    final wonGames = games.where((partie) => partie.attempts <= maxAttempts).length;
    return (wonGames / games.length) * 100;
  }

  /// Calculates the average percentage of attempts used per game.
  ///
  /// Returns:
  /// - A `Future` containing the average percentage as a double.
  /// - Returns 0.0 if no games have been played.
  Future<double> get averageAttempts async {
    final games = await _partieDAO.getParties();
    if (games.isEmpty) return 0.0;

    final totalPercentage = games.fold(0.0, (sum, partie) {
      final attemptsPercentage = (partie.attempts / maxAttempts) * 100;
      return sum + attemptsPercentage;
    });

    return totalPercentage / games.length;
  }

  /// Calculates the total number of games won.
  ///
  /// Returns:
  /// - A `Future` containing the total number of wins as an integer.
  Future<int> get totalWins async {
    final games = await _partieDAO.getParties();
    return games.where((partie) => partie.attempts <= maxAttempts).length; // Won in allowed attempts
  }

  /// Calculates the total number of games lost.
  ///
  /// Returns:
  /// - A `Future` containing the total number of losses as an integer.
  Future<int> get totalLosses async {
    final games = await _partieDAO.getParties();
    final wonGames = games.where((partie) => partie.attempts <= maxAttempts).length;
    return games.length - wonGames; // Losses = total games - wins
  }

  /// Retrieves a list of games filtered by the specified game mode.
  ///
  /// Parameters:
  /// - [mode]: The game mode to filter by (e.g., 'Classic', 'Survival', 'Duel').
  ///
  /// Returns:
  /// - A `Future` containing a list of `PartieEntity` objects that match the specified mode.
  Future<List<PartieEntity>> getFilteredGames({required String mode}) async {
    final games = await _partieDAO.getParties();
    return games.where((partie) => partie.gameMode == mode).toList(); // Filter by mode
  }







}
import 'package:wordle/constants/letterState.dart';

/// Represents a letter in the Wordle game.
///
/// Each [Letter] has a character ([char]) and a state ([status]) that changes
/// as the game progresses. The state is represented by the [LetterState] enum.
class Letter {
  /// The character represented by this letter (e.g., 'A', 'B', etc.).
  final String char;

  /// The current state of the letter.
  ///
  /// The state can change as the game progresses and is represented by [LetterState]:
  /// - [LetterState.untouched]: The letter has not been used yet.
  /// - [LetterState.correct]: The letter is correct and in the right position (green).
  /// - [LetterState.incorrect]: The letter is not part of the word (gray).
  /// - [LetterState.contains]: The letter is part of the word but in the wrong position (yellow).
  LetterState status;

  /// Creates a [Letter] with a specified character and initial state.
  ///
  /// - [char]: The character represented by this letter.
  /// - [status]: The initial state of the letter, required at creation.
  Letter({
    required this.char,
    required this.status,
  });
}

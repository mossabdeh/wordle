import 'package:wordle/constants/letterState.dart';
import 'package:wordle/constants/letterValue.dart';

/// A map that stores the current state of each letter on the keyboard.
///
/// Each [LetterValue] is mapped to a [LetterState], which represents its current state:
/// - [LetterState.untouched]: The letter has not been used.
/// - [LetterState.correct]: The letter is correct and in the right position (green).
/// - [LetterState.incorrect]: The letter is not part of the word (gray).
/// - [LetterState.contains]: The letter is part of the word but in the wrong position (yellow).
///
/// This map is initialized with all letters set to [LetterState.untouched].
Map<LetterValue, LetterState> keyboardState = {
  // Initialize each keyboard value with untouched state.
  for (LetterValue letter in LetterValue.values) letter: LetterState.untouched,
};
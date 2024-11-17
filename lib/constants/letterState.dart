/// Represents the state of a letter in the Wordle game.
///
/// This enum is used to track the state of each letter:
/// - [untouched]: The letter has not been used yet.
/// - [correct]: The letter is correct and in the right position (green).
/// - [incorrect]: The letter is not correct (gray).
/// - [contains]: The letter is part of the word but in the wrong position (yellow).
enum LetterState {
  /// The letter has not been touched yet.
  untouched,

  /// The letter is correct and in the right position (green).
  correct,

  /// The letter is not part of the word (gray).
  incorrect,

  /// The letter is part of the word but in the wrong position (yellow).
  contains,
}

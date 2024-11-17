/// Represents the possible values of the keyboard letters.
///
/// This enum includes all alphabet letters (A-Z), along with special keys:
/// - [ENTER]: Represents the Enter key.
/// - [DEL]: Represents the Delete key.
enum LetterValue {
  A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, ENTER, X, Y, Z,
  DEL;

  /// Returns the display name for the letter.
  ///
  /// - [ENTER] is displayed as "ENTER".
  /// - [DEL] is displayed as "DEL".
  /// - All other values are displayed as their uppercase letter name (e.g., "A", "B").
  String get displayName {
    switch (this) {
      case LetterValue.ENTER:
        return 'ENTER';
      case LetterValue.DEL:
        return 'DEL';
      default:
        return name; // Returns the uppercase name of the letter.
    }
  }

  /// Converts a character to a [LetterValue].
  ///
  /// This method takes a [char] and returns the corresponding [LetterValue], or `null`
  /// if the character does not match any value. The input character is case-insensitive.
  ///
  /// Example:
  /// ```dart
  /// LetterValue? letter = LetterValue.fromChar('A'); // Returns LetterValue.A
  /// ```
  static LetterValue? fromChar(String char) {
    try {
      return LetterValue.values.firstWhere(
            (e) => e.name == char.toUpperCase(),
      );
    } catch (e) {
      return null; // Return null if the character doesn't match any LetterValue.
    }
  }
}
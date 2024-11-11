
/* Values of my keyboard*/

enum LetterValue {
  A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, ENTER,X, Y, Z,

  DEL;

  String get displayName {
    switch (this) {
      case LetterValue.ENTER:
        return 'ENTER';
      case LetterValue.DEL:
        return 'DEL';
      default:
        return name; // This will be "A", "B", "C", etc., as a string
    }
  }

  static LetterValue? fromChar(String char) {
    try {
      return LetterValue.values.firstWhere(
            (e) => e.name == char.toUpperCase(),
      );
    } catch (e) {
      return null; // Return null if the character doesn't match any LetterValue
    }}
}

/// Represents a game session in the Wordle-like application.
///
/// The `PartieEntity` class is used to store information about a completed game,
/// including details such as the secret word, date of play, number of attempts,
/// guessed letters, game mode, and the word length.
class PartieEntity {
  /// The unique identifier of the game session.
  ///
  /// This field is nullable, as it may be assigned by a database upon insertion.
  final int? id;

  /// The secret word that the player attempted to guess.
  final String secretWord;

  /// The date and time when the game session occurred.
  final DateTime date;

  /// The total number of attempts made by the player during the session.
  final int attempts;

  /// The letters guessed by the player in the game session.
  ///
  /// This is stored as a string, where each letter represents a guess.
  final String guessedLetters;

  /// The game mode in which the session was played.
  ///
  /// Examples: "Classic", "Survival", or "Dual".
  final String gameMode;

  /// The length of the secret word in the session.
  final int wordLength;

  /// Creates a new `PartieEntity` instance.
  ///
  /// - [id]: The unique identifier of the session (optional).
  /// - [secretWord]: The secret word that the player attempted to guess (required).
  /// - [date]: The date and time when the session occurred (required).
  /// - [attempts]: The total number of attempts made during the session (required).
  /// - [guessedLetters]: The letters guessed by the player (required).
  /// - [gameMode]: The mode in which the session was played (required).
  /// - [wordLength]: The length of the secret word (required).
  PartieEntity({
    this.id,
    required this.secretWord,
    required this.date,
    required this.attempts,
    required this.guessedLetters,
    required this.gameMode,
    required this.wordLength,
  });

  /// Converts the `PartieEntity` instance into a `Map` for database storage.
  ///
  /// Returns a `Map<String, dynamic>` where:
  /// - Keys are the column names in the database.
  /// - Values are the properties of the `PartieEntity` instance.
  ///
  /// Example:
  /// ```dart
  /// {
  ///   'id': 1,
  ///   'secretWord': 'HELLO',
  ///   'date': '2024-11-17T12:34:56Z',
  ///   'attempts': 5,
  ///   'guessedLetters': 'H,E,L,L,O',
  ///   'gameMode': 'Classic',
  ///   'wordLength': 5,
  /// }
  /// ```
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'secretWord': secretWord,
      'date': date.toIso8601String(),
      'attempts': attempts,
      'guessedLetters': guessedLetters,
      'gameMode': gameMode,
      'wordLength': wordLength,
    };
  }

  /// Creates a `PartieEntity` instance from a `Map` retrieved from the database.
  ///
  /// The `map` must include the following keys:
  /// - `'id'`: The unique identifier of the session.
  /// - `'secretWord'`: The secret word.
  /// - `'date'`: The date and time as an ISO 8601 string.
  /// - `'attempts'`: The total number of attempts.
  /// - `'guessedLetters'`: The guessed letters.
  /// - `'gameMode'`: The mode in which the session was played.
  /// - `'wordLength'`: The length of the secret word.
  ///
  /// Example:
  /// ```dart
  /// PartieEntity.fromMap({
  ///   'id': 1,
  ///   'secretWord': 'HELLO',
  ///   'date': '2024-11-17T12:34:56Z',
  ///   'attempts': 5,
  ///   'guessedLetters': 'H,E,L,L,O',
  ///   'gameMode': 'Classic',
  ///   'wordLength': 5,
  /// });
  /// ```
  factory PartieEntity.fromMap(Map<String, dynamic> map) {
    return PartieEntity(
      id: map['id'],
      secretWord: map['secretWord'],
      date: DateTime.parse(map['date']),
      attempts: map['attempts'],
      guessedLetters: map['guessedLetters'],
      gameMode: map['gameMode'],
      wordLength: map['wordLength'],
    );
  }
}

/* Entity To store into database SQlite(sqflite) table */
class PartieEntity {
  final int? id;
  final String secretWord;
  final DateTime date;
  final int attempts;
  final String guessedLetters;
  final String gameMode;

  PartieEntity({
    this.id,
    required this.secretWord,
    required this.date,
    required this.attempts,
    required this.guessedLetters,
    required this.gameMode,
  });

  // Convert a PartieEntity object to a map. This will be used for inserting into the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'secretWord': secretWord,
      'date': date.toIso8601String(), // Store as ISO8601 string for easy DateTime conversion
      'attempts': attempts,
      'guessedLetters': guessedLetters,
      'gameMode': gameMode,
    };
  }

  // Convert a map into a PartieEntity object. This will be used for fetching from the database.
  static PartieEntity fromMap(Map<String, dynamic> map) {
    return PartieEntity(
      id: map['id'],
      secretWord: map['secretWord'],
      date: DateTime.parse(map['date']),
      attempts: map['attempts'],
      guessedLetters: map['guessedLetters'],
      gameMode: map['gameMode'],
    );
  }
}

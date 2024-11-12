class PartieEntity {
  final int? id;
  final String secretWord;
  final DateTime date;
  final int attempts;
  final String guessedLetters;
  final String gameMode;
  final int wordLength; // Add this field to store word length

  PartieEntity({
    this.id,
    required this.secretWord,
    required this.date,
    required this.attempts,
    required this.guessedLetters,
    required this.gameMode,
    required this.wordLength,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'secretWord': secretWord,
      'date': date.toIso8601String(),
      'attempts': attempts,
      'guessedLetters': guessedLetters,
      'gameMode': gameMode,
      'wordLength': wordLength, // Include this field in toMap
    };
  }

  factory PartieEntity.fromMap(Map<String, dynamic> map) {
    return PartieEntity(
      id: map['id'],
      secretWord: map['secretWord'],
      date: DateTime.parse(map['date']),
      attempts: map['attempts'],
      guessedLetters: map['guessedLetters'],
      gameMode: map['gameMode'],
      wordLength: map['wordLength'], // Include this field in fromMap
    );
  }
}

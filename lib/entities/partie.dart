
import 'package:wordle/entities/mot.dart';

class Partie {
  final int wordLength;
  final int maxAttempts;
  final String secretWord;
  final List<Mot> words;
  bool isWon;

  Partie({
    this.wordLength = 5,         // Default value
    this.maxAttempts = 6,        // Default value
    required this.secretWord,
    this.words = const [],
    this.isWon = false,
  });

  void demarrerPartie( ) {
    // Set up the default or provided values
  }

  void checkMot(Mot guessedWord) {
    // Logic to check guessed word against the secret word
  }
}
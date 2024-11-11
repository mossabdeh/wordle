

import 'package:wordle/constants/letterState.dart';

class Letter {
  final String char;
  final LetterState status;

  Letter({
    required this.char,
    required this.status,
  });
}



import 'package:wordle/constants/letterState.dart';

class Letter {
  final String char;
   LetterState status; /* keeps changing state not final*/

  Letter({
    required this.char,
    required this.status,
  });
}

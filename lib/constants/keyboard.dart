

import 'package:wordle/constants/letterState.dart';
import 'package:wordle/constants/letterValue.dart';

/* Using a map to Store the state of each letter for its correspondence value*/

Map<LetterValue, LetterState> keyboardState = {
  /* init each keyboard value with untouched */
  for (LetterValue letter in LetterValue.values) letter: LetterState.untouched,
};



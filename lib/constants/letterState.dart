/* we will associate that enum with our letters */

enum LetterState {
  untouched , /* when we didn't touch that letter yet*/
  correct , /* when the letter is right color will be green*/
  incorrect , /* when the letter is not right */
  contains /* there s that letter but not in that place */
}
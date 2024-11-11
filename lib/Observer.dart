
import 'package:flutter/material.dart';
import 'package:wordle/constants/letterState.dart';
import 'package:wordle/entities/letter.dart';

class Observer extends ChangeNotifier{

  int currentNode = 0 ;
  int currentRow = 0 ;
  List<Letter> letterTaped = [] ;
  setKeyTapped({required String value}) {
    // TODO make also a check when the letter are 5 auto without clicking enter
    if (value == 'ENTER') {
      /* check the list taped
       (change the status of letter entered based on the guessed word ) */
      if (currentNode == 5 *(currentRow + 1)) {
        print("check");
      }
    } else if (value == 'DEL') {
      if (currentNode > 5 *(currentRow + 1) - 5 ) {
        currentNode--;
        /* We remove from our list the last letter taped here */
        letterTaped.removeLast();
      }
    } else {
      if (currentNode < 5 *(currentRow + 1)) {
        //TODO comment
        /* Add the letter taped to the list with status untouched
         (it will be changed after the check button) */
        letterTaped.add(Letter(char: value , status: LetterState.untouched ));
        currentNode++;
      }
    }
    notifyListeners(); /* notify the changes  */
  }

}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/Observer.dart';
import '../constants/letterState.dart';

class LetterTapedWidget extends StatelessWidget {
  const LetterTapedWidget({required this.index, Key? key}) : super(key: key);

  final int index;

  Color getLetterColor(LetterState state) {
    switch (state) {
      case LetterState.correct:
        return Colors.green;
      case LetterState.contains:
        return Colors.yellow;
      case LetterState.incorrect:
        return Colors.grey;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Observer>(
      builder: (_, observer, __) {
        String text = "";
        Color color = Colors.white;
        if (index < observer.letterTaped.length) {
          text = observer.letterTaped[index].char;
          color = getLetterColor(observer.letterTaped[index].status);
        }
        return Container(
          color: color, // Apply the color based on the letter status
          child: Center(child: Text(text)),
        );
      },
    );
  }
}

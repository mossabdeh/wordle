
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/Observer.dart';

class LetterTapedWidget extends StatelessWidget {
  const LetterTapedWidget({required this.index,
    Key? key,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Consumer<Observer>(
        builder: (_, notifier, __) {
          String text = "";
          if(index < notifier.letterTaped.length) {
            text = notifier.letterTaped[index].char;
            return Center(child: Text(text));
          }else return const SizedBox();
        });
  }
}
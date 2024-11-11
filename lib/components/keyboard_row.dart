import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/Observer.dart';
import '../constants/keyboard.dart';
import '../constants/letterState.dart';


class keyBoardRow extends StatelessWidget {
  const keyBoardRow({required this.min, required this.max, Key? key});

  final int min, max;

  Color getKeyColor(LetterState state) {
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
    final size = MediaQuery.of(context).size;
    int index = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keyboardState.entries.map((e) {
        index++;
        if (index >= min && index <= max) {
          final color = getKeyColor(e.value); // Get color based on LetterState
          return Padding(
            padding: EdgeInsets.all(size.width * 0.006),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                color: color, // Set color for the key
                width: e.key.displayName == 'ENTER' || e.key.displayName == 'DEL'
                    ? size.width * 0.2
                    : size.width * 0.11,
                height: size.height * 0.065,
                child: Material(
                  child: InkWell(
                    onTap: () {
                      Provider.of<Observer>(context, listen: false)
                          .setKeyTapped(value: e.key.displayName);
                    },
                    child: Center(child: Text(e.key.displayName)),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      }).toList(),
    );
  }
}

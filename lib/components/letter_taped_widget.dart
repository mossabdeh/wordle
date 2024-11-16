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
        return const Color(0xFF6B8E23); // Olive Green for correct
      case LetterState.contains:
        return const Color(0xFFFFD700); // Gold for contains
      case LetterState.incorrect:
        return const Color(0xFFD3D3D3); // Light gray for incorrect
      default:
        return const Color(0xFFFFFFFF); // White for default
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Observer>(
      builder: (_, observer, __) {
        String text = "";
        Color color = const Color(0xFFFFFFFF); // Default white
        if (index < observer.letterTaped.length) {
          text = observer.letterTaped[index].char;
          color = getLetterColor(observer.letterTaped[index].status);
        }
        return Container(
          decoration: BoxDecoration(
            color: color, // Background color based on the letter state
            borderRadius: BorderRadius.circular(4), // Slightly rounded corners
            border: Border.all(
              color: const Color(0xFF6B8E23), // Olive Green border
              width: 1.0, // Thinner border for a clean look
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Black text for readability
              ),
            ),
          ),
        );
      },
    );
  }
}

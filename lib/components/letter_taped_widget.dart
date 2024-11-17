import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/Observer.dart';
import '../constants/letterState.dart';

/// A widget that represents a single letter in the Wordle game grid.
///
/// The appearance of the widget changes based on the state of the letter
/// (e.g., correct, contains, or incorrect). It uses the [Observer] provider
/// to retrieve the current state and display of the letter.
class LetterTapedWidget extends StatelessWidget {
  /// The index of the letter in the current grid.
  final int index;

  /// Creates a [LetterTapedWidget].
  ///
  /// The [index] is required and determines which letter this widget represents.
  const LetterTapedWidget({required this.index, Key? key}) : super(key: key);

  /// Returns the color associated with a given [LetterState].
  ///
  /// - [LetterState.correct]: Olive Green (`#6B8E23`).
  /// - [LetterState.contains]: Gold (`#FFD700`).
  /// - [LetterState.incorrect]: Light Gray (`#D3D3D3`).
  /// - Default: White.
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
      /// Builds the widget using the current [Observer] state.
      builder: (_, observer, __) {
        String text = "";
        Color color = const Color(0xFFFFFFFF); // Default white

        // Retrieve the letter and its state if the index is within bounds.
        if (index < observer.letterTaped.length) {
          text = observer.letterTaped[index].char;
          color = getLetterColor(observer.letterTaped[index].status);
        }

        return Container(
          /// Decorates the widget based on the letter's state.
          decoration: BoxDecoration(
            color: color, // Background color based on the letter state.
            borderRadius: BorderRadius.circular(4), // Slightly rounded corners.
            border: Border.all(
              color: const Color(0xFF6B8E23), // Olive Green border.
              width: 1.0, // Thin border for a clean look.
            ),
          ),
          child: Center(
            /// Displays the letter in the center of the widget.
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 16, // Font size for the letter.
                fontWeight: FontWeight.bold,
                color: Colors.black, // Black text for readability.
              ),
            ),
          ),
        );
      },
    );
  }
}

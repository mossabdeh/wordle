import 'package:flutter/material.dart';
import 'letter_taped_widget.dart';

class Grid extends StatelessWidget {
  final int wordLength;
  final int attempts;

  const Grid({Key? key, required this.wordLength, required this.attempts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: wordLength * attempts, // Dynamically adjust based on word length and attempts
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Slight padding around the grid
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 3, // Minimal spacing between rows
        crossAxisSpacing: 2, // Minimal spacing between columns
        crossAxisCount: wordLength, // Columns based on word length
      ),
      itemBuilder: (context, index) {
        return Material(
          elevation: 1, // Subtle elevation for depth
          borderRadius: BorderRadius.circular(4), // Small rounded corners
          child: LetterTapedWidget(index: index),
        );
      },
    );
  }
}

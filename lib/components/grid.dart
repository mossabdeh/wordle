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
      padding: const EdgeInsets.fromLTRB(36, 20, 36, 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        crossAxisCount: wordLength, // Adjust columns based on word length
      ),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: LetterTapedWidget(index: index),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'letter_taped_widget.dart';

/// A widget that represents a dynamic grid for the Wordle game.
///
/// The grid dynamically adjusts based on the word length and number of attempts.
/// Each cell in the grid is represented by a [LetterTapedWidget].
class Grid extends StatelessWidget {
  /// The number of columns in the grid, corresponding to the word length.
  final int wordLength;

  /// The number of rows in the grid, corresponding to the number of attempts.
  final int attempts;

  /// Creates a [Grid] widget.
  ///
  /// Requires [wordLength] and [attempts] as input parameters.
  const Grid({
    Key? key,
    required this.wordLength,
    required this.attempts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      /// The total number of cells in the grid, calculated as [wordLength] x [attempts].
      itemCount: wordLength * attempts,
      /// Padding around the grid.
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        /// The spacing between rows in the grid.
        mainAxisSpacing: 3,
        /// The spacing between columns in the grid.
        crossAxisSpacing: 2,
        /// The number of columns in the grid.
        crossAxisCount: wordLength,
      ),
      /// Builds the individual cells of the grid.
      itemBuilder: (context, index) {
        return Material(
          /// Subtle elevation to give the grid cell depth.
          elevation: 1,
          /// Adds rounded corners to each grid cell.
          borderRadius: BorderRadius.circular(4),
          child: LetterTapedWidget(index: index),
        );
      },
    );
  }
}

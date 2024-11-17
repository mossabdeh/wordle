import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/Observer.dart';

import '../constants/keyboard.dart';

/// A widget that represents a row of keys on the Wordle keyboard.
///
/// The keys in the row are dynamically adjusted based on the provided [min] and [max] range.
/// It uses the [keyboardState] map to determine the state and display of each key.
class keyBoardRow extends StatelessWidget {
  /// The minimum index of keys to display in this row.
  final int min;

  /// The maximum index of keys to display in this row.
  final int max;

  /// Creates a [keyBoardRow] widget.
  ///
  /// Requires the [min] and [max] values to define the range of keys.
  const keyBoardRow({
    required this.min,
    required this.max,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen to calculate key dimensions.
    final size = MediaQuery.of(context).size;
    int index = 0;

    return Container(
      /// Adds vertical margins between rows.
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        /// Centers the keys in the row.
        mainAxisAlignment: MainAxisAlignment.center,
        children: keyboardState.entries.map((e) {
          index++;
          // Display keys within the specified range [min, max].
          if (index >= min && index <= max) {
            return Container(
              /// Adds horizontal spacing between keys.
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                /// Assigns colors based on whether the key is special (ENTER/DEL) or regular.
                color: e.key.displayName == 'ENTER' || e.key.displayName == 'DEL'
                    ? const Color(0xFF6B8E23) // Olive Green for special keys
                    : const Color(0xFFE8F5E9), // Light green for regular keys
                /// Adds rounded corners for a modern appearance.
                borderRadius: BorderRadius.circular(12),
                /// Adds a subtle shadow effect for depth.
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              /// Adjusts the width of the key based on whether it's a special key or regular.
              width: e.key.displayName == 'ENTER' || e.key.displayName == 'DEL'
                  ? size.width * 0.18 // Reduced width for special keys
                  : size.width * 0.1, // Adjusted width for regular keys
              /// Sets the height of the key.
              height: size.height * 0.06,
              child: Material(
                /// Makes the key background transparent.
                color: Colors.transparent,
                child: InkWell(
                  /// Handles key tap interactions by updating the [Observer] with the key value.
                  onTap: () {
                    Provider.of<Observer>(context, listen: false)
                        .setKeyTapped(value: e.key.displayName);
                  },
                  child: Center(
                    /// Displays the key label (e.g., ENTER, DEL, or letter).
                    child: Text(
                      e.key.displayName,
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 14, // Font size for key labels.
                        fontWeight: FontWeight.bold,
                        /// Assigns text color based on whether the key is special or regular.
                        color: e.key.displayName == 'ENTER' || e.key.displayName == 'DEL'
                            ? Colors.white
                            : const Color(0xFF6B8E23), // Olive Green text
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            /// Returns an empty widget for keys outside the range.
            return const SizedBox();
          }
        }).toList(),
      ),
    );
  }
}

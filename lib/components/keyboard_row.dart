import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/Observer.dart';

import '../constants/keyboard.dart';

class keyBoardRow extends StatelessWidget {
  const keyBoardRow({
    required this.min,
    required this.max,
    Key? key,
  });

  final int min, max;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int index = 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4), // Added top and bottom margin (4px each)
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: keyboardState.entries.map((e) {
          index++;
          if (index >= min && index <= max) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2), // Adjust spacing between keys
              decoration: BoxDecoration(
                color: e.key.displayName == 'ENTER' || e.key.displayName == 'DEL'
                    ? const Color(0xFF6B8E23) // Olive Green for special keys
                    : const Color(0xFFE8F5E9), // Light green for regular keys
                borderRadius: BorderRadius.circular(12), // Rounded corners for a modern look
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(2, 2), // Subtle shadow
                  ),
                ],
              ),
              width: e.key.displayName == 'ENTER' || e.key.displayName == 'DEL'
                  ? size.width * 0.18 // Reduced width for special keys
                  : size.width * 0.1, // Adjust width for regular keys
              height: size.height * 0.06, // Reduced height
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Provider.of<Observer>(context, listen: false)
                        .setKeyTapped(value: e.key.displayName);
                  },
                  child: Center(
                    child: Text(
                      e.key.displayName,
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 14, // Adjusted font size
                        fontWeight: FontWeight.bold,
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
            return const SizedBox();
          }
        }).toList(),
      ),
    );
  }
}

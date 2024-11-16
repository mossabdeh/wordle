import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Observer.dart';
import '../pages/dual_game_screen.dart';

void showRoundsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      int rounds = 3;
      int attempts = 6;
      int wordLength = 5;

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Smooth rounded corners
            ),
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dialog Title
                  const Text(
                    'Set Duel Game Settings',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B8E23), // Olive Green
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Rounds Selector with Value
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rounds',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B8E23), // Olive Green
                        ),
                      ),
                      Text(
                        '$rounds', // Display current value
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B8E23), // Match label color
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: rounds.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: rounds.toString(),
                    activeColor: const Color(0xFF6B8E23),
                    inactiveColor: Colors.grey[300],
                    onChanged: (value) {
                      setState(() {
                        rounds = value.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Attempts Selector with Value
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Attempts per Round',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B8E23), // Olive Green
                        ),
                      ),
                      Text(
                        '$attempts', // Display current value
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B8E23), // Match label color
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: attempts.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: attempts.toString(),
                    activeColor: const Color(0xFF6B8E23),
                    inactiveColor: Colors.grey[300],
                    onChanged: (value) {
                      setState(() {
                        attempts = value.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Word Length Selector
                  const Text(
                    'Word Length',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B8E23), // Olive Green
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: Container(
                      width: 120, // Reduced size of the dropdown
                      child: DropdownButton<int>(
                        value: wordLength,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          color: Color(0xFF6B8E23),
                        ),
                        underline: Container(
                          height: 2,
                          color: const Color(0xFF6B8E23),
                        ),
                        alignment: Alignment.center, // Center-align the dropdown text
                        items: List.generate(
                          8,
                              (index) => DropdownMenuItem(
                            value: index + 3,
                            child: Center( // Center-align the text inside the dropdown
                              child: Text(
                                (index + 3).toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            wordLength = value ?? 5;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Buttons: Start Game (Left) and Cancel (Right)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (_) => Observer(
                                  wordLength: wordLength,
                                  maxAttempts: attempts,
                                  isDuelMode: true,
                                  rounds: rounds,
                                ),
                                child: DualGameScreen(
                                  rounds: rounds,
                                  attempts: attempts,
                                  wordLength: wordLength,
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B8E23), // Olive Green
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Start Game',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF6B8E23),
                          side: const BorderSide(color: Color(0xFF6B8E23)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

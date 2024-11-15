import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Observer.dart';
import '../pages/dual_game_screen.dart';


void showRoundsDialog(BuildContext context) {
  final TextEditingController roundsController = TextEditingController();
  final TextEditingController attemptsController = TextEditingController();
  final TextEditingController wordLengthController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Choose Rounds, Attempts, and Word Length'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: roundsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter Number of Rounds',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: attemptsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter Number of Attempts per Round',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: wordLengthController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter Word Length',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog without starting the game
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final int? duelRounds = int.tryParse(roundsController.text);
              final int? duelAttempts = int.tryParse(attemptsController.text);
              final int? wordLength = int.tryParse(wordLengthController.text);

              if (duelRounds != null && duelRounds > 0 &&
                  duelAttempts != null && duelAttempts > 0 &&
                  wordLength != null && wordLength > 0) {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (_) {
                        final observer = Observer(
                          wordLength: wordLength,
                          maxAttempts: duelAttempts,
                          isDuelMode: true, // Set Duel Mode to true
                          rounds: duelRounds,
                        );
                        print("Observer initialized with isDuelMode: ${observer.isDuelMode}");
                        return observer;
                      },
                      child: DualGameScreen(
                        rounds: duelRounds,
                        attempts: duelAttempts,
                        wordLength: wordLength,
                      ),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter valid numbers for rounds, attempts, and word length.')),
                );
              }
            },
            child: const Text('Start Game'),
          ),
        ],
      );
    },
  );
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Observer.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';
import '../components/Partiedialogue.dart';

class PartiePage extends StatelessWidget {
  final int wordLength;
  final int attempts;

  const PartiePage({super.key, required this.wordLength, required this.attempts});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Observer(wordLength: wordLength, maxAttempts: attempts),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wordle'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Consumer<Observer>(
          builder: (context, observer, child) {
            if (observer.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show win dialog if the game is won
            if (observer.hasWon) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showWinDialog(context, observer); // Pass the observer instance
              });
            }

            // Show loss dialog if the game is lost
            if (observer.hasLost) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showLossDialog(context, observer, observer.winningWord); // Pass the observer instance
              });
            }

            return Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    color: Colors.white10,
                    child: Grid(wordLength: wordLength, attempts: attempts),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.white10,
                    child: const Column(
                      children: [
                        keyBoardRow(min: 1, max: 7),
                        keyBoardRow(min: 8, max: 15),
                        keyBoardRow(min: 16, max: 23),
                        keyBoardRow(min: 24, max: 29),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

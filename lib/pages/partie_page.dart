import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Observer.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';
import '../components/Partiedialogue.dart';

class PartiePage extends StatelessWidget {
  final int wordLength;
  final int attempts;
  final bool isSurvivalMode;

  const PartiePage({
    Key? key,
    required this.wordLength,
    required this.attempts,
    this.isSurvivalMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Observer(
        wordLength: wordLength,
        maxAttempts: attempts,
      )..isSurvivalMode = isSurvivalMode, // Set survival mode status
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70), // Reduced AppBar height
          child: AppBar(
            title: Text(
              isSurvivalMode ? 'Survival Mode' : 'Wordle',
              style: const TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 20, // Slightly smaller font size
                color: Color(0xFF6B8E23), // Olive Green
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFFFAF3E0), // Soft Cream
            elevation: 0,
            iconTheme: const IconThemeData(color: Color(0xFF6B8E23)),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFAF3E0), Color(0xFFDCE7C5)], // Unified cream-to-green gradient
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Consumer<Observer>(
            builder: (context, observer, child) {
              if (observer.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF6B8E23), // Olive Green loading spinner
                  ),
                );
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
                  // Grid Section
                  Expanded(
                    flex: 7,
                    child: Grid(
                      wordLength: observer.wordLength,
                      attempts: observer.maxAttempts,
                    ),
                  ),

                  // Keyboard Section
                  Expanded(
                    flex: 4,
                    child: const Column(
                      children: [
                        keyBoardRow(min: 1, max: 7),
                        keyBoardRow(min: 8, max: 15),
                        keyBoardRow(min: 16, max: 23),
                        keyBoardRow(min: 24, max: 29),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

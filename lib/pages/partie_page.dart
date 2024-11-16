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
        appBar: AppBar(
          backgroundColor: const Color(0xFFFAF3E0), // Soft Cream
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF6B8E23)), // Olive Green
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isSurvivalMode
                  ? Row(
                children: [
                  const Icon(
                    Icons.shield,
                    color: Color(0xFFD2691E), // Brown accent
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Survival Mode",
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF6B8E23), // Olive Green
                    ),
                  ),
                ],
              )
                  : const Text(
                "Wordle",
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF6B8E23), // Olive Green
                ),
              ),
              if (isSurvivalMode)
                Consumer<Observer>(
                  builder: (context, observer, child) {
                    return Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFD2691E), // Brown accent
                          size: 24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${observer.score}",
                          style: const TextStyle(
                            fontFamily: 'Raleway',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF6B8E23), // Olive Green
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline, color: Color(0xFF6B8E23)),
              onPressed: () {
                _showGameExplanationDialog(context, isSurvivalMode);
              },
            ),
          ],
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
                  // Survival Stats Section (Word Length & Attempts)
                  if (isSurvivalMode)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: const Color(0xFFE8F5E9), // Light Green
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                icon: Icons.text_snippet_outlined,
                                label: "Word",
                                value: "${observer.survivalWordLength} Letters",
                                iconColor: const Color(0xFF6B8E23), // Olive Green
                                isSmaller: true, // Adjust size
                              ),
                              _buildStatItem(
                                icon: Icons.favorite_border,
                                label: "Attempts",
                                value: "${observer.survivalAttempts}",
                                iconColor: const Color(0xFF6B8E23), // Olive Green
                                isSmaller: true, // Adjust size
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

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

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    bool isSmaller = false,
  }) {
    return Column(
      children: [
        Icon(icon, size: 12, color: iconColor), // Reduced icon size
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 8, // Reduced label font size
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: isSmaller ? 8 : 12, // Reduced value font size
            color: Colors.black87,
          ),
        ),
      ],
    );
  }


  void _showGameExplanationDialog(BuildContext context, bool isSurvivalMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded corners
          ),
          backgroundColor: const Color(0xFFFAF3E0), // Soft Cream
          title: const Center(
            child: Text(
              "Game Explanation",
              style: TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xFF6B8E23), // Olive Green
              ),
            ),
          ),
          content: Text(
            isSurvivalMode
                ? "In Survival Mode:\n\n- Guess words of increasing length.\n- You have limited attempts for each word.\n- Score points by progressing through levels."
                : "In Classic Mode:\n\n- Guess a fixed-length secret word.\n- You have a set number of attempts.\n- Match letters to solve the puzzle.",
            style: const TextStyle(
              fontFamily: 'Raleway',
              fontSize: 16,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B8E23), // Olive Green
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Got It!",
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

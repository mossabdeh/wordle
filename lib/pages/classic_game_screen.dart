import 'package:flutter/material.dart';
import 'partie_page.dart';

/// A configuration screen for starting a Classic Wordle game.
///
/// The `ClassicGameScreen` widget allows users to adjust the game settings
/// (word length and number of attempts) using sliders. Once configured,
/// users can start the game by navigating to the `PartiePage`.
///
/// This widget is designed for a classic Wordle gameplay experience.
class ClassicGameScreen extends StatefulWidget {
  /// Creates a `ClassicGameScreen` widget.
  const ClassicGameScreen({Key? key}) : super(key: key);

  @override
  _ClassicGameScreenState createState() => _ClassicGameScreenState();
}

class _ClassicGameScreenState extends State<ClassicGameScreen> {
  /// The length of the word to guess.
  ///
  /// Defaults to `5`.
  int wordLength = 5;

  /// The number of attempts allowed.
  ///
  /// Defaults to `6`.
  int attempts = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Bigger AppBar
        child: AppBar(
          title: const Text(
            'Partie Classic',
            style: TextStyle(
              color: Color(0xFF6B8E23), // Olive Green
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 24, // Larger font size
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
            colors: [Color(0xFFFAF3E0), Color(0xFFDCE7C5)], // Subtle cream gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Word Length Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Word Length',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B8E23), // Olive Green
                  ),
                ),
                Text(
                  '$wordLength', // Display current value
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
              value: wordLength.toDouble(),
              min: 3,
              max: 10,
              divisions: 7,
              label: wordLength.toString(),
              activeColor: const Color(0xFF6B8E23),
              inactiveColor: Colors.grey[300],
              onChanged: (value) {
                setState(() {
                  wordLength = value.toInt();
                });
              },
            ),
            const SizedBox(height: 20),

            // Attempts Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number of Attempts',
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
            const SizedBox(height: 40),

            // Start Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B8E23), // Olive Green
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PartiePage(
                      wordLength: wordLength,
                      attempts: attempts,
                    ),
                  ),
                );
              },
              child: const Text(
                'Start Classic Game',
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

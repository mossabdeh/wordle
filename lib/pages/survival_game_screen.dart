import 'package:flutter/material.dart';
import 'partie_page.dart';


/// A screen to initialize and transition to Survival Mode in the Wordle game.
///
/// The `SurvivalGameScreen` widget serves as an entry point for Survival Mode.
/// Upon rendering, it automatically navigates the user to the `PartiePage` with
/// Survival Mode settings. While the transition is in progress, a loading indicator
/// is displayed.
///
/// Features:
/// - Initializes Survival Mode with default settings:
///   - Initial word length: 3
///   - Initial number of attempts: 10
/// - Displays a loading indicator during navigation.
class SurvivalGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     int initialWordLength = 3;
     int initialAttempts = 10;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PartiePage(
            wordLength: initialWordLength,
            attempts: initialAttempts,
            isSurvivalMode: true,
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Starting Survival Mode...'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

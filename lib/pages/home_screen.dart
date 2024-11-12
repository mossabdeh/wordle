import 'package:flutter/material.dart';
import 'classic_game_screen.dart';
import 'survival_game_screen.dart';
import 'dual_game_screen.dart';
import 'stats_screen.dart'; // Import the StatsScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle Game Modes'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClassicGameScreen()),
                );
              },
              child: const Text('Partie Classic'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SurvivalGameScreen()),
                );
              },
              child: const Text('Partie Survival'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DualGameScreen()),
                );
              },
              child: const Text('Partie Dual'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatsScreen()), // Navigate to StatsScreen
                );
              },
              child: const Text('View Stats'),
            ),
          ],
        ),
      ),
    );
  }
}

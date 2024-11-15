import 'package:flutter/material.dart';
import 'package:wordle/pages/stats_page.dart';
import 'classic_game_screen.dart';
import 'survival_game_screen.dart';

import 'stats_screen.dart'; // Import the StatsScreen
import 'package:wordle/components/rounds_dialogue_duel.dart';


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
                showRoundsDialog(context); // Open dialog to set number of rounds
              },
              child: const Text('Partie Dual'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatsScreen()),
                );
              },
              child: const Text('View Stats'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StatsPage()),
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

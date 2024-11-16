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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Increased AppBar height
        child: AppBar(
          title: const Text(
            'Wordle Game Modes',
            style: TextStyle(
              color: Color(0xFF6B8E23), // Olive Green
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 24, // Increased font size
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFFAF3E0), // Soft Cream
          elevation: 0,
          iconTheme: const IconThemeData(color: Color(0xFF6B8E23)),
          toolbarHeight: 100, // Larger AppBar height
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FloatingActionButton(
                heroTag: "statsButton", // Ensures unique tag if multiple FABs are used
                elevation: 2, // Slight elevation for better visibility
                backgroundColor: const Color(0xFF6B8E23), // Olive Green background
                mini: true, // Smaller size to fit AppBar
                child: const Icon(
                  Icons.bar_chart,
                  color: Colors.white, // White icon for contrast
                  size: 30, // Icon size
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StatsPage(),
                    ),
                  );
                },
                tooltip: 'Statistics', // Tooltip for better accessibility
              ),
            ),
          ],



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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20), // Larger margin between AppBar and content
            Expanded(
              child: ListView(
                children: [
                  _buildGameModeCard(
                    context,
                    icon: Icons.games,
                    title: 'Partie Classic',
                    subtitle: 'Play the classic Wordle game.',
                    color: const Color(0xFF6B8E23),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassicGameScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildGameModeCard(
                    context,
                    icon: Icons.auto_graph,
                    title: 'Partie Survival',
                    subtitle: 'Test your endurance with survival mode.',
                    color: const Color(0xFF0E7C86),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurvivalGameScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildGameModeCard(
                    context,
                    icon: Icons.group,
                    title: 'Partie Dual',
                    subtitle: 'Challenge your friends in dual mode.',
                    color: const Color(0xFFD2691E),
                    onTap: () {
                      showRoundsDialog(context); // Show rounds dialog for dual mode
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildGameModeCard(
                    context,
                    icon: Icons.bar_chart,
                    title: 'View Stats',
                    subtitle: 'Check your game statistics.',
                    color: const Color(0xFFDEB887),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StatsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameModeCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap, // Navigation callback
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(2, 4),
              blurRadius: 8,
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

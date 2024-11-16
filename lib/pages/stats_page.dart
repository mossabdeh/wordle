import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/Observer.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: const Text(
            'Game Statistics',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
              fontSize: 24,
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
            colors: [Color(0xFFFAF3E0), Color(0xFFDCE7C5)], // Subtle cream gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Consumer<Observer>(
          builder: (context, observer, child) {
            return FutureBuilder<int>(
              future: observer.totalGamesPlayed, // Fetch total games played
              builder: (context, totalSnapshot) {
                return FutureBuilder<double>(
                  future: observer.winPercentage, // Fetch win percentage
                  builder: (context, winSnapshot) {
                    return FutureBuilder<double>(
                      future: observer.averageAttempts, // Fetch average attempts
                      builder: (context, avgSnapshot) {
                        if (totalSnapshot.connectionState == ConnectionState.waiting ||
                            winSnapshot.connectionState == ConnectionState.waiting ||
                            avgSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (totalSnapshot.hasError || winSnapshot.hasError || avgSnapshot.hasError) {
                          return Center(
                            child: const Text(
                              'Error loading statistics',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 16,
                                color: Color(0xFF6B8E23), // Olive Green
                              ),
                            ),
                          );
                        }

                        final totalGames = totalSnapshot.data ?? 0;
                        final winPercent = winSnapshot.data ?? 0.0;
                        final avgAttempts = avgSnapshot.data ?? 0.0;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildStatCard(
                              icon: Icons.sports_esports,
                              title: 'Total Games Played',
                              value: '$totalGames',
                              color: const Color(0xFF6B8E23),
                            ),
                            const SizedBox(height: 20),
                            _buildStatCard(
                              icon: Icons.emoji_events,
                              title: 'Win Percentage',
                              value: '${winPercent.toStringAsFixed(2)}%',
                              color: const Color(0xFF6B8E23),
                            ),
                            const SizedBox(height: 20),
                            _buildStatCard(
                              icon: Icons.timeline,
                              title: 'Average Attempts',
                              value: '${avgAttempts.toStringAsFixed(2)}',
                              color: const Color(0xFF6B8E23),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2), // Light olive green background for the icon
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: color,
              ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

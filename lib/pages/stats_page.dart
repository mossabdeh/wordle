import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/Observer.dart';

//TODO best survie
class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Statistics'),
      ),
      body: Consumer<Observer>(
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
                        return Center(child: Text('Error loading statistics'));
                      }

                      final totalGames = totalSnapshot.data ?? 0;
                      final winPercent = winSnapshot.data ?? 0.0;
                      final avgAttempts = avgSnapshot.data ?? 0.0;

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Games Played: $totalGames"),
                            Text("Win Percentage: ${winPercent.toStringAsFixed(2)}%"),
                            Text("Average Attempts: ${avgAttempts.toStringAsFixed(2)}"),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

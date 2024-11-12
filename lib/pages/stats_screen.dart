import 'package:flutter/material.dart';

import '../dao/partie_dao.dart';
import '../entities/partie.dart';


class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late Future<List<PartieEntity>> _partiesFuture;

  @override
  void initState() {
    super.initState();
    _partiesFuture = PartieDAO().getParties(); // Fetch saved games on init
  }

  List<String> formatGuessedLetters(String guessedLetters, int wordLength) {
    List<String> attempts = [];
    for (int i = 0; i < guessedLetters.length; i += wordLength) {
      attempts.add(guessedLetters.substring(i, i + wordLength));
    }
    return attempts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Stats'),
      ),
      body: FutureBuilder<List<PartieEntity>>(
        future: _partiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No game data found.'));
          } else {
            final parties = snapshot.data!;
            return ListView.builder(
              itemCount: parties.length,
              itemBuilder: (context, index) {
                final partie = parties[index];
                final attempts = formatGuessedLetters(partie.guessedLetters, partie.wordLength);

                return ListTile(
                  title: Text("Secret Word: ${partie.secretWord}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: ${partie.date}"),
                      Text("Attempts: ${partie.attempts}"),
                      Text("Game Mode: ${partie.gameMode}"),
                      const SizedBox(height: 5),
                      Text("Guessed Letters:"),
                      ...attempts.map((attempt) => Text(attempt)).toList(),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

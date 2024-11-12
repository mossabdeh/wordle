import 'package:flutter/material.dart';

import '../dao/partie_dao.dart';
import '../entities/partie.dart'; // Import PartieEntity

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
                return ListTile(
                  title: Text("Secret Word: ${partie.secretWord}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: ${partie.date}"),
                      Text("Attempts: ${partie.attempts}"),
                      Text("Guessed Letters: ${partie.guessedLetters}"),
                      Text("Game Mode: ${partie.gameMode}"),
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

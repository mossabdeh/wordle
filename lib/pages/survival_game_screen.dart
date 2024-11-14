import 'package:flutter/material.dart';
import 'partie_page.dart';

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

import 'package:flutter/material.dart';

class SurvivalGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partie Survival'),
      ),
      body: const Center(
        child:  Text('Survival Mode Gameplay Here'),
      ),
    );
  }
}

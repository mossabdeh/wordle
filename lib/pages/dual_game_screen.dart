import 'package:flutter/material.dart';

class DualGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partie Dual'),
      ),
      body: const Center(
        child:  Text('Dual Mode Gameplay Here'),
      ),
    );
  }
}

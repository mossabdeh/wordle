import 'package:flutter/material.dart';
import 'partie_page.dart'; // Import PartiePage

class ClassicGameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partie Classic'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PartiePage()),
            );
          },
          child: const Text('Start Classic Game'),
        ),
      ),
    );
  }
}

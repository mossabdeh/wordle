import 'package:flutter/material.dart';
import 'partie_page.dart';

class ClassicGameScreen extends StatefulWidget {
  @override
  _ClassicGameScreenState createState() => _ClassicGameScreenState();
}

class _ClassicGameScreenState extends State<ClassicGameScreen> {
  final TextEditingController wordLengthController = TextEditingController(text: '5');
  final TextEditingController attemptsController = TextEditingController(text: '6');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partie Classic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: wordLengthController,
              decoration: const InputDecoration(
                labelText: 'Word Length (3-10)',
                hintText: 'Enter the length of the word (e.g., 5)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final length = int.tryParse(value) ?? 5;
                if (length < 3) {
                  wordLengthController.text = '3';
                } else if (length > 10) {
                  wordLengthController.text = '10';
                }
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: attemptsController,
              decoration: const InputDecoration(
                labelText: 'Number of Attempts (1-10)',
                hintText: 'Enter the number of attempts (e.g., 6)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final attempts = int.tryParse(value) ?? 6;
                if (attempts < 1) {
                  attemptsController.text = '1';
                } else if (attempts > 10) {
                  attemptsController.text = '10';
                }
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final wordLength = int.tryParse(wordLengthController.text) ?? 5;
                final attempts = int.tryParse(attemptsController.text) ?? 6;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PartiePage(
                      wordLength: wordLength,
                      attempts: attempts,
                    ),
                  ),
                );
              },
              child: const Text('Start Classic Game'),
            ),
          ],
        ),
      ),
    );
  }
}

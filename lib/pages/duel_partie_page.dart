import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Observer.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';

class DuelPartiePage extends StatelessWidget {
  final int wordLength;
  final int attempts;

  const DuelPartiePage({
    Key? key,
    required this.wordLength,
    required this.attempts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Reuse the existing Observer from the parent
    final observer = Provider.of<Observer>(context);

    return Column(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            color: Colors.white10,
            child: Grid(
              wordLength: wordLength,
              attempts: attempts,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.white10,
            child: Column(
              children: const [
                Flexible(child: keyBoardRow(min: 1, max: 7)),
                Flexible(child: keyBoardRow(min: 8, max: 15)),
                Flexible(child: keyBoardRow(min: 16, max: 23)),
                Flexible(child: keyBoardRow(min: 24, max: 29)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "DEBUG: isDuelMode = ${observer.isDuelMode}",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

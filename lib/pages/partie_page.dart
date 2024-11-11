import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/Observer.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';
import '../components/Partiedialogue.dart';

class PartiePage extends StatelessWidget {
  const PartiePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<Observer>(
        builder: (context, observer, child) {
          if (observer.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show win dialog if the game is won
          if (observer.hasWon) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showWinDialog(context);
            });
          }

          // Show loss dialog if the game is lost
          if (observer.hasLost) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showLossDialog(context, observer.winningWord);
            });
          }

          return Column(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  color: Colors.white10,
                  child: const Grid(),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.white10,
                  child: const Column(
                    children: [
                      keyBoardRow(min: 1, max: 7),
                      keyBoardRow(min: 8, max: 15),
                      keyBoardRow(min: 16, max: 23),
                      keyBoardRow(min: 24, max: 29),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

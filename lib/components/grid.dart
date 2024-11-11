import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/Observer.dart';
import 'letter_taped_widget.dart';

class Grid extends StatelessWidget {
  const Grid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Observer>(
      builder: (context, observer, child) {
        return GridView.builder(
          itemCount: 30,
          padding: const EdgeInsets.fromLTRB(36, 20, 36, 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            crossAxisCount: 5,
          ),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: LetterTapedWidget(index: index),
            );
          },
        );
      },
    );
  }
}

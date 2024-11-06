import 'package:wordle/entities/lettre.dart';

class Mot {
  final String text;
  final List<Lettre> feedback;

  Mot({
    required this.text,
    this.feedback = const [],
  });
}
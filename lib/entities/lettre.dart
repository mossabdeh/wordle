enum LettreStatus {
  correctPosition,  // couleur Vert
  wrongPosition,  // couleur Jaun
  incorrect,  // couleur Gris
}

class Lettre {
  final String char;
  final LettreStatus status;

  Lettre({
    required this.char,
    required this.status,
  });
}

import 'package:flutter/foundation.dart';

class Partida extends ChangeNotifier {
  bool ativa;
  int id;
  int idCategoriaPerguntas;

  Partida({
    this.ativa,
    this.id,
    this.idCategoriaPerguntas,
  });
}

class Pergunta {
  String _titulo;
  int _resposta;
  List<String> _possiveisRespostas;

  Pergunta(this._titulo, this._resposta, this._possiveisRespostas);

  set titulo(String titulo) {
    this._titulo = titulo;
  }

  get titulo {
    return this._titulo;
  }

  get resposta {
    return this._resposta;
  }

  set possivelRespota(List<String> r) {
    this._possiveisRespostas = r;
  }

  get possivelRespota {
    return this._possiveisRespostas;
  }
}

class Figurinha {
  final int id;
  final String numero;
  final String nome;
  final String pais;
  final String emoji;
  final String grupo;

  const Figurinha({
    required this.id, required this.numero, required this.nome,
    required this.pais, required this.emoji, required this.grupo,
  });
}

class Usuario {
  final String id;
  final String nome;
  final String telefone;
  final String cidade;
  final String estado;
  final List<int> repetidas;
  final List<int> faltam; // ← NOVO: figurinhas que precisa

  const Usuario({
    required this.id, required this.nome, required this.telefone,
    required this.cidade, required this.estado,
    this.repetidas = const [], this.faltam = const [],
  });

  Usuario copyWith({List<int>? repetidas, List<int>? faltam}) {
    return Usuario(
      id: id, nome: nome, telefone: telefone, cidade: cidade, estado: estado,
      repetidas: repetidas ?? this.repetidas,
      faltam: faltam ?? this.faltam,
    );
  }
}

enum StatusTroca { pendente, aceita, recusada, confirmada }

class Troca {
  final String id;
  final Usuario solicitante;
  final StatusTroca status;
  final List<int> figurinhasSolicitante;
  final List<int> figurinhasReceptor;
  final bool trocaPerfeita; // ← NOVO
  final DateTime criadaEm;
  final Encontro? encontro;

  const Troca({
    required this.id, required this.solicitante, required this.status,
    required this.figurinhasSolicitante, required this.figurinhasReceptor,
    required this.criadaEm, this.trocaPerfeita = false, this.encontro,
  });

  Troca copyWith({StatusTroca? status, Encontro? encontro}) {
    return Troca(
      id: id, solicitante: solicitante, status: status ?? this.status,
      figurinhasSolicitante: figurinhasSolicitante,
      figurinhasReceptor: figurinhasReceptor,
      trocaPerfeita: trocaPerfeita, criadaEm: criadaEm,
      encontro: encontro ?? this.encontro,
    );
  }
}

class Encontro {
  final String shopping;
  final String capital;
  final DateTime dataHora;
  const Encontro({required this.shopping, required this.capital, required this.dataHora});
}

class Question {
  final int id;
  final String pergunta;
  final List<String> opcoes;
  final String resposta;
  final String dificuldade;
  final String explicacao;

  Question({
    required this.id,
    required this.pergunta,
    required this.opcoes,
    required this.resposta,
    required this.dificuldade,
    required this.explicacao,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      pergunta: json['pergunta'],
      opcoes: List<String>.from(json['opcoes']),
      resposta: json['resposta'],
      dificuldade: json['dificuldade'],
      explicacao: json['explicacao'],
    );
  }
}
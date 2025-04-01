class Question {
  final int? id; // Pode ser nulo se não existir
  final String pergunta; // Texto da pergunta
  final List<String> opcoes; // Opções de resposta
  final String resposta; // Resposta correta
  final String? dificuldade; // Opcional
  final String? explicacao; // Opcional

  Question({
    this.id,
    required this.pergunta,
    required this.opcoes,
    required this.resposta,
    this.dificuldade,
    this.explicacao,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int?,
      pergunta: json['pergunta'] ?? json['texto'] ?? 'Pergunta não fornecida', // Suporte a nomes alternativos
      opcoes: List<String>.from(json['opcoes'] ?? json['alternativas'] ?? []),
      resposta: json['resposta'] ?? json['resposta_certa'] ?? '',
      dificuldade: json['dificuldade'] ?? json['nivel'] ?? 'Fácil', // Padrão: Fácil
      explicacao: json['explicacao'] ?? json['detalhe'] ?? 'Sem explicação disponível',
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/storage_service.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final storageService = StorageService();
    final date = DateTime.now().toString().substring(0, 19);

    storageService.saveScore(gameProvider.score, date);

    return Scaffold(
      appBar: AppBar(title: Text('Resultado')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Sua pontuação: ${gameProvider.score}', style: TextStyle(fontSize: 30)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Correção'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: gameProvider.wrongAnswers.isEmpty
                            ? [Text('Parabéns! Você acertou tudo!')]
                            : gameProvider.wrongAnswers.map((answer) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Pergunta: ${answer['pergunta']}', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Sua resposta: ${answer['selecionada']}'),
                                    Text('Correta: ${answer['resposta']}', style: TextStyle(color: Colors.green)),
                                    Text('Explicação: ${answer['explicacao']}', style: TextStyle(fontStyle: FontStyle.italic)),
                                    SizedBox(height: 15),
                                  ],
                                )),
                      ),
                    ),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Fechar'))],
                  ),
                );
              },
              child: Text('Ver Correção'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final scores = await storageService.getScores();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Histórico de Pontuações'),
                    content: SingleChildScrollView(
                      child: Column(
                        children: scores.isEmpty
                            ? [Text('Nenhum jogo registrado ainda.')]
                            : scores.map((score) => Text(score)).toList(),
                      ),
                    ),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Fechar'))],
                  ),
                );
              },
              child: Text('Ver Histórico'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                gameProvider.resetGame();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Voltar ao Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
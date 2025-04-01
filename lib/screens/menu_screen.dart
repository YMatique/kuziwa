import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? _selectedDifficulty;
  int? _selectedNumberOfQuestions;

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    if (gameProvider.categories.isEmpty) { // Verifica se as categorias estão carregadas
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final categories = gameProvider.categories;
    return Scaffold(
      appBar: AppBar(title: Text('Kuziwa - Trivia de Moçambique')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text('Escolha a dificuldade'),
              value: _selectedDifficulty,
              items: ['Fácil', 'Médio', 'Difícil']
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedDifficulty = value),
            ),
            SizedBox(height: 10),
            DropdownButton<int>(
              hint: Text('Número de perguntas'),
              value: _selectedNumberOfQuestions,
              items: [10, 15, 20]
                  .map((n) => DropdownMenuItem(value: n, child: Text('$n perguntas')))
                  .toList(),
              onChanged: (value) => setState(() => _selectedNumberOfQuestions = value),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCategoryTile(context, 'Mesclar Categorias', gameProvider),
                  ...categories.map((category) => _buildCategoryTile(context, category, gameProvider)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String category, GameProvider gameProvider) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(category, style: TextStyle(fontSize: 18)),
        onTap: (_selectedDifficulty != null && _selectedNumberOfQuestions != null)
            ? () {
                gameProvider.startGame(category, _selectedDifficulty!, _selectedNumberOfQuestions!);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GameScreen()),
                );
              }
            : null,
      ),
    );
  }
}
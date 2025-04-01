import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import '../models/question.dart';

class GameProvider with ChangeNotifier {
  Map<String, List<Question>> _questionsData = {};
  List<Question> _currentQuestions = [];
  int _score = 0;
  int _questionIndex = 0;
  int _timeLeft = 30;
  Timer? _timer;
  List<Map<String, dynamic>> _wrongAnswers = [];
  bool _isPaused = false;
  int _numberOfQuestions = 10; // Valor padrão

  GameProvider() {
    _loadQuestions();
  }

  int get score => _score;
  int get questionIndex => _questionIndex;
  int get timeLeft => _timeLeft;
  List<Question> get currentQuestions => _currentQuestions;
  List<Map<String, dynamic>> get wrongAnswers => _wrongAnswers;
  bool get isPaused => _isPaused;
  int get numberOfQuestions => _numberOfQuestions;

  Future<void> _loadQuestions() async {
    final String response = await rootBundle.loadString('assets/questions.json');
    final data = json.decode(response) as Map<String, dynamic>;
    _questionsData = data.map((key, value) => MapEntry(
          key,
          (value as List).map((q) => Question.fromJson(q)).toList(),
        ));
    notifyListeners();
  }

  void startGame(String category, String difficulty, int numberOfQuestions) {
    _score = 0;
    _questionIndex = 0;
    _wrongAnswers.clear();
    _numberOfQuestions = numberOfQuestions;

    List<Question> allQuestions;
    if (category == 'Mesclar') {
      allQuestions = _questionsData.values
          .expand((q) => q)
          .where((q) => q.dificuldade == difficulty)
          .toList();
    } else {
      allQuestions = _questionsData[category]!
          .where((q) => q.dificuldade == difficulty)
          .toList();
    }
    allQuestions.shuffle(Random());
    _currentQuestions = allQuestions.take(_numberOfQuestions).toList();
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused && _timeLeft > 0) {
        _timeLeft--;
        notifyListeners();
      } else if (_timeLeft == 0) {
        _timer!.cancel();
        answerQuestion(null);
      }
    });
  }

  void answerQuestion(String? selectedOption) {
    _timer?.cancel();
    final currentQuestion = _currentQuestions[_questionIndex];
    final isCorrect = selectedOption == currentQuestion.resposta;
    if (isCorrect) {
      _score += 10;
    } else {
      _wrongAnswers.add({
        'pergunta': currentQuestion.pergunta,
        'resposta': currentQuestion.resposta,
        'selecionada': selectedOption ?? 'Tempo esgotado',
        'explicacao': currentQuestion.explicacao,
      });
    }
    _questionIndex++;
    if (_questionIndex < _currentQuestions.length) {
      _startTimer();
    }
    notifyListeners();
  }

  void pauseGame() {
    _isPaused = true;
    notifyListeners();
  }

  void resumeGame() {
    _isPaused = false;
    _startTimer();
    notifyListeners();
  }

  void resetGame() {
    _score = 0;
    _questionIndex = 0;
    _timeLeft = 30;
    _wrongAnswers.clear();
    _timer?.cancel();
    notifyListeners();
  }
}
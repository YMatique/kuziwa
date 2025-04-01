import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _scoresKey = 'scores';

  Future<void> saveScore(int score, String date) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> scores = prefs.getStringList(_scoresKey) ?? [];
    scores.add('$date: $score');
    await prefs.setStringList(_scoresKey, scores);
  }

  Future<List<String>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_scoresKey) ?? [];
  }
}
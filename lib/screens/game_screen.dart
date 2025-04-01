import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  FlutterSoundPlayer _player = FlutterSoundPlayer();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _startBackgroundMusic();
  }

  void _startBackgroundMusic() async {
    await _player.startPlayer(
      fromURI: 'assets/audio/background_music.mp3',
      codec: Codec.mp3,
      whenFinished: _startBackgroundMusic,
    );
  }

  void _playSound(bool isCorrect) async {
    await _player.startPlayer(
      fromURI: isCorrect ? 'assets/audio/correct.mp3' : 'assets/audio/wrong.wav',
      codec: Codec.mp3,
    );
  }

  @override
  void dispose() {
    _player.stopPlayer();
    _player.closePlayer();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        if (gameProvider.questionIndex >= gameProvider.currentQuestions.length) {
          return ResultScreen();
        }

        final currentQuestion = gameProvider.currentQuestions[gameProvider.questionIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text('Kuziwa - ${gameProvider.questionIndex + 1}/${gameProvider.numberOfQuestions}'),
            actions: [
              IconButton(
                icon: Icon(gameProvider.isPaused ? Icons.play_arrow : Icons.pause),
                onPressed: () {
                  if (gameProvider.isPaused) {
                    gameProvider.resumeGame();
                  } else {
                    gameProvider.pauseGame();
                  }
                },
              ),
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green[200]!, Colors.yellow[200]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Pontuação: ${gameProvider.score}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    height: 10,
                    child: LinearProgressIndicator(
                      value: gameProvider.timeLeft / 30,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red[800]!),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(currentQuestion.pergunta, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  ...currentQuestion.opcoes.map((option) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: gameProvider.isPaused
                                ? null
                                : () {
                                    _playSound(option == currentQuestion.resposta);
                                    _animationController.forward().then((_) {
                                      gameProvider.answerQuestion(option);
                                      _animationController.reset();
                                    });
                                  },
                            child: Text(option, style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
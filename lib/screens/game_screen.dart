import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'leaderboard_screen.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  int _questionIndex = 0;
  int _score = 0;
  bool _isGameOver = false;
  double _timerValue = 10.0;
  Timer? _timer;
  List<Map<String, Object>> _questions = [];
  AnimationController? _animationController;
  Animation<double>? _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _initializeQuestions();
    _shuffleQuestions();
    _startTimer();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeIn,
    );

    if (_isGameOver) {
      _animationController?.forward();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  void _initializeQuestions() {
    _questions = [
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.lime, Colors.purple], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.cyan, Colors.yellowAccent], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.tealAccent, Colors.deepPurpleAccent], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.yellow, Colors.pink], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.lightBlueAccent, Colors.green], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.pinkAccent, Colors.lime], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.brown, Colors.cyan], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.orangeAccent, Colors.green], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.brown, Colors.teal], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.orange, Colors.purple], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.brown, Colors.yellowAccent], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.lightGreen, Colors.purpleAccent], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.lightGreen, Colors.pinkAccent], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.lightBlue, Colors.deepOrange], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.grey, Colors.blueAccent], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.green, Colors.blue], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.purple, Colors.lime], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.orangeAccent, Colors.green], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.grey, Colors.red], 'answer': true},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.green, Colors.blueGrey], 'answer': true},
      // Несочетаемые цвета
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.red, Colors.green], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.blue, Colors.orange], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.yellow, Colors.purple], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.brown, Colors.black], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.pink, Colors.orange], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.blue, Colors.brown], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.red, Colors.pink], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.green, Colors.purple], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.yellow, Colors.green], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.red, Colors.purple], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.blue, Colors.red], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.orange, Colors.green], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.brown, Colors.grey], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.pink, Colors.brown], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.green, Colors.grey], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.red, Colors.blue], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.yellow, Colors.grey], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.purple, Colors.orange], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.blue, Colors.yellow], 'answer': false},
      {'questionText': 'Сочетаются ли эти цвета?', 'colors': [Colors.brown, Colors.yellow], 'answer': false},
    ];
  }

  void _shuffleQuestions() {
    _questions.shuffle();
  }

  void _startTimer() {
    const oneTenth = const Duration(milliseconds: 100);
    _timer = Timer.periodic(oneTenth, (timer) {
      setState(() {
        if (_timerValue <= 0) {
          _timer?.cancel();
          _isGameOver = true;
          _animationController?.forward();
          _saveScore(); // Сохранение результатов после окончания игры
        } else {
          _timerValue -= 0.1;
        }
      });
    });
  }

  void _answerQuestion(bool answer) {
    if (_questionIndex < _questions.length) {
      setState(() {
        if (_questions[_questionIndex]['answer'] == answer) {
          _score++;
          _timerValue = min(_timerValue + 0.5, 10.0); // Добавить 0.5 секунды, но не более 10 секунд
        } else {
          _timerValue = max(_timerValue - 0.5, 0.0); // Уменьшить 0.5 секунды, но не менее 0 секунд
        }
        _questionIndex++;
        if (_questionIndex >= _questions.length) {
          _isGameOver = true;
          _animationController?.forward();
          _saveScore(); // Сохранение результатов после окончания игры
        }
      });
    }
  }

  Future<void> _saveScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentReference userScoreRef = FirebaseFirestore.instance.collection('scores').doc(user.uid);
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot userScoreSnapshot = await transaction.get(userScoreRef);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (!userScoreSnapshot.exists) {
          transaction.set(userScoreRef, {
            'bestScore': _score,
            'nickname': userSnapshot['nickname'], // добавление поля nickname
          });
        } else {
          int bestScore = userScoreSnapshot['bestScore'];
          if (_score > bestScore) {
            transaction.update(userScoreRef, {'bestScore': _score});
          }
        }
      }).catchError((error) {
        _showErrorDialog('Ошибка сохранения результата. Попробуйте еще раз.');
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ошибка'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('ОК'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      _questionIndex = 0;
      _score = 0;
      _timerValue = 10.0;
      _isGameOver = false;
      _shuffleQuestions();
      _startTimer();
    });
    _animationController?.reset();
  }

  void _showLeaderboard() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => LeaderboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.timer),
                SizedBox(width: 5),
                Text('${_timerValue.toInt()}'), // Отображение времени в секундах
              ],
            ),
            Spacer(),
            Text('$_score', style: TextStyle(fontSize: 20, color: Colors.black)),
            SizedBox(width: 5), // Расстояние между счетом и кубком
            Icon(Icons.emoji_events),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10), // Уменьшение ширины на 10 пикселей с каждой стороны
                height: 20, // Увеличение высоты на 5 пикселей с каждой стороны
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Округление полоски на 10
                  child: LinearProgressIndicator(
                    value: _timerValue / 10.0, // Прогресс таймера от 0 до 1
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: _isGameOver
                      ? FadeTransition(
                    opacity: _fadeInAnimation!,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Попробуй еще раз!',
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Игра окончена!\nВаш счет ${_score}/${_questionIndex}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _restartGame,
                          child: Text(
                            'Начать заново',
                            style: TextStyle(fontSize: 24), // Увеличение размера текста кнопки
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 60), // Увеличение размера кнопки в два раза
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                        ),
                        SizedBox(height: 20), // Отступ перед кнопкой таблицы лидеров
                        ElevatedButton(
                          onPressed: _showLeaderboard,
                          child: Text(
                            'Таблица лидеров',
                            style: TextStyle(fontSize: 24), // Увеличение размера текста кнопки
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 60), // Увеличение размера кнопки
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                        ),
                      ],
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _questions[_questionIndex]['questionText'] as String,
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                color: (_questions[_questionIndex]['colors'] as List<Color>)[0],
                              ),
                              Text('Color 1'),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                color: (_questions[_questionIndex]['colors'] as List<Color>)[1],
                              ),
                              Text('Color 2'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _answerQuestion(true),
                            child: Icon(Icons.check, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _answerQuestion(false),
                            child: Icon(Icons.close, color: Colors.white),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

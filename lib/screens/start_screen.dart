import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'game_screen.dart';
import 'login_screen.dart';

class StartScreen extends StatelessWidget {
  final User? user;

  // Конструктор принимает объект User, который может быть null, если пользователь не авторизован
  StartScreen({required this.user});

  // Функция для выхода из системы
  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB6FFFB), // Цвет фона AppBar
        elevation: 0,
      ),
      body: Container(
        color: Color(0xFFB6FFFB), // Цвет фона экрана
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ColorMatch',
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: 'PottaOne',
                  color: Color(0xFF104089),
                ),
                textAlign: TextAlign.center,
              ),
              if (user != null) ...[
                SizedBox(height: 20),
                Text(
                  'Добро пожаловать, ${user!.email}',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameScreen()),
                  );
                },
                child: Text('Начать'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: user != null
                    ? () => _signOut(context)
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(user != null ? 'Выйти' : 'Войти'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: user != null ? Colors.red : Colors.blueGrey,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

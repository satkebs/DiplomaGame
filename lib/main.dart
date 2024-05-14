import 'package:flutter/material.dart';
import 'screens/start_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Match',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFB6FFFB), // Цвет фона для всего приложения
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          backgroundColor: Color(0xFFB6FFFB), // Цвет фона для AppBar
        ),
      ),
      home: StartScreen(),
    );
  }
}

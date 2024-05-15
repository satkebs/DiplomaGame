import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/start_screen.dart';
import 'screens/login_screen.dart';
import 'screens/game_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      initialRoute: '/',
      routes: {
        '/': (context) => StartScreen(),
        '/login': (context) => LoginScreen(),
        '/game': (context) => GameScreen(),
        '/leaderboard': (context) => LeaderboardScreen(),
      },
    );
  }
}

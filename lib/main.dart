import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // Здесь можно добавить код для отправки ошибок в логирующую систему
  };

  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    print('Caught error: $error');
    // Здесь можно добавить код для отправки ошибок в логирующую систему
  });
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

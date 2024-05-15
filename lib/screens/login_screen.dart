import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  bool _isRegistering = false;

  void _toggleFormType() {
    setState(() {
      _isRegistering = !_isRegistering;
    });
  }

  void _register() async {
    try {
      // Проверяем, существует ли уже такой никнейм
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('nickname', isEqualTo: _nicknameController.text.trim())
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        throw FirebaseAuthException(code: 'nickname-already-in-use');
      }

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'nickname': _nicknameController.text.trim(),
      });

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Эта почта уже зарегистрирована';
          break;
        case 'invalid-email':
          errorMessage = 'Неверный формат email';
          break;
        case 'weak-password':
          errorMessage = 'Пароль должен состоять минимум из 6 символов';
          break;
        case 'nickname-already-in-use':
          errorMessage = 'Этот никнейм уже занят, попробуйте другой';
          break;
        default:
          errorMessage = 'Произошла ошибка. Попробуйте еще раз';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog('Произошла ошибка. Попробуйте еще раз');
    }
  }

  void _signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Пользователь с таким email не найден';
          break;
        case 'wrong-password':
          errorMessage = 'Неверный пароль';
          break;
        case 'invalid-email':
          errorMessage = 'Неверный формат email';
          break;
        default:
          errorMessage = 'Произошла ошибка. Попробуйте еще раз';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      _showErrorDialog('Произошла ошибка. Попробуйте еще раз');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering ? 'Регистрация' : 'Войти'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isRegistering)
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: 'Nickname'),
              ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isRegistering ? _register : _signIn,
              child: Text(_isRegistering ? 'Зарегистрироваться' : 'Войти'),
            ),
            TextButton(
              onPressed: _toggleFormType,
              child: Text(_isRegistering
                  ? 'Уже есть аккаунт? Войти'
                  : 'Нет аккаунта? Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}

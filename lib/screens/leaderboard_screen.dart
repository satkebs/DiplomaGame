import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Получаем текущего пользователя
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Таблица лидеров'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Подписываемся на изменения коллекции 'scores', сортируя по полю 'bestScore' в порядке убывания
        stream: FirebaseFirestore.instance.collection('scores').orderBy('bestScore', descending: true).snapshots(),
        builder: (ctx, snapshot) {
          // Если данные еще не загрузились, показываем индикатор загрузки
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Если произошла ошибка при загрузке данных, показываем сообщение об ошибке
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          // Получаем документы из snapshot
          final docs = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (ctx, index) {
              final data = docs[index];
              // Проверяем, является ли текущий пользователь владельцем этого документа
              final isCurrentUser = data.id == user?.uid;

              return ListTile(
                leading: CircleAvatar(
                  child: Text('#${index + 1}'), // Позиция в таблице лидеров
                ),
                title: Text('Nickname: ${data['nickname']}'),
                subtitle: Text('Best Score: ${data['bestScore']}'),
                // Если это текущий пользователь, выделяем его строку
                tileColor: isCurrentUser ? Colors.blueAccent.withOpacity(0.2) : null,
                titleTextStyle: isCurrentUser
                    ? TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
                    : null,
                subtitleTextStyle: isCurrentUser
                    ? TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}

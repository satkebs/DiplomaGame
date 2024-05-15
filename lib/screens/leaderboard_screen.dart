import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Таблица лидеров'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('scores').orderBy('bestScore', descending: true).snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? [];
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (ctx, index) {
              final data = docs[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('#${index + 1}'),
                ),
                title: Text('Nickname: ${data['nickname']}'),
                subtitle: Text('Best Score: ${data['bestScore']}'),
              );
            },
          );
        },
      ),
    );
  }
}

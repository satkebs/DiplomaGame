import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Таблица лидеров'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('scores')
            .orderBy('bestScore', descending: true)
            .limit(10)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final scores = snapshot.data!.docs;

          return ListView.builder(
            itemCount: scores.length,
            itemBuilder: (context, index) {
              final score = scores[index];
              final nickname = score['nickname']; // Извлечение никнейма из документа
              final bestScore = score['bestScore'];

              return ListTile(
                title: Text('Nickname: $nickname'),
                subtitle: Text('Best Score: $bestScore'),
                leading: CircleAvatar(
                  child: Text('#${index + 1}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

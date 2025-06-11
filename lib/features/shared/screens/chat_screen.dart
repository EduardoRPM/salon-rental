import 'package:flutter/material.dart';

/// Pantalla básica de chat entre usuarios.
class ChatScreen extends StatelessWidget {
  final String userId;
  final String userName;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con $userName'),
      ),
      body: const Center(
        child: Text('Chat en construcción'),
      ),
    );
  }
}

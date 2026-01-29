import 'package:flutter/material.dart';

class UserChatPage extends StatelessWidget {
  const UserChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat ke Admin (User)")),
      body: const Center(child: Text("Chat user -> admin di sini")),
    );
  }
}

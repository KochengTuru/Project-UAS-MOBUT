import 'package:flutter/material.dart';

class AdminChatPage extends StatelessWidget {
  const AdminChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat Admin (Balas User)")),
      body: const Center(child: Text("Admin balas chat user di sini")),
    );
  }
}

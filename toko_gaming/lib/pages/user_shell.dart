import 'package:flutter/material.dart';

import 'user/user_products_page.dart';
import 'user/user_history_page.dart';
import 'user/user_articles_page.dart';
import 'user/user_chat_page.dart';
import 'user/user_profile_page.dart';

import '../core/session.dart';
import '../core/welcome_helper.dart';

class UserShell extends StatefulWidget {
  const UserShell({super.key});

  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  int _i = 0;

  final _pages = const [
    UserProductsPage(),
    UserHistoryPage(),
    UserArticlesPage(),
    UserChatPage(),
    UserProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _showWelcomeUser();
  }

  Future<void> _showWelcomeUser() async {
    final u = await Session.getUser();
    final name = "${u["name"] ?? "User"}";
    final id = "${u["id"] ?? "0"}";

    if (!mounted) return;

    await WelcomeHelper.showOnce(
      context: context,
      key: "welcome_user_$id",
      title: "Selamat Datang 🎮",
      message: "Halo, $name 👋\nSelamat datang di Toko Peralatan Gaming.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_i],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _i,
        onTap: (v) => setState(() => _i = v),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "Product"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Article"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat Admin"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

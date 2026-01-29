import 'package:flutter/material.dart';

import 'products/admin_products_page.dart';
import 'admin/admin_orders_page.dart';
import 'admin/admin_articles_page.dart';
import 'admin/admin_chat_page.dart';
import 'admin/admin_profile_page.dart';

import '../core/session.dart';
import '../core/welcome_helper.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _i = 0;

  final _pages = const [
    AdminProductsPage(),
    AdminOrdersPage(),
    AdminArticlesPage(),
    AdminChatPage(),
    AdminProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _showWelcomeAdmin();
  }

  Future<void> _showWelcomeAdmin() async {
    final u = await Session.getUser();
    final name = "${u["name"] ?? "Administrator"}";
    final id = "${u["id"] ?? "0"}";

    if (!mounted) return;

    await WelcomeHelper.showOnce(
      context: context,
      key: "welcome_admin_$id",
      title: "Welcome ADMIN",
      message: "Halo, $name 👋\nKamu masuk sebagai ADMIN.",
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
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: "CRUD Product"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Riwayat User"),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), label: "CRUD Article"),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: "Chat Admin"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

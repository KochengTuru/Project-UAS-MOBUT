import 'package:flutter/material.dart';
import '../../core/session.dart';

// Ganti import ini sesuai file user kamu
import 'user_products_page.dart';
import 'user_history_page.dart';
import '../articles/user_articles_page.dart'; // kalau belum ada, nanti saya bikinkan
import '../chat/user_chat_page.dart';         // kalau belum ada, nanti saya bikinkan
import 'user_profile_page.dart';              // kalau belum ada, nanti saya bikinkan

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = "";
  String _email = "";

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final u = await Session.getUser();
    setState(() {
      _userName = "${u["name"] ?? ""}";
      _email = "${u["email"] ?? ""}";
    });
  }

  Widget _menuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Toko Peralatan Gaming"),
      ),
      body: ListView(
        children: [
          // ✅ Greeting di atas
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _userName.isEmpty
                    ? "Selamat datang 👋"
                    : "Selamat datang, $_userName 👋\n$_email",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),

          const SizedBox(height: 6),

          // ✅ 5 Menu User
          _menuCard(
            icon: Icons.shopping_cart,
            title: "Product",
            subtitle: "Lihat produk gaming & lakukan pembelian",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserProductsPage()),
            ),
          ),
          _menuCard(
            icon: Icons.receipt_long,
            title: "Riwayat Pembelian",
            subtitle: "Riwayat disimpan per akun (SharedPreferences)",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserHistoryPage()),
            ),
          ),
          _menuCard(
            icon: Icons.article,
            title: "Article",
            subtitle: "Baca artikel seputar gaming & rekomendasi gear",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserArticlesPage()),
            ),
          ),
          _menuCard(
            icon: Icons.chat,
            title: "Chat ke Admin",
            subtitle: "Tanyakan stok, rekomendasi produk, atau bantuan",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserChatPage()),
            ),
          ),
          _menuCard(
            icon: Icons.person,
            title: "Profile",
            subtitle: "Lihat akun & logout",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserProfilePage()),
            ),
          ),
        ],
      ),
    );
  }
}

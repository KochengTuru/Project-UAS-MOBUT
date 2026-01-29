import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/session.dart';

class UserHistoryPage extends StatefulWidget {
  const UserHistoryPage({super.key});

  @override
  State<UserHistoryPage> createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> {
  List _items = [];
  int? _userId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final u = await Session.getUser();
    _userId = u["id"] as int?;
    await _load();
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final key = "history_user_${_userId ?? 0}";
    final raw = sp.getString(key);

    List list = [];
    if (raw != null && raw.isNotEmpty) {
      try {
        list = jsonDecode(raw) as List;
      } catch (_) {
        list = [];
      }
    }

    setState(() => _items = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Pembelian")),
      body: _items.isEmpty
          ? const Center(child: Text("Belum ada pembelian"))
          : ListView.builder(
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final it = _items[i] as Map;
          return ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text("${it["product_name"]}"),
            subtitle: Text("Harga: ${it["price"]}\nWaktu: ${it["created_at"]}"),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}

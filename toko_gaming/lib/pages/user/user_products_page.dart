import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api.dart';
import '../../core/session.dart';

class UserProductsPage extends StatefulWidget {
  const UserProductsPage({super.key});

  @override
  State<UserProductsPage> createState() => _UserProductsPageState();
}

class _UserProductsPageState extends State<UserProductsPage> {
  final _api = Api();
  List _data = [];
  bool _loading = true;
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
    setState(() => _loading = true);
    try {
      final res = await _api.get("products/list.php");
      setState(() {
        _data = (res["data"] as List?) ?? [];
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat produk")),
      );
    }
  }

  Future<void> _buy(Map p) async {
    if (_userId == null) return;

    final id = int.parse("${p["id"]}");
    final name = "${p["name"]}";
    final price = int.tryParse("${p["price"]}") ?? 0;

    // 1) simpan ke DB (admin bisa lihat semua)
    try {
      final res = await _api.post("orders/create.php", {
        "user_id": _userId,
        "product_id": id,
        "qty": 1,
      });

      // 2) simpan ke SharedPreferences (riwayat lokal per user)
      await _saveLocalHistory({
        "product_id": id,
        "product_name": name,
        "price": price,
        "created_at": DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${res["message"]}")),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal membeli (cek API orders/create.php)")),
      );
    }
  }

  Future<void> _saveLocalHistory(Map<String, dynamic> item) async {
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

    list.insert(0, item);
    await sp.setString(key, jsonEncode(list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produk"),
        actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (_, i) {
            final p = _data[i] as Map;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text("${p["name"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Kategori: ${p["category_name"]}\nHarga: ${p["price"]} | Stok: ${p["stock"]}"),
                isThreeLine: true,
                trailing: ElevatedButton(
                  onPressed: () => _buy(p),
                  child: const Text("Beli"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

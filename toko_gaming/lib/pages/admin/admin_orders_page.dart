import 'package:flutter/material.dart';
import '../../core/api.dart';
import '../../core/session.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  final _api = Api();
  List _data = [];
  bool _loading = true;
  int? _adminId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final u = await Session.getUser();
    _adminId = u["id"] as int?;
    await _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await _api.get("orders/list_all.php", qp: {
        "user_id": _adminId, // kunci admin-only di server
      });
      setState(() {
        _data = (res["data"] as List?) ?? [];
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat riwayat (cek API orders/list_all.php)")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Semua User (Admin)"),
        actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, i) {
          final o = _data[i] as Map;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text("${o["product_name"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                "User: ${o["user_name"]} (${o["email"]})\nQty: ${o["qty"]} | Total: ${o["total_price"]}\nWaktu: ${o["created_at"]}",
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}

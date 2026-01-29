import 'package:flutter/material.dart';
import '../../core/api.dart';

class UserArticlesPage extends StatefulWidget {
  const UserArticlesPage({super.key});

  @override
  State<UserArticlesPage> createState() => _UserArticlesPageState();
}

class _UserArticlesPageState extends State<UserArticlesPage> {
  final _api = Api();

  bool _loading = true;
  List _data = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await _api.get("articles/list.php");

      if (res["success"] != true) {
        if (!mounted) return;
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${res["message"]}")),
        );
        return;
      }

      final list = (res["data"] as List?) ?? [];
      if (!mounted) return;
      setState(() {
        _data = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat artikel: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Article"),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
          ? const Center(child: Text("Belum ada artikel"))
          : ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, i) {
          final a = _data[i] as Map;

          final title = "${a["title"] ?? ""}";
          final body = "${a["body"] ?? ""}"; // ✅ penting (DB kamu)
          final img = "${a["image_url"] ?? ""}";
          final date = "${a["created_at"] ?? ""}";

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: img.isEmpty
                    ? Container(
                  width: 56,
                  height: 56,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image),
                )
                    : Image.network(
                  img,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${body.length > 80 ? body.substring(0, 80) + "..." : body}\n$date",
              ),
            ),
          );
        },
      ),
    );
  }
}

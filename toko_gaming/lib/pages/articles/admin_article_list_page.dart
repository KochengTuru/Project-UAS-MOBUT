import 'package:flutter/material.dart';
import '../../core/api.dart';
import '../../core/session.dart';
import 'admin_article_form_page.dart';

class AdminArticleListPage extends StatefulWidget {
  const AdminArticleListPage({super.key});

  @override
  State<AdminArticleListPage> createState() => _AdminArticleListPageState();
}

class _AdminArticleListPageState extends State<AdminArticleListPage> {
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
      final res = await _api.get("articles/list.php");

      // Jika server balas success false, tampilkan message
      if (res["success"] != true) {
        if (!mounted) return;
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${res["message"]}")),
        );
        return;
      }

      final list = (res["data"] as List?) ?? [];
      setState(() {
        _data = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Load error: $e")),
      );
    }
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Yakin ingin menghapus artikel ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _delete(id);
            },
            child: const Text("Hapus"),
          )
        ],
      ),
    );
  }

  Future<void> _delete(int id) async {
    try {
      final res = await _api.post("articles/delete.php", {
        "id": id,
        "user_id": _adminId, // admin-only
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${res["message"]}")),
      );
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal hapus artikel: $e")),
      );
    }
  }

  Widget _thumb(String url) {
    if (url.trim().isEmpty) {
      return Container(
        width: 56,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.image_not_supported),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        url,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD Artikel (Admin)"),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminArticleFormPage()),
          );
          _load();
        },
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _data.isEmpty
          ? const Center(child: Text("Artikel masih kosong"))
          : RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (_, i) {
            final a = _data[i] as Map;
            final id = int.parse("${a["id"]}");
            final title = "${a["title"]}";
            final body = "${a["body"] ?? ""}";
            final img = "${a["image_url"] ?? ""}";
            final date = "${a["created_at"] ?? ""}";

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: _thumb(img),
                title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  "${body.length > 80 ? body.substring(0, 80) + "..." : body}\n$date",
                ),
                isThreeLine: true,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminArticleFormPage(
                        id: id,
                        title: title,
                        body: body,
                        imageUrl: img,
                      ),
                    ),
                  );
                  _load();
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(id),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

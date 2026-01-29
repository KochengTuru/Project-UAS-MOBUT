import 'package:flutter/material.dart';
import '../../core/api.dart';
import 'category_form_page.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});
  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  final _api = Api();
  List _data = [];
  bool _loading = true;

  Future<void> _load() async {
    setState(() => _loading = true);
    final res = await _api.get("categories/list.php");
    setState(() {
      _data = (res["data"] as List?) ?? [];
      _loading = false;
    });
  }

  Future<void> _delete(int id) async {
    final res = await _api.post("categories/delete.php", {"id": id});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${res["message"]}")),
    );
    _load();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kategori")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoryFormPage()));
          _load();
        },
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, i) {
          final item = _data[i] as Map;
          return Card(
            child: ListTile(
              title: Text("${item["name"]}"),
              subtitle: Text("ID: ${item["id"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CategoryFormPage(
                            id: int.parse("${item["id"]}"),
                            name: "${item["name"]}",
                          ),
                        ),
                      );
                      _load();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _delete(int.parse("${item["id"]}")),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

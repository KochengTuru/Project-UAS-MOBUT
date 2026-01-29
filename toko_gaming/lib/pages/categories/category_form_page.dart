import 'package:flutter/material.dart';
import '../../core/api.dart';

class CategoryFormPage extends StatefulWidget {
  final int? id;
  final String? name;
  const CategoryFormPage({super.key, this.id, this.name});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _api = Api();
  final _name = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _name.text = widget.name ?? "";
  }

  Future<void> _save() async {
    setState(() => _loading = true);

    final isEdit = widget.id != null;
    final path = isEdit ? "categories/update.php" : "categories/create.php";

    final body = <String, dynamic>{"name": _name.text.trim()};
    if (isEdit) body["id"] = widget.id;

    final res = await _api.post(path, body);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${res["message"]}")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.id == null ? "Tambah Kategori" : "Edit Kategori")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: "Nama Kategori")),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                child: Text(_loading ? "Loading..." : "Simpan"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

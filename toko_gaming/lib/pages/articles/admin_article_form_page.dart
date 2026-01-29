import 'package:flutter/material.dart';
import '../../core/api.dart';
import '../../core/session.dart';

class AdminArticleFormPage extends StatefulWidget {
  final int? id;
  final String? title;
  final String? body;      // ✅ ganti content -> body
  final String? imageUrl;

  const AdminArticleFormPage({
    super.key,
    this.id,
    this.title,
    this.body,
    this.imageUrl,
  });

  @override
  State<AdminArticleFormPage> createState() => _AdminArticleFormPageState();
}

class _AdminArticleFormPageState extends State<AdminArticleFormPage> {
  final _api = Api();
  final _title = TextEditingController();
  final _body = TextEditingController(); // ✅ controller body
  final _imageUrl = TextEditingController();

  bool _saving = false;
  int? _adminId;

  @override
  void initState() {
    super.initState();
    _title.text = widget.title ?? "";
    _body.text = widget.body ?? "";
    _imageUrl.text = widget.imageUrl ?? "";
    _init();
  }

  Future<void> _init() async {
    final u = await Session.getUser();
    _adminId = u["id"] as int?;
    if (mounted) setState(() {});
  }

  Future<void> _save() async {
    if (_saving) return;

    final t = _title.text.trim();
    final b = _body.text.trim();
    final img = _imageUrl.text.trim();

    if (t.isEmpty || b.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul & isi artikel wajib diisi")),
      );
      return;
    }

    if (_adminId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Admin belum terbaca. Silakan login ulang.")),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final isEdit = widget.id != null;
      final path = isEdit ? "articles/update.php" : "articles/create.php";

      final req = <String, dynamic>{
        "user_id": _adminId,
        "title": t,
        "body": b,           // ✅ penting: DB kamu pakai body
        "image_url": img,
      };
      if (isEdit) req["id"] = widget.id;

      final res = await _api.post(path, req);

      if (!mounted) return;
      final success = res["success"] == true;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${res["message"]}")),
      );

      if (success) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan: $e")),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _preview() {
    final url = _imageUrl.text.trim();
    if (url.isEmpty) {
      return Container(
        height: 140,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text("Preview gambar (opsional)"),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 140,
          width: double.infinity,
          alignment: Alignment.center,
          color: Colors.grey.shade200,
          child: const Text("Gambar tidak valid"),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.id != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Artikel (Admin)" : "Tambah Artikel (Admin)"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _preview(),
          const SizedBox(height: 12),

          TextField(
            controller: _title,
            decoration: const InputDecoration(
              labelText: "Judul",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _imageUrl,
            decoration: const InputDecoration(
              labelText: "Image URL (opsional)",
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _body,
            minLines: 5,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: "Isi Artikel",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save),
              label: Text(_saving ? "Menyimpan..." : (isEdit ? "Update" : "Simpan")),
            ),
          ),
        ],
      ),
    );
  }
}

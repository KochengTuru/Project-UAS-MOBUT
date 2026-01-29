import 'package:flutter/material.dart';
import '../../core/api.dart';

class ProductFormPage extends StatefulWidget {
  final int? id;
  final int? categoryId;
  final String? name;
  final int? price;
  final int? stock;
  final String? imageUrl;
  final String? description;

  const ProductFormPage({
    super.key,
    this.id,
    this.categoryId,
    this.name,
    this.price,
    this.stock,
    this.imageUrl,
    this.description,
  });

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _api = Api();

  final _name = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController();
  final _imageUrl = TextEditingController();
  final _desc = TextEditingController();

  bool _loading = false;

  List _categories = [];
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _name.text = widget.name ?? "";
    _price.text = (widget.price ?? 0).toString();
    _stock.text = (widget.stock ?? 0).toString();
    _imageUrl.text = widget.imageUrl ?? "";
    _desc.text = widget.description ?? "";
    _selectedCategoryId = widget.categoryId;

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final res = await _api.get("categories/list.php");
      final list = (res["data"] as List?) ?? [];
      setState(() {
        _categories = list;
        // kalau create baru dan belum pilih, pakai kategori pertama
        if (_selectedCategoryId == null && _categories.isNotEmpty) {
          _selectedCategoryId = int.parse("${_categories.first["id"]}");
        }
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat kategori")),
      );
    }
  }

  Future<void> _save() async {
    final isEdit = widget.id != null;

    final name = _name.text.trim();
    final price = int.tryParse(_price.text.trim()) ?? 0;
    final stock = int.tryParse(_stock.text.trim()) ?? 0;
    final imageUrl = _imageUrl.text.trim();
    final desc = _desc.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama produk wajib diisi")),
      );
      return;
    }
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kategori wajib dipilih")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final path = isEdit ? "products/update.php" : "products/create.php";

      final body = <String, dynamic>{
        "category_id": _selectedCategoryId,
        "name": name,
        "price": price,
        "stock": stock,
        "image_url": imageUrl,
        "description": desc,
      };
      if (isEdit) body["id"] = widget.id;

      final res = await _api.post(path, body);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${res["message"]}")),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan produk")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.id != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Produk" : "Tambah Produk"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Container (poin tugas)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Isi data produk gaming (keyboard, mouse, headset, monitor, pc).",
              style: TextStyle(fontSize: 13),
            ),
          ),

          DropdownButtonFormField<int>(
            value: _selectedCategoryId,
            items: _categories.map((c) {
              final id = int.parse("${c["id"]}");
              final name = "${c["name"]}";
              return DropdownMenuItem(value: id, child: Text(name));
            }).toList(),
            onChanged: (v) => setState(() => _selectedCategoryId = v),
            decoration: const InputDecoration(
              labelText: "Kategori",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: "Nama Produk",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _price,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Harga",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _stock,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Stok",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _imageUrl,
            decoration: const InputDecoration(
              labelText: "Image URL (boleh kosong)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _desc,
            minLines: 3,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: "Deskripsi",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _save,
              icon: const Icon(Icons.save),
              label: Text(_loading ? "Loading..." : (isEdit ? "Update" : "Simpan")),
            ),
          ),
        ],
      ),
    );
  }
}

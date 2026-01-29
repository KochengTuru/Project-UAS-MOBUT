import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/api.dart';
import '../../core/session.dart';

class AdminProductFormPage extends StatefulWidget {
  final int? id;
  final int? categoryId;
  final String? name;
  final int? price;
  final int? stock;
  final String? imageUrl;
  final String? description;

  const AdminProductFormPage({
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
  State<AdminProductFormPage> createState() => _AdminProductFormPageState();
}

class _AdminProductFormPageState extends State<AdminProductFormPage> {
  final _api = Api();

  final _name = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController();
  final _imageUrl = TextEditingController();
  final _desc = TextEditingController();

  bool _loading = false;
  List _categories = [];
  int? _selectedCategoryId;
  int? _adminId;

  @override
  void initState() {
    super.initState();

    _name.text = widget.name ?? "";
    _price.text = (widget.price ?? 0).toString();
    _stock.text = (widget.stock ?? 0).toString();
    _imageUrl.text = widget.imageUrl ?? "";
    _desc.text = widget.description ?? "";
    _selectedCategoryId = widget.categoryId;

    _init();
  }

  Future<void> _init() async {
    final u = await Session.getUser();
    _adminId = u["id"] as int?;
    await _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final res = await _api.get("categories/list.php");
      final list = (res["data"] as List?) ?? [];

      setState(() {
        _categories = list;

        // auto pilih kategori pertama jika belum ada
        if (_selectedCategoryId == null && _categories.isNotEmpty) {
          _selectedCategoryId = int.tryParse("${_categories.first["id"]}");
        }
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat kategori: $e")),
      );
    }
  }

  Future<void> _save() async {
    if (_loading) return;

    final isEdit = widget.id != null;

    final name = _name.text.trim();
    final priceStr = _price.text.trim();
    final stockStr = _stock.text.trim();
    final imageUrl = _imageUrl.text.trim();
    final desc = _desc.text.trim();

    // validasi
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

    final price = int.tryParse(priceStr);
    final stock = int.tryParse(stockStr);

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harga harus angka dan lebih dari 0")),
      );
      return;
    }

    if (stock == null || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stok harus angka (minimal 0)")),
      );
      return;
    }

    if (_adminId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Admin belum terbaca. Silakan login ulang.")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final path = isEdit ? "products/update.php" : "products/create.php";

      final body = <String, dynamic>{
        "user_id": _adminId, // ✅ penting untuk require_admin()
        "category_id": _selectedCategoryId,
        "name": name,
        "price": price, // ✅ int
        "stock": stock, // ✅ int
        "image_url": imageUrl,
        "description": desc,
      };
      if (isEdit) body["id"] = widget.id;

      final res = await _api.post(path, body);

      if (!mounted) return;

      final success = res["success"] == true;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${res["message"]}")),
      );

      if (success) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan produk: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _stock.dispose();
    _imageUrl.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.id != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Produk (Admin)" : "Tambah Produk (Admin)"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            value: _selectedCategoryId,
            items: _categories.map((c) {
              final id = int.tryParse("${c["id"]}") ?? 0;
              final name = "${c["name"]}";
              return DropdownMenuItem(
                value: id,
                child: Text(name),
              );
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

          // ✅ Harga hanya angka
          TextField(
            controller: _price,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // ✅ blok huruf
            ],
            decoration: const InputDecoration(
              labelText: "Harga",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          // ✅ Stok hanya angka
          TextField(
            controller: _stock,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // ✅ blok huruf
            ],
            decoration: const InputDecoration(
              labelText: "Stok",
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
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _desc,
            minLines: 3,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: "Deskripsi (opsional)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 52,
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

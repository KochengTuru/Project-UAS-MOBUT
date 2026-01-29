import 'package:flutter/material.dart';
import '../../core/api.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});
  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final _api = Api();
  List _data = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await _api.get("articles/list.php");
    setState(() {
      _data = (res["data"] as List?) ?? [];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Artikel")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, i) {
          final a = _data[i] as Map;
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((a["image_url"] ?? "") != "")
                  Image.network("${a["image_url"]}", fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${a["title"]}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text("${a["body"]}"),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

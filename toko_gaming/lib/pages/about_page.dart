import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tentang Aplikasi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Artikel: Kenapa Peralatan Gaming Penting?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Peralatan gaming seperti mouse, keyboard, headset, monitor, "
                  "dan PC mempengaruhi kenyamanan serta performa bermain. "
                  "Aplikasi ini membantu kamu mengelola katalog produk, kategori, "
                  "dan membaca artikel singkat seputar gaming.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Message"),
                    content: const Text("Terima kasih sudah menggunakan aplikasi Toko Gaming!"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
                    ],
                  ),
                );
              },
              child: const Text("Tampilkan Message"),
            )
          ],
        ),
      ),
    );
  }
}

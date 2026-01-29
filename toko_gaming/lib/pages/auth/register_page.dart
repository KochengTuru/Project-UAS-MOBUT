import 'package:flutter/material.dart';
import '../../core/api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _api = Api();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _loading = false;
  bool _obscure = true;

  bool _isValidGmail(String email) {
    final e = email.trim().toLowerCase();
    // harus ada minimal 1 karakter sebelum @gmail.com
    final regex = RegExp(r'^[a-zA-Z0-9._%+\-]+@gmail\.com$');
    return regex.hasMatch(e);
  }

  Future<void> _register() async {
    if (_loading) return;

    final name = _name.text.trim();
    final email = _email.text.trim();
    final pass = _password.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama, Email, dan Password wajib diisi")),
      );
      return;
    }

    if (!_isValidGmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email harus format gmail, contoh: contoh@gmail.com")),
      );
      return;
    }

    if (pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password minimal 6 karakter")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final res = await _api.post("auth/register.php", {
        "name": name,
        "email": email,
        "password": pass,
      });

      if (!mounted) return;

      final success = res["success"] == true;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${res["message"]}")),
      );

      if (success) {
        Navigator.pop(context); // balik ke login
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Register gagal: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Akun")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Silakan daftar akun untuk Toko Peralatan Gaming.\nEmail wajib menggunakan Gmail.",
              style: TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: "Nama Lengkap",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email (Gmail)",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
              hintText: "contoh@gmail.com",
            ),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _password,
            obscureText: _obscure,
            decoration: InputDecoration(
              labelText: "Password",
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
          ),
          const SizedBox(height: 16),

          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _register,
              icon: const Icon(Icons.app_registration),
              label: Text(_loading ? "Memproses..." : "Daftar"),
            ),
          ),
          const SizedBox(height: 10),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Sudah punya akun? Login"),
          ),
        ],
      ),
    );
  }
}

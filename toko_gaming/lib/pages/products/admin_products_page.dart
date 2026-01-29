import 'package:flutter/material.dart';
import 'admin_product_list_page.dart';


class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminProductListPage(); // ✅ hapus const
  }
}

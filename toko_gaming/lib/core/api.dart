import 'dart:convert';
import 'package:dio/dio.dart';

class Api {
  static const String baseUrl = "https://salgita.tif-lbj.my.id/api-gaming";

  final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    // Biar response error 400/500 tetap masuk dan bisa dibaca
    validateStatus: (status) => status != null && status >= 200 && status < 600,
  ));

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? qp}) async {
    final res = await dio.get("$baseUrl/$path", queryParameters: qp);
    return _parse(res);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final res = await dio.post(
      "$baseUrl/$path",
      data: body,
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return _parse(res);
  }

  Map<String, dynamic> _parse(Response res) {
    dynamic data = res.data;

    // Kalau server balas string (kadang JSON string, kadang HTML)
    if (data is String) {
      try {
        data = jsonDecode(data);
      } catch (_) {
        return {
          "success": false,
          "message": "Server mengembalikan non-JSON (HTTP ${res.statusCode})",
          "raw": data,
        };
      }
    }

    if (data is Map<String, dynamic>) return data;

    // kalau format lain (List, dll)
    return {
      "success": false,
      "message": "Format response tidak valid (HTTP ${res.statusCode})",
      "raw": data.toString(),
    };
  }
}

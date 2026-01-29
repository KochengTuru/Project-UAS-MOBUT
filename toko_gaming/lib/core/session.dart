import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const _kIsLogin = "is_login";
  static const _kUserId = "user_id";
  static const _kUserName = "user_name";
  static const _kUserEmail = "user_email";
  static const _kRole = "role"; // admin / user

  static Future<void> saveLogin(Map<String, dynamic> user) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kIsLogin, true);
    await sp.setInt(_kUserId, int.parse("${user['id']}"));
    await sp.setString(_kUserName, "${user['name']}");
    await sp.setString(_kUserEmail, "${user['email']}");
    await sp.setString(_kRole, "${user['role'] ?? 'user'}");
  }

  static Future<bool> isLogin() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kIsLogin) ?? false;
  }

  static Future<String> getRole() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kRole) ?? "user";
  }

  static Future<Map<String, dynamic>> getUser() async {
    final sp = await SharedPreferences.getInstance();
    return {
      "id": sp.getInt(_kUserId),
      "name": sp.getString(_kUserName),
      "email": sp.getString(_kUserEmail),
      "role": sp.getString(_kRole) ?? "user",
    };
  }

  static Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}

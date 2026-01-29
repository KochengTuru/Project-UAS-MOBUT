import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/welcome_dialog.dart';

class WelcomeHelper {
  static Future<void> showOnce({
    required BuildContext context,
    required String key,
    required String title,
    required String message,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool(key) ?? false;

    if (!shown) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!context.mounted) return;

      WelcomeDialog.show(
        context: context,
        title: title,
        message: message,
      );
      await prefs.setBool(key, true);
    }
  }

  static Future<void> resetKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}

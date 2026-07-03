import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _usersKey = 'refocus_registered_users';

  // Sign up a new user. Returns null on success, or an error message on failure.
  static Future<String?> signUp(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_usersKey);
    List<dynamic> users = [];
    if (usersJson != null) {
      try {
        users = jsonDecode(usersJson) as List<dynamic>;
      } catch (e) {
        users = [];
      }
    }

    // Check if email already exists
    final emailLower = email.trim().toLowerCase();
    final bool exists = users.any((u) => u['email'].toString().toLowerCase() == emailLower);
    if (exists) {
      return 'Email sudah terdaftar. Gunakan email lain.';
    }

    // Add new user
    users.add({
      'name': name.trim(),
      'email': emailLower,
      'password': password,
    });

    await prefs.setString(_usersKey, jsonEncode(users));
    return null;
  }

  // Login user. Returns a Map with 'name' and 'email' on success, or null on failure.
  static Future<Map<String, String>?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return null;

    List<dynamic> users = [];
    try {
      users = jsonDecode(usersJson) as List<dynamic>;
    } catch (e) {
      return null;
    }

    final emailLower = email.trim().toLowerCase();
    for (var u in users) {
      if (u['email'].toString().toLowerCase() == emailLower && u['password'] == password) {
        return {
          'name': u['name'].toString(),
          'email': u['email'].toString(),
        };
      }
    }
    return null;
  }
}

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class CookieManager {
  static const String _tokenKey = 'token';
  static const String _nik = 'nik';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveNik(String nik) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nik, nik);
  }

  Future<String?> getNik() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nik);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
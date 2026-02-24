import 'package:homefe/logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PersistentStorage {
  static SharedPreferences? _instance;

  static Future<SharedPreferences> get instance async {
    _instance ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  static Future<String?> read(String key) async {
    try {
      final prefs = await instance;
      return prefs.getString(key);
    } catch (e) {
      logger.e(e.toString());
      return null;
    }
  }

  static Future<Map<String, String>> readAll() async {
    try {
      final prefs = await instance;
      final keys = prefs.getKeys();
      final result = <String, String>{};
      for (final key in keys) {
        final value = prefs.getString(key);
        if (value != null) {
          result[key] = value;
        }
      }
      return result;
    } catch (e) {
      logger.e(e.toString());
      return <String, String>{};
    }
  }

  static Future<bool> delete(String key) async {
    try {
      final prefs = await instance;
      await prefs.remove(key);
      return true;
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  static Future<bool> deleteAll() async {
    try {
      final prefs = await instance;
      await prefs.clear();
      return true;
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  static Future<bool> write(String key, String value) async {
    try {
      final prefs = await instance;
      await prefs.setString(key, value);
      return true;
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }
}

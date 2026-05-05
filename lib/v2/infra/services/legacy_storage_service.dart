import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;
  static final Map<String, String> _syncCache = {};
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    try {
      final keys = _prefs.getKeys();
      for (var key in keys) {
        try {
          final value = _prefs.getString(key);
          if (value != null) {
            _syncCache[key] = value;
          }
        } catch (_) {}
      }
    } catch (_) {}
    _initialized = true;
  }

  static SharedPreferences get prefs => _prefs;

  static Future<String?> getValue(String key) async {
    return _prefs.getString(key);
  }

  static String? getValueSync(String key) {
    return _syncCache[key];
  }

  static Future<bool> setValue(String key, String value) async {
    final result = await _prefs.setString(key, value);
    if (result) {
      _syncCache[key] = value;
    }
    return result;
  }

  static Future<bool> remove(String key) async {
    return _prefs.remove(key);
  }
}

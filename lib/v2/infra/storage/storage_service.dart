import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/storage_repository.dart';
import '../../domain/failures/failure.dart';

class SharedPreferencesStorage implements StorageRepository {
  static SharedPreferencesStorage? _instance;
  static SharedPreferencesStorage get instance {
    _instance ??= SharedPreferencesStorage._();
    return _instance!;
  }

  SharedPreferencesStorage._();

  late SharedPreferences _prefs;
  final Map<String, String> _syncCache = {};
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
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

  @override
  Future<Either<Failure, String?>> getString(String key) async {
    try {
      final value = _prefs.getString(key);
      return Right(value);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  String? getStringSync(String key) {
    return _syncCache[key];
  }

  @override
  Future<Either<Failure, bool>> setString(String key, String value) async {
    try {
      final result = await _prefs.setString(key, value);
      if (result) {
        _syncCache[key] = value;
      }
      return Right(result);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> remove(String key) async {
    try {
      final result = await _prefs.remove(key);
      if (result) {
        _syncCache.remove(key);
      }
      return Right(result);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> containsKey(String key) async {
    try {
      return Right(_prefs.containsKey(key));
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }
}

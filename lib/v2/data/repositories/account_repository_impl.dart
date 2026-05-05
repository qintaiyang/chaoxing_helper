import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/repositories/storage_repository.dart';
import '../../domain/failures/failure.dart';
import '../../app_dependencies.dart';
import '../../infra/crypto/encryption_service.dart';
import '../../infra/crypto/crypto_config.dart';
import '../models/user_dto.dart';
import '../mappers/user_mapper.dart';

class AccountRepositoryImpl implements AccountRepository {
  final StorageRepository _storage;
  final EncryptionService _encryption;

  static const _sessionKey = 'chaoxing_current_session';
  static const _accountsKey = 'chaoxing_accounts';
  static const _passwordKeyPrefix = 'cx_password_';

  List<User> _accountsCache = [];
  String? _currentSessionId;

  AccountRepositoryImpl(this._storage, this._encryption);

  @override
  Either<Failure, String?> getCurrentSessionId() {
    try {
      _currentSessionId ??= _storage.getStringSync(_sessionKey);
      return Right(_currentSessionId);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setCurrentSession(String? userId) async {
    try {
      _currentSessionId = userId;
      if (userId != null) {
        final result = await _storage.setString(_sessionKey, userId);
        final user = getAccountById(userId).fold((_) => null, (u) => u);
        if (user != null && user.imAccount != null) {
          await _switchImAccount(
            userName: user.imAccount!.userName,
            password: user.imAccount!.password,
          );
        }
        return result.fold((f) => Left(f), (_) => const Right(null));
      } else {
        await _storage.remove(_sessionKey);
        try {
          AppDependencies.instance.imService.logout();
        } catch (_) {}
        return const Right(null);
      }
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Either<Failure, bool> hasActiveSession() {
    try {
      _currentSessionId ??= _storage.getStringSync(_sessionKey);
      return Right(_currentSessionId != null && _currentSessionId!.isNotEmpty);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addAccount(User user) async {
    try {
      await _loadAccountsIfNeeded();
      final index = _accountsCache.indexWhere((acc) => acc.uid == user.uid);
      if (index != -1) {
        _accountsCache[index] = user;
      } else {
        _accountsCache.add(user);
        if (!hasActiveSession().fold((_) => false, (v) => v)) {
          await setCurrentSession(user.uid);
        }
      }
      return await _saveAccounts();
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeAccounts(List<String> userIds) async {
    try {
      await _loadAccountsIfNeeded();
      _accountsCache.removeWhere((acc) => userIds.contains(acc.uid));
      final result = await _saveAccounts();
      final current = _currentSessionId;
      if (current != null && userIds.contains(current)) {
        await setCurrentSession(null);
      }
      return result;
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Either<Failure, List<User>> getAllAccounts() {
    try {
      _loadAccountsSync();
      return Right(List.unmodifiable(_accountsCache));
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Either<Failure, User?> getAccountById(String userId) {
    try {
      _loadAccountsSync();
      final index = _accountsCache.indexWhere((acc) => acc.uid == userId);
      return Right(index != -1 ? _accountsCache[index] : null);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setCxPassword(
    String uid,
    String password,
  ) async {
    try {
      final encrypted = _encryption.aesEcbEncrypt(
        password,
        CryptoConfig.production.defaultAesKey,
      );
      return (await _storage.setString(
        '$_passwordKeyPrefix$uid',
        encrypted,
      )).fold((f) => Left(f), (_) => const Right(null));
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Either<Failure, String?> getCxPassword(String uid) {
    try {
      final encrypted = _storage.getStringSync('$_passwordKeyPrefix$uid');
      if (encrypted == null) return const Right(null);
      try {
        final decrypted = _encryption.aesEcbDecrypt(
          encrypted,
          CryptoConfig.production.defaultAesKey,
        );
        return Right(decrypted);
      } catch (e) {
        debugPrint('解密密码失败: $e');
        return const Right(null);
      }
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCxPassword(String uid) async {
    try {
      return (await _storage.remove(
        '$_passwordKeyPrefix$uid',
      )).fold((f) => Left(f), (_) => const Right(null));
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  Future<void> _switchImAccount({
    required String userName,
    required String password,
  }) async {
    try {
      await AppDependencies.instance.imService.logout();
      await AppDependencies.instance.imService.login(userName, password);
    } catch (e) {
      debugPrint('IM账号切换失败: $e');
    }
  }

  Future<void> _loadAccountsIfNeeded() async {
    if (_accountsCache.isNotEmpty) return;
    final result = await _storage.getString(_accountsKey);
    result.fold((f) => _accountsCache = [], (jsonStr) {
      if (jsonStr != null && jsonStr.isNotEmpty) {
        try {
          final List<dynamic> data = json.decode(jsonStr);
          _accountsCache = data
              .whereType<Map<String, dynamic>>()
              .map((e) => UserDto.fromJson(e).toEntity())
              .toList();
        } catch (_) {
          _accountsCache = [];
        }
      } else {
        _accountsCache = [];
      }
    });
  }

  void _loadAccountsSync() {
    if (_accountsCache.isNotEmpty) return;
    final jsonStr = _storage.getStringSync(_accountsKey);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final List<dynamic> data = json.decode(jsonStr);
        _accountsCache = data
            .whereType<Map<String, dynamic>>()
            .map((e) => UserDto.fromJson(e).toEntity())
            .toList();
      } catch (_) {
        _accountsCache = [];
      }
    } else {
      _accountsCache = [];
    }
  }

  Future<Either<Failure, void>> _saveAccounts() async {
    try {
      final jsonStr = json.encode(
        _accountsCache.map((u) => u.toDto().toJson()).toList(),
      );
      return (await _storage.setString(
        _accountsKey,
        jsonStr,
      )).fold((f) => Left(f), (_) => const Right(null));
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }
}

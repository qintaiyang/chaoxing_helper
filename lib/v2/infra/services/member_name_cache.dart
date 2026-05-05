import 'dart:convert';
import 'package:flutter/material.dart';
import 'legacy_storage_service.dart';

class MemberNameCache {
  static final MemberNameCache _instance = MemberNameCache._internal();
  factory MemberNameCache() => _instance;
  MemberNameCache._internal();

  final Map<String, String> _names = {};
  final Map<String, String> _avatars = {};
  static const String _storageKey = 'member_name_cache';
  static const String _avatarStorageKey = 'member_avatar_cache';

  String? get(String senderId) => _names[senderId];

  String getOr(String senderId) => _names[senderId] ?? '用户$senderId';

  String? getAvatar(String senderId) => _avatars[senderId];

  String getAvatarOr(String senderId) => _avatars[senderId] ?? '';

  void set(String senderId, String name, {String? avatar}) {
    if (name.isNotEmpty) _names[senderId] = name;
    if (avatar != null && avatar.isNotEmpty) _avatars[senderId] = avatar;
  }

  void setWithAliases(String tuid, String puid, String name, {String? avatar}) {
    if (name.isNotEmpty) {
      if (tuid.isNotEmpty) _names[tuid] = name;
      if (puid.isNotEmpty) _names[puid] = name;
    }
    if (avatar != null && avatar.isNotEmpty) {
      if (tuid.isNotEmpty) _avatars[tuid] = avatar;
      if (puid.isNotEmpty) _avatars[puid] = avatar;
    }
  }

  void setAvatar(String senderId, String avatar) {
    if (avatar.isNotEmpty) _avatars[senderId] = avatar;
  }

  void setAll(Map<String, String> entries) {
    entries.forEach((key, value) {
      if (value.isNotEmpty) _names[key] = value;
    });
  }

  void setAllAvatars(Map<String, String> avatars) {
    avatars.forEach((key, value) {
      if (value.isNotEmpty) _avatars[key] = value;
    });
  }

  Map<String, String> getAll(List<String> senderIds) {
    final result = <String, String>{};
    for (var id in senderIds) {
      final name = _names[id];
      if (name != null) result[id] = name;
    }
    return result;
  }

  bool contains(String senderId) => _names.containsKey(senderId);

  int get length => _names.length;

  Future<void> loadFromStorage() async {
    try {
      final cached = await StorageService.getValue(_storageKey);
      if (cached != null && cached.isNotEmpty) {
        final Map<String, dynamic> data = jsonDecode(cached);
        data.forEach((key, value) {
          _names[key] = value.toString();
        });
        debugPrint('加载成员昵称缓存: ${_names.length} 个');
      }

      final avatarCached = await StorageService.getValue(_avatarStorageKey);
      if (avatarCached != null && avatarCached.isNotEmpty) {
        final Map<String, dynamic> avatarData = jsonDecode(avatarCached);
        avatarData.forEach((key, value) {
          _avatars[key] = value.toString();
        });
        debugPrint('加载成员头像缓存: ${_avatars.length} 个');
      }
    } catch (e) {
      debugPrint('加载成员缓存失败: $e');
    }
  }

  Future<void> saveToStorage() async {
    try {
      await StorageService.setValue(_storageKey, jsonEncode(_names));
      if (_avatars.isNotEmpty) {
        await StorageService.setValue(_avatarStorageKey, jsonEncode(_avatars));
      }
      debugPrint('保存成员缓存: 昵称=${_names.length}, 头像=${_avatars.length}');
    } catch (e) {
      debugPrint('保存成员缓存失败: $e');
    }
  }

  void clear() {
    _names.clear();
    _avatars.clear();
  }
}

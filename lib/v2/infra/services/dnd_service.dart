import 'dart:convert';
import 'package:flutter/material.dart';
import 'legacy_storage_service.dart';

class DndService {
  static const _dndKeyPrefix = 'dnd_groups_';

  final Set<String> _dndGroups = {};
  bool _loaded = false;
  String _sessionId = 'default';

  DndService();

  String get _storageKey => '$_dndKeyPrefix$_sessionId';

  void setUserId(String userId) {
    _sessionId = userId;
    _loaded = false;
    _dndGroups.clear();
    debugPrint('[DndService] 用户ID变更: $userId');
  }

  Future<void> loadFromStorage() async {
    if (_loaded) return;
    try {
      final data = await StorageService.getValue(_storageKey);
      if (data != null && data.isNotEmpty) {
        final List<dynamic> list = jsonDecode(data);
        _dndGroups.clear();
        _dndGroups.addAll(list.cast<String>());
        debugPrint('[DndService] 加载免打扰列表: ${_dndGroups.length} 个群组');
      }
      _loaded = true;
    } catch (e) {
      debugPrint('[DndService] 加载免打扰列表失败: $e');
      _loaded = true;
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final data = jsonEncode(_dndGroups.toList());
      await StorageService.setValue(_storageKey, data);
      debugPrint('[DndService] 保存免打扰列表: ${_dndGroups.length} 个群组');
    } catch (e) {
      debugPrint('[DndService] 保存免打扰列表失败: $e');
    }
  }

  bool isDnd(String groupId) {
    if (!_loaded) {
      _loadFromStorageSync();
    }
    return _dndGroups.contains(groupId);
  }

  List<String> getDndGroups() {
    if (!_loaded) {
      _loadFromStorageSync();
    }
    return _dndGroups.toList();
  }

  void _loadFromStorageSync() {
    try {
      final data = StorageService.getValueSync(_storageKey);
      if (data != null && data.isNotEmpty) {
        final List<dynamic> list = jsonDecode(data);
        _dndGroups.clear();
        _dndGroups.addAll(list.cast<String>());
      }
      _loaded = true;
    } catch (e) {
      debugPrint('[DndService] 同步加载免打扰列表失败: $e');
      _loaded = true;
    }
  }

  Future<void> setDnd(String groupId, bool enabled) async {
    if (!_loaded) await loadFromStorage();

    if (enabled) {
      _dndGroups.add(groupId);
      debugPrint('[DndService] 开启免打扰: $groupId');
    } else {
      _dndGroups.remove(groupId);
      debugPrint('[DndService] 关闭免打扰: $groupId');
    }
    await _saveToStorage();
  }

  Future<void> toggleDnd(String groupId) async {
    if (!_loaded) await loadFromStorage();
    await setDnd(groupId, !isDnd(groupId));
  }

  void clearForAccountChange() {
    _dndGroups.clear();
    _loaded = false;
    debugPrint('[DndService] 账号变更，清空免打扰缓存');
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infra/storage/storage_service.dart';
import '../../infra/services/push_dispatcher.dart';

const String _kEnableActivityPopup = 'enable_activity_popup';

class ActivityPopupPreferences {
  final bool enabled;

  const ActivityPopupPreferences({required this.enabled});

  ActivityPopupPreferences copyWith({bool? enabled}) {
    return ActivityPopupPreferences(enabled: enabled ?? this.enabled);
  }
}

class ActivityPopupPreferencesNotifier
    extends StateNotifier<ActivityPopupPreferences> {
  final SharedPreferencesStorage _storage;

  ActivityPopupPreferencesNotifier(this._storage)
    : super(const ActivityPopupPreferences(enabled: true)) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final value = _storage.getStringSync(_kEnableActivityPopup);
    if (value != null) {
      final enabled = value == 'true';
      state = ActivityPopupPreferences(enabled: enabled);
      PushDispatcher().popupEnabled = enabled;
    } else {
      final result = await _storage.getString(_kEnableActivityPopup);
      result.fold((_) {}, (value) {
        if (value != null) {
          final enabled = value == 'true';
          state = ActivityPopupPreferences(enabled: enabled);
          PushDispatcher().popupEnabled = enabled;
        }
      });
    }
  }

  Future<void> setEnabled(bool enabled) async {
    state = state.copyWith(enabled: enabled);
    PushDispatcher().popupEnabled = enabled;
    await _storage.setString(_kEnableActivityPopup, enabled.toString());
  }
}

final activityPopupPreferencesProvider =
    StateNotifierProvider<
      ActivityPopupPreferencesNotifier,
      ActivityPopupPreferences
    >((ref) {
      return ActivityPopupPreferencesNotifier(
        SharedPreferencesStorage.instance,
      );
    });

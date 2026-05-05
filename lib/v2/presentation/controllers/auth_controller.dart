import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/user.dart';
import '../../app_dependencies.dart';
import '../providers/providers.dart';
import 'course_controller.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<User?> build() => const AsyncValue.data(null);

  Future<void> loginWithPassword(String username, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await AppDependencies.instance.loginUseCase
          .executeWithPassword(username, password);
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (user) {
          state = AsyncValue.data(user);
          _onLoginSuccess(user);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void _onLoginSuccess(User user) {
    _loginImIfNeeded(user);
    ref.invalidate(courseListControllerProvider);
    ref.invalidate(activityListControllerProvider);
    ref.read(sessionVersionProvider.notifier).increment();
  }

  void _loginImIfNeeded(User user) {
    if (user.imAccount != null) {
      try {
        AppDependencies.instance.imService.login(
          user.imAccount!.userName,
          user.imAccount!.password,
        );
      } catch (e) {
        debugPrint('IM登录失败: $e');
      }
    }
  }

  Future<void> loginWithPhone(String phone, String code) async {
    state = const AsyncValue.loading();
    try {
      final result = await AppDependencies.instance.loginUseCase
          .executeWithPhone(phone, code);
      result.fold(
        (failure) => state = AsyncValue.error(failure, StackTrace.current),
        (user) {
          state = AsyncValue.data(user);
          _onLoginSuccess(user);
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    try {
      await AppDependencies.instance.authRepo.logout();
      await AppDependencies.instance.imService.logout();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> checkCurrentUser() async {
    state = const AsyncValue.loading();
    try {
      final result = await AppDependencies.instance.authRepo.getCurrentUser();
      result.fold(
        (failure) => state = const AsyncValue.data(null),
        (user) => state = AsyncValue.data(user),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_dependencies.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/enums.dart';
import '../widgets/captcha_dialog.dart';

class SignInState {
  final bool isLoading;
  final bool isMultiSigning;
  final bool isDataLoaded;
  final int signTypeId;
  final SignType? signType;
  final bool needPhoto;
  final bool needCaptcha;
  final bool needFace;
  final String? locationRange;
  final String? designatedPlace;
  final int numberCount;
  final int status;
  final List<User> selectedAccounts;
  final User? currentUser;
  final String? result;
  final List<String> failedAccounts;
  final Map<String, String> userObjectIds;
  final Map<String, Map<String, String>> userCaptchaValidates;
  final String? pattern;
  final String? signCode;
  final String? enc;
  final String? address;
  final double? latitude;
  final double? longitude;

  const SignInState({
    this.isLoading = false,
    this.isMultiSigning = false,
    this.isDataLoaded = false,
    this.signTypeId = 0,
    this.signType,
    this.needPhoto = false,
    this.needCaptcha = false,
    this.needFace = false,
    this.locationRange,
    this.designatedPlace,
    this.numberCount = 0,
    this.status = 0,
    this.selectedAccounts = const [],
    this.currentUser,
    this.result,
    this.failedAccounts = const [],
    this.userObjectIds = const {},
    this.userCaptchaValidates = const {},
    this.pattern,
    this.signCode,
    this.enc,
    this.address,
    this.latitude,
    this.longitude,
  });

  SignInState copyWith({
    bool? isLoading,
    bool? isMultiSigning,
    bool? isDataLoaded,
    int? signTypeId,
    SignType? signType,
    bool? needPhoto,
    bool? needCaptcha,
    bool? needFace,
    String? locationRange,
    String? designatedPlace,
    int? numberCount,
    int? status,
    List<User>? selectedAccounts,
    User? currentUser,
    String? result,
    List<String>? failedAccounts,
    Map<String, String>? userObjectIds,
    Map<String, Map<String, String>>? userCaptchaValidates,
    String? pattern,
    String? signCode,
    String? enc,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      isMultiSigning: isMultiSigning ?? this.isMultiSigning,
      isDataLoaded: isDataLoaded ?? this.isDataLoaded,
      signTypeId: signTypeId ?? this.signTypeId,
      signType: signType ?? this.signType,
      needPhoto: needPhoto ?? this.needPhoto,
      needCaptcha: needCaptcha ?? this.needCaptcha,
      needFace: needFace ?? this.needFace,
      locationRange: locationRange ?? this.locationRange,
      designatedPlace: designatedPlace ?? this.designatedPlace,
      numberCount: numberCount ?? this.numberCount,
      status: status ?? this.status,
      selectedAccounts: selectedAccounts ?? this.selectedAccounts,
      currentUser: currentUser ?? this.currentUser,
      result: result ?? this.result,
      failedAccounts: failedAccounts ?? this.failedAccounts,
      userObjectIds: userObjectIds ?? this.userObjectIds,
      userCaptchaValidates: userCaptchaValidates ?? this.userCaptchaValidates,
      pattern: pattern ?? this.pattern,
      signCode: signCode ?? this.signCode,
      enc: enc ?? this.enc,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

class SignInController extends StateNotifier<SignInState> {
  SignInController() : super(const SignInState());

  SignInState get currentState => state;

  Future<void> loadSignInfo(String activeId) async {
    state = state.copyWith(isLoading: true);

    try {
      final deps = AppDependencies.instance;

      final activeInfo = await deps.cxSignInApi.getSignDetail(activeId);
      final attendInfo = await deps.cxSignInApi.getAttendInfo(activeId);

      if (activeInfo != null) {
        _parseActiveInfo(activeInfo);
      }

      if (attendInfo != null) {
        final status = attendInfo['status'] as int? ?? 0;
        state = state.copyWith(status: status);
      }

      final sessionIdResult = deps.accountRepo.getCurrentSessionId();
      sessionIdResult.fold((_) => {}, (sessionId) {
        if (sessionId != null) {
          final userResult = deps.accountRepo.getAccountById(sessionId);
          userResult.fold((_) => {}, (user) {
            if (user != null) {
              state = state.copyWith(currentUser: user);
              state = state.copyWith(selectedAccounts: [user]);
            }
          });
        }
      });

      state = state.copyWith(isLoading: false, isDataLoaded: true);
    } catch (e) {
      _handleError('加载签到信息失败: $e');
    }
  }

  void _parseActiveInfo(Map<String, dynamic> activeInfo) {
    final signTypeId = activeInfo['otherId'] as int? ?? 0;
    final needCaptcha = activeInfo['showVCode'] == 1;
    final needPhoto =
        (activeInfo['ifPhoto'] as int? ?? activeInfo['ifphoto'] as int? ?? 0) ==
        1;
    final numberCount = activeInfo['numberCount'] as int? ?? 0;
    final locationRange = activeInfo['locationRange'] as String?;
    final designatedPlace = activeInfo['locationText'] as String?;
    final needFace = activeInfo['openCheckFaceFlag'] == 1;

    final signType = signTypeIndexMap[signTypeId];

    state = state.copyWith(
      signTypeId: signTypeId,
      signType: signType,
      needCaptcha: needCaptcha,
      needPhoto: needPhoto,
      numberCount: numberCount,
      locationRange: locationRange,
      designatedPlace: designatedPlace,
      needFace: needFace,
    );
  }

  void setSelectedAccounts(List<User> accounts) {
    state = state.copyWith(selectedAccounts: accounts);
  }

  Future<void> performMultiSign({
    required String courseId,
    required String activeId,
    required String classId,
    required String cpi,
    String? signCode,
    String? enc,
    String? address,
    double? latitude,
    double? longitude,
    bool isGroupSignIn = false,
  }) async {
    if (state.selectedAccounts.isEmpty) return;
    if (state.isMultiSigning) return;

    state = state.copyWith(
      isLoading: true,
      isMultiSigning: true,
      failedAccounts: [],
    );

    final failedAccounts = <String>[];
    final selectedAccounts = List<User>.from(state.selectedAccounts);
    final cookieManager = AppDependencies.instance.cookieManager;

    final accountIds = selectedAccounts.map((u) => u.uid).toList();
    await cookieManager.preloadCookiesForAllUsers(accountIds);

    if (!isGroupSignIn &&
        state.needCaptcha &&
        state.signType != SignType.qrCode) {
      for (var user in selectedAccounts) {
        cookieManager.setOverrideUserId(user.uid);
        final captchaSuccess = await handleCaptcha(user.uid);
        cookieManager.setOverrideUserId(null);
        if (!captchaSuccess) {
          state = state.copyWith(isLoading: false, isMultiSigning: false);
          _showErrorMessage('验证码取消或失败');
          return;
        }
      }
    }

    for (var user in selectedAccounts) {
      cookieManager.setOverrideUserId(user.uid);
      try {
        final result = isGroupSignIn
            ? await signForGroup(
                user: user,
                activeId: activeId,
                address: address,
                latitude: latitude,
                longitude: longitude,
              )
            : await signForAccount(
                user: user,
                courseId: courseId,
                activeId: activeId,
                classId: classId,
                cpi: cpi,
                signCode: signCode,
                enc: enc,
                address: address,
                latitude: latitude,
                longitude: longitude,
              );
        await handleSignResult(
          result,
          user,
          failedAccounts,
          courseId: courseId,
          activeId: activeId,
          classId: classId,
          cpi: cpi,
          signCode: signCode,
          enc: enc,
          address: address,
          latitude: latitude,
          longitude: longitude,
          isGroupSignIn: isGroupSignIn,
        );
      } finally {
        cookieManager.setOverrideUserId(null);
      }
    }

    state = state.copyWith(
      isLoading: false,
      isMultiSigning: false,
      failedAccounts: failedAccounts,
    );

    _showMultiSignResult(selectedAccounts.length, failedAccounts);
  }

  Future<void> preGroupSign(String activeId) async {
    final deps = AppDependencies.instance;
    await deps.cxSignInApi.groupPreSignIn(activeId);
  }

  Future<String?> signForGroup({
    required User user,
    required String activeId,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final deps = AppDependencies.instance;
      final result = await deps.groupSignInUseCase.execute(
        activeId: activeId,
        uid: user.uid,
      );
      return result.fold((failure) => failure.message, (_) => 'success');
    } catch (e) {
      return '群聊签到异常: $e';
    }
  }

  Future<String?> signForAccount({
    required User user,
    required String courseId,
    required String activeId,
    required String classId,
    required String cpi,
    String? objectId,
    String? signCode,
    String? enc,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    final userValidate = state.userCaptchaValidates[user.uid];
    final validate = userValidate?['validate'];
    final enc2 = userValidate?['enc2'];

    try {
      final deps = AppDependencies.instance;

      switch (state.signType) {
        case SignType.normal:
          final result = await deps.normalSignInUseCase.execute(
            courseId: courseId,
            activeId: activeId,
            uid: user.uid,
            name: user.name,
            objectId: objectId ?? state.userObjectIds[user.uid],
            validate: validate,
          );
          return result.fold((failure) => failure.message, (_) => 'success');

        case SignType.code:
          if (signCode == null) return '缺少签到码';
          final result = await deps.codeSignInUseCase.execute(
            courseId: courseId,
            activeId: activeId,
            uid: user.uid,
            name: user.name,
            signCode: signCode,
            validate: validate,
          );
          return result.fold((failure) => failure.message, (_) => 'success');

        case SignType.location:
          final result = await deps.locationSignInUseCase.execute(
            courseId: courseId,
            activeId: activeId,
            uid: user.uid,
            name: user.name,
            address: address ?? '未知位置',
            latitude: latitude ?? 0,
            longitude: longitude ?? 0,
            validate: validate,
          );
          return result.fold((failure) => failure.message, (_) => 'success');

        case SignType.qrCode:
          if (enc == null) return '缺少二维码参数';
          final result = await deps.qrCodeSignInUseCase.execute(
            courseId: courseId,
            activeId: activeId,
            enc: enc,
            uid: user.uid,
            name: user.name,
            address: address,
            latitude: latitude,
            longitude: longitude,
            enc2: enc2,
            validate: validate,
          );
          return result.fold((failure) => failure.message, (_) => 'success');

        case SignType.pattern:
          final pattern = state.pattern;
          if (pattern == null) return '缺少手势密码';
          final result = await deps.codeSignInUseCase.execute(
            courseId: courseId,
            activeId: activeId,
            uid: user.uid,
            name: user.name,
            signCode: pattern,
            validate: validate,
          );
          return result.fold((failure) => failure.message, (_) => 'success');

        default:
          return '不支持的签到类型';
      }
    } catch (e) {
      return '签到异常: $e';
    }
  }

  Future<bool> handleCaptcha(String userId) async {
    try {
      final navigatorKey = AppDependencies.instance.navigatorKey;
      final context = navigatorKey.currentContext;
      if (context == null) return false;

      final validate = await CaptchaDialog.showSlideCaptchaDialog(context);

      if (validate != null) {
        final currentValidates = Map<String, Map<String, String>>.from(
          state.userCaptchaValidates,
        );
        currentValidates[userId] = {'validate': validate};
        state = state.copyWith(userCaptchaValidates: currentValidates);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _showErrorMessage('验证码处理失败: $e');
      return false;
    }
  }

  Future<void> handleSignResult(
    String? result,
    User user,
    List<String> failedAccounts, {
    String? courseId,
    String? activeId,
    String? classId,
    String? cpi,
    String? signCode,
    String? enc,
    String? address,
    double? latitude,
    double? longitude,
    bool isGroupSignIn = false,
  }) async {
    if (result == null) {
      failedAccounts.add('${user.name} (无响应)');
      return;
    }

    if (result.startsWith('validate')) {
      if (result.contains('_')) {
        final enc2 = result.split('_')[1];
        final currentValidates = Map<String, Map<String, String>>.from(
          state.userCaptchaValidates,
        );
        final userValidate = currentValidates[user.uid] ?? {};
        userValidate['enc2'] = enc2;
        currentValidates[user.uid] = userValidate;
        state = state.copyWith(userCaptchaValidates: currentValidates);

        final captchaSuccess = await handleCaptcha(user.uid);
        if (!captchaSuccess) {
          failedAccounts.add('${user.name} (验证码失败)');
          return;
        }

        final newResult = isGroupSignIn
            ? await signForGroup(
                user: user,
                activeId: activeId ?? '',
                address: address,
                latitude: latitude,
                longitude: longitude,
              )
            : await signForAccount(
                user: user,
                courseId: courseId ?? '',
                activeId: activeId ?? '',
                classId: classId ?? '',
                cpi: cpi ?? '',
                signCode: signCode,
                enc: enc,
                address: address,
                latitude: latitude,
                longitude: longitude,
              );

        final newResultStr = newResult ?? '签到异常';

        await handleSignResult(
          newResultStr,
          user,
          failedAccounts,
          courseId: courseId,
          activeId: activeId,
          classId: classId,
          cpi: cpi,
          signCode: signCode,
          enc: enc,
          address: address,
          latitude: latitude,
          longitude: longitude,
          isGroupSignIn: isGroupSignIn,
        );
      }
    } else if (result == 'success') {
      debugPrint('${user.name} 签到成功');
    } else if (result == 'success2') {
      failedAccounts.add('${user.name} (已过截止时间)');
    } else {
      failedAccounts.add('${user.name} ($result)');
    }
  }

  void updateSelectedAccounts(List<User> accounts) {
    state = state.copyWith(selectedAccounts: accounts);
  }

  void setUserObjectId(String uid, String objectId) {
    final newUserObjectIds = Map<String, String>.from(state.userObjectIds);
    newUserObjectIds[uid] = objectId;
    state = state.copyWith(userObjectIds: newUserObjectIds);
  }

  void setPattern(String pattern) {
    state = state.copyWith(pattern: pattern);
  }

  void setSignCode(String signCode) {
    state = state.copyWith(signCode: signCode);
  }

  void setEnc(String enc) {
    state = state.copyWith(enc: enc);
  }

  void setLocation({String? address, double? latitude, double? longitude}) {
    state = state.copyWith(
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }

  void showResult(String message, bool success) {
    state = state.copyWith(result: message);
  }

  void _handleError(String message) {
    state = state.copyWith(isLoading: false, result: message);
    _showErrorMessage(message);
  }

  void _showErrorMessage(String message) {
    final navigatorKey = AppDependencies.instance.navigatorKey;
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
      );
    }
  }

  void _showMultiSignResult(int totalCount, List<String> failedAccounts) {
    final navigatorKey = AppDependencies.instance.navigatorKey;
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final successCount = totalCount - failedAccounts.length;
    String message = '签到完成！\n成功: $successCount/$totalCount';
    if (failedAccounts.isNotEmpty) {
      message += '\n\n失败账号:\n${failedAccounts.join('\n')}';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          successCount == totalCount ? '全部签到成功' : '部分失败',
          style: TextStyle(
            color: successCount == totalCount ? Colors.green : Colors.orange,
          ),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

final signInControllerProvider =
    StateNotifierProvider<SignInController, SignInState>(
      (ref) => SignInController(),
    );

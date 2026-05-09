import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/enums.dart';
import '../widgets/sign_areas/normal_sign_area.dart';
import '../widgets/sign_areas/code_sign_area.dart';
import '../widgets/sign_areas/location_sign_area.dart';
import '../widgets/sign_areas/qr_code_sign_area.dart';
import '../widgets/sign_areas/pattern_sign_area.dart';
import '../widgets/sign_areas/group_sign_area.dart';
import '../widgets/accounts_selector.dart';
import '../controllers/sign_in_controller.dart';

class SignInPage extends ConsumerStatefulWidget {
  final String courseId;
  final String classId;
  final String cpi;
  final String activeId;
  final String? enc;

  const SignInPage({
    super.key,
    required this.courseId,
    this.classId = '',
    this.cpi = '',
    required this.activeId,
    this.enc,
  });

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage>
    with AutomaticKeepAliveClientMixin {
  bool _dataLoaded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadSignInfo();
      }
    });
  }

  Future<void> _loadSignInfo() async {
    await ref
        .read(signInControllerProvider.notifier)
        .loadSignInfo(widget.activeId);
    if (mounted) {
      setState(() => _dataLoaded = true);
    }
    final state = ref.read(signInControllerProvider);
    if (state.isDataLoaded && state.signType != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _autoExecuteSignIn();
      });
    }
  }

  void _autoExecuteSignIn() {
    final state = ref.read(signInControllerProvider);
    final signType = state.signType;

    if (signType == SignType.qrCode && widget.enc != null) {
      final controller = ref.read(signInControllerProvider.notifier);
      controller.setEnc(widget.enc!);
      controller.performMultiSign(
        courseId: widget.courseId,
        activeId: widget.activeId,
        classId: widget.classId,
        cpi: widget.cpi,
        enc: widget.enc,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(signInControllerProvider);

    if (!_dataLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('签到')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: LinearProgressIndicator(),
              ),
            if (state.result != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Card(
                  color: state.result!.contains('成功')
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(state.result!, textAlign: TextAlign.center),
                  ),
                ),
              ),
            AccountsSelector(
              onSelectionChanged: (selected) {
                ref
                    .read(signInControllerProvider.notifier)
                    .setSelectedAccounts(selected);
              },
              initiallyExpanded: true,
            ),
            const SizedBox(height: 16),
            _buildSignArea(state),
          ],
        ),
      ),
    );
  }

  Widget _buildSignArea(SignInState state) {
    final controller = ref.read(signInControllerProvider.notifier);

    switch (state.signType) {
      case SignType.normal:
        return NormalSignArea(
          controller: controller,
          courseId: widget.courseId,
          activeId: widget.activeId,
          classId: widget.classId,
          cpi: widget.cpi,
          needPhoto: state.needPhoto,
          selectedAccounts: state.selectedAccounts,
          userObjectIds: state.userObjectIds,
        );
      case SignType.code:
        return CodeSignArea(
          controller: controller,
          courseId: widget.courseId,
          activeId: widget.activeId,
          classId: widget.classId,
          cpi: widget.cpi,
        );
      case SignType.location:
        return LocationSignArea(
          controller: controller,
          courseId: widget.courseId,
          activeId: widget.activeId,
          classId: widget.classId,
          cpi: widget.cpi,
        );
      case SignType.qrCode:
        return QrCodeSignArea(
          controller: controller,
          courseId: widget.courseId,
          activeId: widget.activeId,
          classId: widget.classId,
          cpi: widget.cpi,
          initialEnc: widget.enc,
          userCaptchaValidates: state.userCaptchaValidates,
          selectedAccounts: state.selectedAccounts,
        );
      case SignType.pattern:
        return PatternSignArea(
          controller: controller,
          courseId: widget.courseId,
          activeId: widget.activeId,
          classId: widget.classId,
          cpi: widget.cpi,
        );
      case SignType.groupSignIn:
        return GroupSignArea(
          controller: controller,
          courseId: widget.courseId,
          activeId: widget.activeId,
          classId: widget.classId,
          cpi: widget.cpi,
        );
      default:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 48,
                  color: Colors.orange[300],
                ),
                const SizedBox(height: 16),
                Text(
                  '未知的签到类型',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        );
    }
  }
}

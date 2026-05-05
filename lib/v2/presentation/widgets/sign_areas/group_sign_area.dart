import 'package:flutter/material.dart';

import '../../controllers/sign_in_controller.dart';
import '../../../domain/entities/enums.dart';
import 'normal_sign_area.dart';
import 'pattern_sign_area.dart';
import 'code_sign_area.dart';
import 'qr_code_sign_area.dart';
import 'location_sign_area.dart';

class GroupSignArea extends StatelessWidget {
  final SignInController controller;
  final String courseId;
  final String activeId;
  final String classId;
  final String cpi;

  const GroupSignArea({
    super.key,
    required this.controller,
    required this.courseId,
    required this.activeId,
    required this.classId,
    required this.cpi,
  });

  @override
  Widget build(BuildContext context) {
    final state = controller.currentState;
    final signType = state.signType;

    switch (signType) {
      case SignType.normal:
        return NormalSignArea(
          controller: controller,
          courseId: courseId,
          activeId: activeId,
          classId: classId,
          cpi: cpi,
          needPhoto: state.needPhoto,
          selectedAccounts: state.selectedAccounts,
          userObjectIds: state.userObjectIds,
        );
      case SignType.pattern:
        return PatternSignArea(
          controller: controller,
          courseId: courseId,
          activeId: activeId,
          classId: classId,
          cpi: cpi,
        );
      case SignType.code:
        return CodeSignArea(
          controller: controller,
          courseId: courseId,
          activeId: activeId,
          classId: classId,
          cpi: cpi,
        );
      case SignType.qrCode:
        return QrCodeSignArea(
          controller: controller,
          courseId: courseId,
          activeId: activeId,
          classId: classId,
          cpi: cpi,
          userCaptchaValidates: state.userCaptchaValidates,
          selectedAccounts: state.selectedAccounts,
        );
      case SignType.location:
        return LocationSignArea(
          controller: controller,
          courseId: courseId,
          activeId: activeId,
          classId: classId,
          cpi: cpi,
        );
      default:
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    '不支持的签到类型',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}

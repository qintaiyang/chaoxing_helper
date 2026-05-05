import 'package:flutter/material.dart';
import 'package:pattern_lock/pattern_lock.dart';

import '../../controllers/sign_in_controller.dart';
import '../../../app_dependencies.dart';

class PatternSignArea extends StatelessWidget {
  final SignInController controller;
  final String courseId;
  final String activeId;
  final String classId;
  final String cpi;

  const PatternSignArea({
    super.key,
    required this.controller,
    required this.courseId,
    required this.activeId,
    required this.classId,
    required this.cpi,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: PatternLock(
                dimension: 3,
                relativePadding: 0.5,
                selectedColor: Theme.of(context).colorScheme.primary,
                notSelectedColor: Theme.of(context).dividerColor,
                pointRadius: 30,
                onInputComplete: (List<int> pattern) async {
                  final pattern1to9 = pattern
                      .map((p) => p + 1)
                      .toList()
                      .join('');
                  controller.setPattern(pattern1to9);

                  final deps = AppDependencies.instance;
                  final isValid = await deps.cxSignInApi.checkSignCode(
                    activeId: activeId,
                    signCode: pattern1to9,
                  );

                  if (isValid == true) {
                    controller.performMultiSign(
                      courseId: courseId,
                      activeId: activeId,
                      classId: classId,
                      cpi: cpi,
                      signCode: pattern1to9,
                    );
                  } else {
                    controller.showResult('手势不正确，请重新绘制', false);
                    controller.setPattern('');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

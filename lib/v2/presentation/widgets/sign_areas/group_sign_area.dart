import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/sign_in_controller.dart';

class GroupSignArea extends ConsumerStatefulWidget {
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
  ConsumerState<GroupSignArea> createState() => _GroupSignAreaState();
}

class _GroupSignAreaState extends ConsumerState<GroupSignArea> {
  bool _isPreSignComplete = false;

  @override
  void initState() {
    super.initState();
    _preSign();
  }

  Future<void> _preSign() async {
    try {
      await widget.controller.preGroupSign(widget.activeId);
    } catch (e) {
      debugPrint('群聊预签到失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isPreSignComplete = true;
        });
      }
    }
  }

  void _performSign() {
    final state = ref.read(signInControllerProvider);

    if (state.selectedAccounts.isEmpty) return;

    widget.controller.performMultiSign(
      courseId: widget.courseId,
      activeId: widget.activeId,
      classId: widget.classId,
      cpi: widget.cpi,
      isGroupSignIn: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isPreSignComplete) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.group,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '群聊签到',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '选择账号后点击签到按钮，将为所有选中账号执行签到',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _performSign,
                icon: const Icon(Icons.check),
                label: const Text('立即签到'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

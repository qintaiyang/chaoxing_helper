import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controllers/sign_in_controller.dart';
import '../../../app_dependencies.dart';

class CodeSignArea extends StatefulWidget {
  final SignInController controller;
  final String courseId;
  final String activeId;
  final String classId;
  final String cpi;

  const CodeSignArea({
    super.key,
    required this.controller,
    required this.courseId,
    required this.activeId,
    required this.classId,
    required this.cpi,
  });

  @override
  State<CodeSignArea> createState() => _CodeSignAreaState();
}

class _CodeSignAreaState extends State<CodeSignArea> {
  final _codeController = TextEditingController();
  bool _isValidating = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _performSign() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入签到码')));
      return;
    }

    setState(() => _isValidating = true);

    final deps = AppDependencies.instance;
    final isValid = await deps.cxSignInApi.checkSignCode(
      activeId: widget.activeId,
      signCode: code,
    );

    setState(() => _isValidating = false);

    if (isValid == true) {
      widget.controller.setSignCode(code);
      widget.controller.performMultiSign(
        courseId: widget.courseId,
        activeId: widget.activeId,
        classId: widget.classId,
        cpi: widget.cpi,
        signCode: code,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('签到码不正确')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              decoration: InputDecoration(
                labelText: '签到码',
                hintText: '请输入老师提供的签到码',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _codeController.clear(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isValidating ? null : _performSign,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isValidating
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        '立即签到',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

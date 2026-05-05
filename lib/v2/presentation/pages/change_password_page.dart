import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../app_dependencies.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _captchaCtrl = TextEditingController();
  bool _showOld = false, _showNew = false, _showConfirm = false;
  bool _loading = false;
  Uint8List? _captchaBytes;
  bool _captchaLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCaptcha();
  }

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    _captchaCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCaptcha() async {
    setState(() => _captchaLoading = true);
    final bytes =
        await AppDependencies.instance.cxAccountManageApi.downloadCaptchaImage();
    if (mounted) {
      setState(() {
        _captchaBytes = bytes;
        _captchaLoading = false;
      });
    }
  }

  Future<void> _submit() async {
    final oldPwd = _oldCtrl.text.trim();
    final newPwd = _newCtrl.text.trim();
    final confirmPwd = _confirmCtrl.text.trim();
    final captcha = _captchaCtrl.text.trim();

    if (oldPwd.isEmpty) return _snack('请输入旧密码');
    if (newPwd.length < 6) return _snack('新密码长度不能少于6位');
    if (newPwd != confirmPwd) return _snack('两次输入的密码不一致');
    if (captcha.isEmpty) return _snack('请输入图形验证码');

    setState(() => _loading = true);
    try {
      final result =
          await AppDependencies.instance.cxAccountManageApi.changePassword(
        oldPassword: oldPwd,
        newPassword: newPwd,
        confirmPassword: confirmPwd,
        captcha: captcha,
      );
      if (!mounted) return;
      _snack(result.message);
      if (result.success) {
        Navigator.pop(context);
      } else {
        _loadCaptcha();
        _captchaCtrl.clear();
      }
    } catch (e) {
      if (mounted) _snack('修改失败: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('修改密码')),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('修改密码',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 24),
                    _pwField(_oldCtrl, '旧密码', _showOld,
                        () => setState(() => _showOld = !_showOld)),
                    const SizedBox(height: 16),
                    _pwField(_newCtrl, '新密码', _showNew,
                        () => setState(() => _showNew = !_showNew)),
                    const SizedBox(height: 16),
                    _pwField(_confirmCtrl, '确认新密码', _showConfirm,
                        () => setState(() => _showConfirm = !_showConfirm)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _captchaCtrl,
                      decoration: InputDecoration(
                        labelText: '图形验证码',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.security),
                        suffixIcon: GestureDetector(
                          onTap: _captchaLoading ? null : _loadCaptcha,
                          child: Container(
                            width: 90,
                            height: 40,
                            margin: const EdgeInsets.all(8),
                            child: _captchaLoading
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : _captchaBytes != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image.memory(_captchaBytes!,
                                            fit: BoxFit.cover),
                                      )
                                    : const Center(
                                        child: Text('点击加载',
                                            style: TextStyle(fontSize: 10))),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('确认修改'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pwField(TextEditingController ctrl, String label, bool visible,
      VoidCallback toggle) {
    return TextField(
      controller: ctrl,
      obscureText: !visible,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
      ),
    );
  }
}

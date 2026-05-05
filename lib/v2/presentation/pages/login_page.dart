import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import '../controllers/auth_controller.dart';
import '../../app_dependencies.dart';
import 'scan_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  bool _obscurePassword = true;
  late TabController _tabController;
  int _countdownSeconds = 0;
  String? _qrImageUrl;
  String? _qrUuid;
  String? _qrEnc;
  bool _qrLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handlePasswordLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      _showSnackBar('请输入账号和密码');
      return;
    }
    await ref
        .read(authControllerProvider.notifier)
        .loginWithPassword(username, password);
  }

  Future<void> _handleCaptchaLogin() async {
    final phone = _usernameController.text.trim();
    final code = _captchaController.text.trim();
    if (phone.isEmpty) {
      _showSnackBar('请输入手机号');
      return;
    }
    if (code.isEmpty) {
      _showSnackBar('请输入验证码');
      return;
    }
    await ref.read(authControllerProvider.notifier).loginWithPhone(phone, code);
  }

  Future<void> _handleWebLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      _showSnackBar('请输入账号和密码');
      return;
    }
    await ref
        .read(authControllerProvider.notifier)
        .loginWithPassword(username, password);
  }

  Future<void> _sendCaptcha() async {
    final phone = _usernameController.text.trim();
    if (phone.isEmpty) {
      _showSnackBar('请输入手机号');
      return;
    }
    try {
      final deps = AppDependencies.instance;
      final success = await deps.cxAuthApi.sendCaptcha(phone);
      if (success && mounted) {
        _showSnackBar('验证码已发送');
        _startCountdown();
      } else if (mounted) {
        _showSnackBar('发送验证码失败');
      }
    } catch (e) {
      if (mounted) _showSnackBar('发送失败: $e');
    }
  }

  void _startCountdown() {
    _countdownSeconds = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _countdownSeconds--);
      return _countdownSeconds > 0;
    });
  }

  Future<void> _loadQRCode() async {
    setState(() => _qrLoading = true);
    try {
      const loginPageUrl = 'https://passport2.chaoxing.com/login';
      final deps = AppDependencies.instance;
      final response = await deps.dioClient.sendRequest(
        loginPageUrl,
        responseType: ResponseType.plain,
      );
      final html = response.data as String;
      final uuidMatch = RegExp(r'value="(.+?)" id="uuid"').firstMatch(html);
      final encMatch = RegExp(r'value="(.+?)" id="enc"').firstMatch(html);
      if (uuidMatch != null && encMatch != null) {
        _qrUuid = uuidMatch.group(1);
        _qrEnc = encMatch.group(1);
        _qrImageUrl =
            'https://passport2.chaoxing.com/createqr?uuid=$_qrUuid&fid=-1';
      }
    } catch (e) {
      debugPrint('加载二维码失败: $e');
    }
    if (mounted) setState(() => _qrLoading = false);
    _pollQRStatus();
  }

  void _pollQRStatus() async {
    while (mounted && _qrUuid != null && _qrEnc != null) {
      await Future.delayed(const Duration(seconds: 3));
      try {
        final deps = AppDependencies.instance;
        final result = await deps.cxAuthApi.checkQRAuthStatus(
          _qrUuid!,
          _qrEnc!,
        );
        if (result != null && result['status'] == true) {
          if (mounted) {
            final userResult = await deps.authRepo.getCurrentUser();
            userResult.fold((_) {}, (user) {
              ref.read(authControllerProvider.notifier).state = AsyncValue.data(
                user,
              );
            });
          }
          return;
        }
      } catch (_) {}
    }
  }

  void _showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen(authControllerProvider, (prev, next) {
      if (next.hasValue && next.value != null && context.mounted) {
        context.go('/home');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(Icons.school, size: 48, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              '课程助手 V2',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: '密码'),
                Tab(text: '验证码'),
                Tab(text: '二维码'),
                Tab(text: 'Web'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPasswordTab(theme),
                  _buildCaptchaTab(theme),
                  _buildQRCodeTab(theme),
                  _buildWebTab(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordTab(ThemeData theme) {
    final authState = ref.watch(authControllerProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: '手机号',
              prefixIcon: Icon(Icons.phone_android),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: '密码',
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: authState.isLoading ? null : _handlePasswordLogin,
              child: authState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('登录'),
            ),
          ),
          if (authState.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                authState.error.toString(),
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCaptchaTab(ThemeData theme) {
    final authState = ref.watch(authControllerProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: '手机号',
              prefixIcon: Icon(Icons.phone_android),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _captchaController,
                  decoration: const InputDecoration(
                    labelText: '验证码',
                    prefixIcon: Icon(Icons.sms),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 56,
                child: _countdownSeconds > 0
                    ? OutlinedButton(
                        onPressed: null,
                        child: Text('${_countdownSeconds}s'),
                      )
                    : OutlinedButton(
                        onPressed: _sendCaptcha,
                        child: const Text('获取验证码'),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: authState.isLoading ? null : _handleCaptchaLogin,
              child: authState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('验证码登录'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeTab(ThemeData theme) {
    if (_qrImageUrl == null && !_qrLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadQRCode());
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: _qrLoading
                ? const Center(child: CircularProgressIndicator())
                : _qrImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(_qrImageUrl!, fit: BoxFit.contain),
                  )
                : const Center(
                    child: Text('加载失败', style: TextStyle(color: Colors.grey)),
                  ),
          ),
          const SizedBox(height: 16),
          const Text('请使用学习通APP扫描二维码登录'),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _qrLoading ? null : _loadQRCode,
            icon: const Icon(Icons.refresh),
            label: const Text('刷新'),
          ),
        ],
      ),
    );
  }

  Widget _buildWebTab(ThemeData theme) {
    final authState = ref.watch(authControllerProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: '手机号',
              prefixIcon: Icon(Icons.phone_android),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: '密码',
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Web登录使用网页版接口，可有效规避APP端风控',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: authState.isLoading ? null : _handleWebLogin,
              child: authState.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Web登录'),
            ),
          ),
        ],
      ),
    );
  }
}

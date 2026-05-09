import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../controllers/sign_in_controller.dart';
import '../../../app_dependencies.dart';
import '../../../domain/entities/user.dart';

class QrCodeSignArea extends StatefulWidget {
  final SignInController controller;
  final String courseId;
  final String activeId;
  final String classId;
  final String cpi;
  final Map<String, Map<String, String>> userCaptchaValidates;
  final List<User> selectedAccounts;
  final String? initialEnc;

  const QrCodeSignArea({
    super.key,
    required this.controller,
    required this.courseId,
    required this.activeId,
    required this.classId,
    required this.cpi,
    this.userCaptchaValidates = const {},
    this.selectedAccounts = const [],
    this.initialEnc,
  });

  @override
  State<QrCodeSignArea> createState() => _QrCodeSignAreaState();
}

class _QrCodeSignAreaState extends State<QrCodeSignArea> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanning = true;
  bool _isSigning = false;
  bool _hasAutoExecuted = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialEnc != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_hasAutoExecuted) {
          _autoExecuteQrSignIn();
        }
      });
    }
  }

  Future<void> _autoExecuteQrSignIn() async {
    setState(() {
      _isScanning = false;
      _isSigning = true;
      _hasAutoExecuted = true;
    });

    final enc = widget.initialEnc!;
    widget.controller.setEnc(enc);

    widget.controller.performMultiSign(
      courseId: widget.courseId,
      activeId: widget.activeId,
      classId: widget.classId,
      cpi: widget.cpi,
      enc: enc,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (!_isScanning || _isSigning) return;

    final code = capture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    setState(() {
      _isScanning = false;
      _isSigning = true;
    });

    await _controller.stop();

    String? enc;
    String? enc2;
    String? qrActiveId;

    try {
      final uri = Uri.parse(code);
      enc = uri.queryParameters['enc'];
      enc2 = uri.queryParameters['enc2'];
      qrActiveId = uri.queryParameters['id'];
    } catch (e) {
      final parts = code.split(',');
      for (var part in parts) {
        if (part.startsWith('enc=')) {
          enc = part.substring(4);
        } else if (part.startsWith('enc2=')) {
          enc2 = part.substring(5);
        } else if (part.startsWith('id=')) {
          qrActiveId = part.substring(3);
        }
      }
    }

    final activeId = qrActiveId ?? widget.activeId;

    if (enc == null || enc.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('二维码格式不正确')));
      }
      setState(() {
        _isScanning = true;
        _isSigning = false;
      });
      await _controller.start();
      return;
    }

    final deps = AppDependencies.instance;
    final isValid = await deps.cxSignInApi.checkQrCode(
      activeId: activeId,
      enc: enc,
      enc2: enc2,
    );

    if (isValid == true) {
      widget.controller.setEnc(enc);

      final currentValidates = Map<String, Map<String, String>>.from(
        widget.userCaptchaValidates,
      );
      if (enc2 != null) {
        for (var user in widget.selectedAccounts) {
          final userValidate = currentValidates[user.uid] ?? {};
          userValidate['enc2'] = enc2;
          currentValidates[user.uid] = userValidate;
        }
      }

      widget.controller.performMultiSign(
        courseId: widget.courseId,
        activeId: activeId,
        classId: widget.classId,
        cpi: widget.cpi,
        enc: enc,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('二维码无效或已过期')));
      }
      setState(() {
        _isScanning = true;
        _isSigning = false;
      });
      await _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: MobileScanner(
                controller: _controller,
                onDetect: _handleBarcode,
              ),
            ),
            const SizedBox(height: 16),
            if (_isSigning)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 16),
                  const Text('正在签到...'),
                ],
              )
            else
              Text(
                '将二维码放入框内，即可自动扫描',
                style: TextStyle(color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }
}

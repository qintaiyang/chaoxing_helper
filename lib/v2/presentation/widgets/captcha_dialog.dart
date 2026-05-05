import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';

import '../../app_dependencies.dart';

class CaptchaDialog {
  static Future<String?> showSlideCaptchaDialog(
    BuildContext context, {
    String? referer,
  }) async {
    return showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _SlideCaptchaDialog(referer: referer);
      },
    );
  }
}

class _SlideCaptchaDialog extends StatefulWidget {
  final String? referer;
  const _SlideCaptchaDialog({this.referer});

  @override
  State<_SlideCaptchaDialog> createState() => _SlideCaptchaDialogState();
}

class _SlideCaptchaDialogState extends State<_SlideCaptchaDialog> {
  bool _isLoadingSlide = false;
  String? _token;
  String? _shadeImageUrl;
  String? _cutoutImageUrl;
  double _sliderPosition = 0.0;
  bool _isDragging = false;
  bool _hasSubmitted = false;

  static const double backgroundWidth = 320.0;
  static const double backgroundHeight = 160.0;
  static const double cutoutWidth = 56.0;
  static const double cutoutHeight = 160.0;
  static const double ratio = 280.0 / 264.0;

  double _actualBgWidth = backgroundWidth;
  double _actualCutoutWidth = cutoutWidth;
  double? _originalImageWidth;

  final GlobalKey _bgImageKey = GlobalKey();
  final GlobalKey _cutoutImageKey = GlobalKey();

  double get maxButtonPhysical => _actualBgWidth - _actualCutoutWidth;

  @override
  void initState() {
    super.initState();
    _loadSlideCaptcha();
  }

  void _updateActualSizes() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bgContext = _bgImageKey.currentContext;
      if (bgContext != null) {
        final bgRenderBox = bgContext.findRenderObject() as RenderBox?;
        if (bgRenderBox != null && bgRenderBox.hasSize) {
          setState(() {
            _actualBgWidth = bgRenderBox.size.width;
          });
        }
      }
      final cutoutContext = _cutoutImageKey.currentContext;
      if (cutoutContext != null) {
        final cutoutRenderBox = cutoutContext.findRenderObject() as RenderBox?;
        if (cutoutRenderBox != null && cutoutRenderBox.hasSize) {
          setState(() {
            _actualCutoutWidth = cutoutRenderBox.size.width;
          });
        }
      }
    });
  }

  Future<void> _loadSlideCaptcha() async {
    setState(() => _isLoadingSlide = true);

    try {
      final result = await _getCaptchaImages(widget.referer ?? '');

      if (result != null && result.containsKey('token')) {
        setState(() {
          _token = result['token'] as String;
          _shadeImageUrl =
              result['imageVerificationVo']['shadeImage'] as String;
          _cutoutImageUrl =
              result['imageVerificationVo']['cutoutImage'] as String;
          if (result['imageVerificationVo'].containsKey('originalWidth')) {
            _originalImageWidth =
                (result['imageVerificationVo']['originalWidth'] as num)
                    .toDouble();
          }
          _isLoadingSlide = false;
          _sliderPosition = 0.0;
        });
        _updateActualSizes();
      } else {
        _showError('获取验证码失败');
        setState(() => _isLoadingSlide = false);
      }
    } catch (e) {
      _showError('加载验证码时出错: $e');
      setState(() => _isLoadingSlide = false);
    }
  }

  double get cutoutLeft {
    final double designSliderPos =
        _sliderPosition * (backgroundWidth / _actualBgWidth);
    final double designCutoutLeft = designSliderPos * ratio - 8.0;
    if (_originalImageWidth != null && _originalImageWidth! > 0) {
      return designCutoutLeft * (_originalImageWidth! / backgroundWidth);
    }
    return designCutoutLeft;
  }

  Future<void> _submitSlideCaptcha() async {
    if (_hasSubmitted) return;

    if (_sliderPosition <= 0.1) {
      _showError('请拖动滑块完成验证');
      return;
    }

    if (_token == null || _token!.isEmpty) {
      _showError('验证码未加载完成，请稍后再试');
      return;
    }

    setState(() {
      _hasSubmitted = true;
    });

    try {
      final validate = await _submitCaptcha(
        cutoutLeft,
        _token!,
        widget.referer ?? '',
      );

      if (validate != null && validate.isNotEmpty) {
        if (mounted) {
          Navigator.pop(context, validate);
        }
      } else {
        _showError('验证失败，请重试');
        await _loadSlideCaptcha();
        setState(() {
          _sliderPosition = 0.0;
          _hasSubmitted = false;
        });
      }
    } catch (e) {
      _showError('提交验证时出错: $e');
    }
  }

  Future<Map<String, dynamic>?> _getCaptchaImages(String referer) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final captchaId = 'cx_captcha_id_placeholder';
    final encryption = AppDependencies.instance.encryption;

    try {
      const configUrl = 'https://captcha.chaoxing.com/captcha/get/conf';
      final configParams = {
        'callback': 'cx_captcha_function',
        'captchaId': captchaId,
        '_': timestamp.toString(),
      };

      final dioClient = AppDependencies.instance.dioClient;
      final configResponse = await dioClient.sendRequest(
        configUrl,
        params: configParams,
        responseType: ResponseType.plain,
      );

      final String configResponseText = configResponse.data;
      final captchaRegExp = RegExp(r'cx_captcha_function\((.+)\)');
      final Match? configMatch = captchaRegExp.firstMatch(configResponseText);

      if (configMatch == null) {
        debugPrint('Error: Failed to parse captcha config response');
        return null;
      }

      final String configJsonString = configMatch.group(1)!.trim();
      final Map<String, dynamic> config = jsonDecode(configJsonString);

      final int serviceTime = config['t'];
      final uuid1 = _uuid();
      final String captchaKey = encryption.md5Hash('$serviceTime$uuid1');
      final String token =
          '${encryption.md5Hash('$serviceTime$captchaId slide$captchaKey')}:${serviceTime + 300000}';
      final uuid2 = _uuid();
      final String iv = encryption.md5Hash('$captchaId slide$timestamp$uuid2');

      const imageUrl =
          'https://captcha.chaoxing.com/captcha/get/verification/image';
      final imageParams = {
        'callback': 'cx_captcha_function',
        'captchaId': captchaId,
        'type': 'slide',
        'version': '1.1.20',
        'captchaKey': captchaKey,
        'token': token,
        'referer': referer,
        'iv': iv,
        '_': (timestamp + 1).toString(),
      };

      final response = await dioClient.sendRequest(
        imageUrl,
        params: imageParams,
        responseType: ResponseType.plain,
      );

      final String responseText = response.data;
      final Match? match = captchaRegExp.firstMatch(responseText);

      if (match != null) {
        final String jsonString = match.group(1)!.trim();
        return jsonDecode(jsonString);
      }
    } catch (e) {
      debugPrint('Error getting captcha images: $e');
    }
    return null;
  }

  Future<String?> _submitCaptcha(
    double xValue,
    String token,
    String referer,
  ) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final captchaId = 'cx_captcha_id_placeholder';
    final encryption = AppDependencies.instance.encryption;
    final uuid3 = _uuid();
    final String iv = encryption.md5Hash('$captchaId slide$timestamp$uuid3');

    try {
      const url =
          'https://captcha.chaoxing.com/captcha/check/verification/result';
      final params = {
        'callback': 'cx_captcha_function',
        'captchaId': captchaId,
        'type': 'slide',
        'token': token,
        'textClickArr': '[{"x":${xValue.round()}}]',
        'coordinate': '[]',
        'runEnv': '10',
        'version': '1.1.20',
        't': 'a',
        'iv': iv,
        '_': (timestamp + 2).toString(),
      };

      final dioClient = AppDependencies.instance.dioClient;
      final response = await dioClient.sendRequest(
        url,
        params: params,
        headers: {'Referer': referer},
        responseType: ResponseType.plain,
      );

      final String responseText = response.data;
      final captchaRegExp = RegExp(r'cx_captcha_function\((.+)\)');
      final Match? match = captchaRegExp.firstMatch(responseText);

      if (match != null) {
        final String jsonString = match.group(1)!.trim();
        final Map<String, dynamic> result = jsonDecode(jsonString);

        if (result['error'] == 0 && result['result'] == true) {
          final String extraData = result['extraData'];
          final Map<String, dynamic> extraDataMap = jsonDecode(extraData);
          return extraDataMap['validate'];
        }
      }
    } catch (e) {
      debugPrint('Error submitting captcha: $e');
    }
    return null;
  }

  static String _uuid() {
    final Random random = Random();
    final String hexChars = '0123456789abcdef';
    final List<String> vA = List.generate(
      36,
      (index) => hexChars[random.nextInt(16)],
    );

    vA[14] = '4';
    final String originalChar = vA[19];
    final int num = int.tryParse(originalChar, radix: 16) ?? 0;
    final int newValue = (num & 3) | 8;
    vA[19] = hexChars[newValue];

    final List<int> dashPositions = [8, 13, 18, 23];
    for (int pos in dashPositions) {
      vA[pos] = '-';
    }

    return vA.join('');
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('滑块验证'),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 340,
        constraints: const BoxConstraints(maxHeight: 300),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '请拖动滑块填充拼图',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                _buildSlideCaptchaContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlideCaptchaContainer() {
    final Color borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade300;

    return SizedBox(
      width: backgroundWidth,
      height: backgroundHeight + 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (_shadeImageUrl != null)
            Image.network(
              _shadeImageUrl!,
              key: _bgImageKey,
              width: backgroundWidth,
              height: backgroundHeight,
              fit: BoxFit.fill,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: backgroundWidth,
                  height: backgroundHeight,
                  color: Colors.grey.shade200,
                  child: const Center(child: Text('加载中...')),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                width: backgroundWidth,
                height: backgroundHeight,
                color: Colors.grey.shade200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.grey.shade600, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        '图片加载失败',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          if (_cutoutImageUrl != null)
            Positioned(
              left: _sliderPosition,
              top: 0,
              child: Image.network(
                _cutoutImageUrl!,
                key: _cutoutImageKey,
                width: cutoutWidth,
                height: cutoutHeight,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: cutoutWidth,
                  height: cutoutHeight,
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red.shade300, width: 1),
                  ),
                  child: Icon(
                    Icons.error,
                    color: Colors.red.shade600,
                    size: 30,
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Container(
              width: backgroundWidth,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: _sliderPosition,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onPanStart: (details) =>
                          setState(() => _isDragging = true),
                      onPanUpdate: (details) {
                        double newPos = _sliderPosition + details.delta.dx;
                        newPos = newPos.clamp(0.0, maxButtonPhysical);
                        setState(() {
                          _sliderPosition = newPos;
                        });
                      },
                      onPanEnd: (details) async {
                        setState(() => _isDragging = false);
                        _sliderPosition = _sliderPosition.clamp(
                          0.0,
                          maxButtonPhysical,
                        );
                        await _submitSlideCaptcha();
                      },
                      child: Container(
                        width: cutoutWidth,
                        decoration: BoxDecoration(
                          color: _isDragging
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isLoadingSlide)
            Container(
              width: backgroundWidth,
              height: backgroundHeight + 60,
              color: Colors.black26,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '正在加载验证码...',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

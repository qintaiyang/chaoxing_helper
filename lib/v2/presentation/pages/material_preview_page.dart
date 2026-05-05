import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../app_dependencies.dart';

class MaterialPreviewPage extends StatefulWidget {
  final String url;
  final String fileName;

  const MaterialPreviewPage({
    super.key,
    required this.url,
    required this.fileName,
  });

  @override
  State<MaterialPreviewPage> createState() => _MaterialPreviewPageState();
}

class _MaterialPreviewPageState extends State<MaterialPreviewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  static const _browserUa =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(_browserUa)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (url) async {
            await _injectRefererFix(url);
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                _errorMessage = error.description;
              });
            }
          },
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      );

    try {
      await _setupCookies();

      debugPrint('资料预览URL: ${widget.url}');
      final headers = <String, String>{
        'User-Agent': _browserUa,
        'Referer': 'https://mooc1.chaoxing.com/',
      };
      await _controller.loadRequest(Uri.parse(widget.url), headers: headers);
    } catch (e) {
      debugPrint('预览WebView初始化异常: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = '初始化失败: $e';
        });
      }
    }
  }

  Future<void> _setupCookies() async {
    try {
      final cookieManager = AppDependencies.instance.cookieManager;
      final sessionIdResult = AppDependencies.instance.accountRepo
          .getCurrentSessionId();

      sessionIdResult.fold(
        (failure) => debugPrint('获取session失败: ${failure.message}'),
        (userId) async {
          if (userId == null || userId.isEmpty) {
            debugPrint('用户ID为空，无法设置Cookie');
            return;
          }

          final cookieJar = cookieManager.getCurrentUserCookieJar(userId);
          if (cookieJar == null) {
            debugPrint('CookieJar为null，用户 $userId');
            return;
          }

          final hosts = [
            '.chaoxing.com',
            'www.chaoxing.com',
            'passport2.chaoxing.com',
            'mooc1.chaoxing.com',
            'mooc1-1.chaoxing.com',
            'mooc1-api.chaoxing.com',
            'mooc2-ans.chaoxing.com',
            'pan-yz.chaoxing.com',
            'i.chaoxing.com',
            'learn.chaoxing.com',
            'photo.chaoxing.com',
            'im.chaoxing.com',
            'sso.chaoxing.com',
            'passport2-api.chaoxing.com',
            'mobilelearn.chaoxing.com',
          ];

          final allCookies = <String, Cookie>{};

          for (final host in hosts) {
            try {
              final uri = Uri.parse('https://$host');
              final cookies = await cookieJar.loadForRequest(uri);
              for (final c in cookies) {
                final key = '${c.name}@${c.domain ?? host}';
                allCookies.putIfAbsent(key, () => c);
              }
            } catch (e) {
              debugPrint('加载 $host 的Cookie失败: $e');
            }
          }

          final jsCode = _buildCookieInjectionJs(allCookies.values.toList());
          if (jsCode.isNotEmpty) {
            await _controller.runJavaScript(jsCode);
            debugPrint('资料预览通过JavaScript注入了 ${allCookies.length} 个Cookie');
          }
        },
      );
    } catch (e) {
      debugPrint('读取cookies失败: $e');
    }
  }

  String _buildCookieInjectionJs(List<Cookie> cookies) {
    if (cookies.isEmpty) return '';

    final cookieStrings = <String>[];
    for (final cookie in cookies) {
      final name = cookie.name.replaceAll("'", "\\'");
      final value = cookie.value.replaceAll("'", "\\'");
      final domain = cookie.domain ?? '.chaoxing.com';
      final path = cookie.path ?? '/';
      cookieStrings.add(
        "document.cookie = '$name=$value; domain=$domain; path=$path; Secure; SameSite=None';",
      );
    }

    return cookieStrings.join('\n');
  }

  Future<void> _injectRefererFix(String url) async {
    try {
      await _controller.runJavaScript('''
        (function() {
          var viewport = document.querySelector('meta[name=viewport]');
          if (viewport) {
            viewport.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');
          } else {
            viewport = document.createElement('meta');
            viewport.name = 'viewport';
            viewport.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
            document.head.appendChild(viewport);
          }
        })();
      ''');
    } catch (e) {
      debugPrint('Viewport注入失败: $e');
    }
  }

  Future<void> _reload() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    try {
      await _setupCookies();
      final headers = <String, String>{
        'User-Agent': _browserUa,
        'Referer': 'https://mooc1.chaoxing.com/',
      };
      await _controller.loadRequest(Uri.parse(widget.url), headers: headers);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = '重新加载失败: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fileName.length > 25
              ? '${widget.fileName.substring(0, 25)}...'
              : widget.fileName,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
            tooltip: '刷新',
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    '预览加载失败',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      _errorMessage.isNotEmpty ? _errorMessage : '未知错误',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('重新加载'),
                    onPressed: _reload,
                  ),
                ],
              ),
            ),
          if (!_hasError) WebViewWidget(controller: _controller),
          if (_isLoading && !_hasError)
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

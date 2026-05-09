import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../app_dependencies.dart';

class ExamWebViewPage extends StatefulWidget {
  final String courseId;
  final String classId;
  final String cpi;
  final String examId;
  final String examTitle;

  const ExamWebViewPage({
    super.key,
    required this.courseId,
    required this.classId,
    required this.cpi,
    this.examId = '',
    this.examTitle = '',
  });

  @override
  State<ExamWebViewPage> createState() => _ExamWebViewPageState();
}

class _ExamWebViewPageState extends State<ExamWebViewPage> {
  late final WebViewController _controller;
  bool _isControllerReady = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isLoginPage = false;

  static const _browserUa =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    if (Platform.isAndroid) {
      try {
        const platform = MethodChannel('com.chaoxinghelper/webview');
        await platform.invokeMethod('enableMixedContent');
        debugPrint('Android 混合内容模式已启用');
      } catch (e) {
        debugPrint('启用混合内容模式失败: $e');
      }
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(_browserUa)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint('WebView 开始加载: $url');
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (url) async {
            debugPrint('WebView 加载完成: $url');
            await _injectViewportFix();
            await _checkLoginPage();

            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (error) {
            debugPrint(
              'WebView 资源错误: ${error.description} (${error.errorCode}), url=${error.url}',
            );
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
                _errorMessage = '${error.description} (${error.errorCode})';
              });
            }
          },
          onNavigationRequest: (request) {
            debugPrint('WebView 导航请求: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      );

    try {
      await _setupNativeCookies();

      if (mounted) {
        setState(() {
          _isControllerReady = true;
        });
      }

      final examUrl = _buildExamUrl();
      debugPrint('WebView 加载考试URL: $examUrl');
      await _controller.loadRequest(Uri.parse(examUrl));
    } catch (e) {
      debugPrint('WebView 初始化异常: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = '初始化失败: $e';
        });
      }
    }
  }

  Future<void> _setupNativeCookies() async {
    try {
      final cookieManager = AppDependencies.instance.cookieManager;
      final sessionIdResult = AppDependencies.instance.accountRepo
          .getCurrentSessionId();

      sessionIdResult.fold(
        (failure) => debugPrint('获取Session ID失败: ${failure.message}'),
        (userId) async {
          if (userId == null || userId.isEmpty) {
            debugPrint('User ID为空，无法设置Cookie');
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
            debugPrint('通过JavaScript注入了 ${allCookies.length} 个Cookie');
          }
        },
      );
    } catch (e) {
      debugPrint('设置Cookie失败: $e');
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

  Future<void> _injectViewportFix() async {
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

  bool _isLoginPageUrl(String url) {
    return url.contains('passport2.chaoxing.com') ||
        url.contains('passport.chaoxing.com') ||
        (url.contains('login') && url.contains('chaoxing.com'));
  }

  Future<void> _checkLoginPage() async {
    try {
      final currentUrl = await _controller.currentUrl();
      if (currentUrl != null && _isLoginPageUrl(currentUrl)) {
        debugPrint('检测到登录页面: $currentUrl');
        if (mounted) {
          setState(() {
            _isLoginPage = true;
            _isLoading = false;
          });
        }
      } else {
        if (mounted && _isLoginPage) {
          setState(() {
            _isLoginPage = false;
          });
        }
      }
    } catch (e) {
      debugPrint('检查登录页面失败: $e');
    }
  }

  String _buildExamUrl() {
    if (widget.examId.isNotEmpty) {
      return 'https://mooc1-api.chaoxing.com/exam-ans/exam/test/reVersionTestStartNew'
          '?courseId=${widget.courseId}'
          '&classId=${widget.classId}'
          '&cpi=${widget.cpi}'
          '&testPaperId=${widget.examId}'
          '&testUserRelationId=${widget.examId}';
    }

    const baseUrl =
        'https://mooc1-api.chaoxing.com/exam-ans/exam/phone/task-list';
    final params = <String, String>{
      'courseId': widget.courseId,
      'classId': widget.classId,
      'cpi': widget.cpi,
    };

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$baseUrl?$queryString';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.examTitle.isNotEmpty ? widget.examTitle : '考试'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _initWebView();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_isControllerReady)
            WebViewWidget(controller: _controller)
          else
            const Center(child: CircularProgressIndicator()),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            ),
          if (_hasError)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(_errorMessage),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _isLoading = true;
                        });
                        _initWebView();
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
          if (_isLoginPage)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 64,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '请重新打开该页面',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
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

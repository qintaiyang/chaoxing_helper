import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../app_dependencies.dart';
import '../providers/providers.dart';

class ActivityWebViewPage extends ConsumerStatefulWidget {
  final String activeUrl;
  final String activeName;
  final String courseId;
  final String classId;

  const ActivityWebViewPage({
    super.key,
    required this.activeUrl,
    required this.activeName,
    required this.courseId,
    required this.classId,
  });

  @override
  ConsumerState<ActivityWebViewPage> createState() =>
      _ActivityWebViewPageState();
}

class _ActivityWebViewPageState extends ConsumerState<ActivityWebViewPage> {
  WebViewController? _controller;
  bool _loading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _progress = 0;
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
          onProgress: (progress) {
            setState(() {
              _progress = progress;
            });
          },
          onPageStarted: (url) {
            debugPrint('WebView 开始加载: $url');
            if (mounted) {
              setState(() {
                _loading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (url) async {
            debugPrint('WebView 加载完成: $url');

            final controller = _controller;
            if (controller != null) {
              await _injectViewport(controller);
              await _injectCookies(controller);
              await _checkLoginPage();
            }

            if (mounted) {
              setState(() {
                _loading = false;
              });
            }
          },
          onWebResourceError: (error) {
            debugPrint(
              'WebView 资源错误: ${error.description} (${error.errorCode}), url=${error.url}',
            );

            if (error.description.contains('ERR_UNKNOWN_URL_SCHEME') ||
                error.description.contains('net::ERR_ABORTED') ||
                error.errorCode == -10 ||
                error.errorCode == -1) {
              debugPrint('忽略非关键错误（URL scheme/已中止）');
              return;
            }

            debugPrint('显示错误页面: ${error.description}');
            if (mounted) {
              setState(() {
                _hasError = true;
                _errorMessage = error.description;
                _loading = false;
              });
            }
          },
          onNavigationRequest: (request) {
            final url = request.url;
            debugPrint('WebView 导航请求: $url');

            if (url.startsWith('http://') ||
                url.startsWith('https://') ||
                url.startsWith('about:') ||
                url.startsWith('data:') ||
                url.startsWith('javascript:') ||
                url.startsWith('jsbridge://')) {
              return NavigationDecision.navigate;
            }

            debugPrint('阻止不支持的URL scheme: $url');
            return NavigationDecision.prevent;
          },
        ),
      );

    try {
      final controller = _controller;
      if (controller != null) {
        await controller.loadRequest(
          Uri.parse(widget.activeUrl),
          headers: {'Referer': 'https://mobilelearn.chaoxing.com/'},
        );
      }
    } catch (e) {
      debugPrint('WebView 初始化异常: $e');
      if (mounted) {
        setState(() {
          _loading = false;
          _hasError = true;
          _errorMessage = '初始化失败: $e';
        });
      }
    }
  }

  Future<void> _injectViewport(WebViewController controller) async {
    await controller.runJavaScript('''
      var meta = document.createElement('meta');
      meta.setAttribute('name', 'viewport');
      meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');
      document.getElementsByTagName('head')[0].appendChild(meta);
      
      var style = document.createElement('style');
      style.textContent = '* { max-width: 100% !important; box-sizing: border-box !important; }';
      document.head.appendChild(style);
    ''');
  }

  Future<void> _injectCookies(WebViewController controller) async {
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

          await _setCookiesNative(allCookies.values.toList());
          debugPrint('通过原生API注入了 ${allCookies.length} 个Cookie');
        },
      );
    } catch (e) {
      debugPrint('设置Cookie失败: $e');
    }
  }

  Future<void> _setCookiesNative(List<Cookie> cookies) async {
    final cookieManager = WebViewCookieManager();
    for (final cookie in cookies) {
      final domain = cookie.domain ?? '.chaoxing.com';
      final path = cookie.path ?? '/';
      try {
        await cookieManager.setCookie(
          WebViewCookie(
            name: cookie.name,
            value: cookie.value,
            domain: domain.startsWith('.') ? domain : '.$domain',
            path: path,
          ),
        );
      } catch (e) {
        debugPrint('设置Cookie失败 ${cookie.name}: $e');
      }
    }
  }

  bool _isLoginPageUrl(String url) {
    return url.contains('passport2.chaoxing.com') ||
        url.contains('passport.chaoxing.com') ||
        (url.contains('login') && url.contains('chaoxing.com'));
  }

  Future<void> _checkLoginPage() async {
    try {
      final controller = _controller;
      if (controller == null) return;

      final currentUrl = await controller.currentUrl();
      if (currentUrl != null && _isLoginPageUrl(currentUrl)) {
        debugPrint('检测到登录页面: $currentUrl');
        if (mounted) {
          setState(() {
            _isLoginPage = true;
            _loading = false;
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

  Future<void> _reload() async {
    final controller = _controller;
    if (controller == null) return;

    setState(() {
      _hasError = false;
      _loading = true;
    });
    await controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(sessionVersionProvider, (previous, next) {
      if (mounted && previous != next) {
        debugPrint('账号切换，关闭活动页面');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final navigator = Navigator.of(context, rootNavigator: true);
          if (navigator.canPop()) {
            navigator.pop();
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activeName.isNotEmpty ? widget.activeName : '活动'),
        leading: BackButton(
          onPressed: () async {
            final controller = _controller;
            if (controller != null) {
              try {
                final canBack = await controller.canGoBack();
                if (canBack) {
                  await controller.goBack();
                  return;
                }
              } catch (e) {
                debugPrint('WebView返回失败: $e');
              }
            }
            if (context.mounted) {
              if (context.canPop()) {
                context.pop();
              }
            }
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                WebViewWidget(controller: _controller!),
                if (_loading && _progress < 100)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: _progress / 100,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                if (_hasError)
                  Positioned.fill(
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
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
                            Text(
                              '页面加载失败',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            FilledButton.tonal(
                              onPressed: _reload,
                              child: const Text('重新加载'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_isLoginPage)
                  Positioned.fill(
                    child: Container(
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
                  ),
              ],
            ),
    );
  }
}

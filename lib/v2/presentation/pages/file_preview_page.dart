import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../app_dependencies.dart';
import '../../data/datasources/remote/chaoxing/cx_pan_api.dart';

class FilePreviewPage extends StatefulWidget {
  final String resid;
  final String fileName;
  final String encryptedId;
  final bool isImage;

  const FilePreviewPage({
    super.key,
    required this.resid,
    required this.fileName,
    this.encryptedId = '',
    this.isImage = false,
  });

  @override
  State<FilePreviewPage> createState() => _FilePreviewPageState();
}

class _FilePreviewPageState extends State<FilePreviewPage> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  String? _imageUrl;
  bool _loadingImageUrl = true;

  late final CXPanApi _panApi;

  static const _browserUa =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36';

  static const _allHosts = [
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
    '.cldisk.com',
    'pan-yz.cldisk.com',
    's2.cldisk.com',
  ];

  @override
  void initState() {
    super.initState();
    _panApi = AppDependencies.instance.cxPanApi;
    if (widget.isImage) {
      _loadImageUrl();
    } else {
      _initWebView();
    }
  }

  Future<void> _loadImageUrl() async {
    try {
      final url = await _panApi.getImagePreviewUrl(resid: widget.resid);
      if (mounted) {
        setState(() {
          _imageUrl = url;
          _loadingImageUrl = false;
        });
      }
    } catch (e) {
      debugPrint('获取图片URL失败: $e');
      if (mounted) {
        setState(() {
          _loadingImageUrl = false;
          _hasError = true;
          _errorMessage = '获取图片预览链接失败: $e';
        });
      }
    }
  }

  Future<void> _initWebView() async {
    if (Platform.isAndroid) {
      try {
        final platform = MethodChannel('com.chaoxinghelper/webview');
        await platform.invokeMethod('enableMixedContent');
        debugPrint('Android 混合内容模式已启用');
      } catch (e) {
        debugPrint('启用混合内容模式失败: $e');
      }
    }

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(_browserUa);

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;

    _controller!.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          debugPrint('预览WebView开始加载: $url');
          if (mounted) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          }
        },
        onPageFinished: (url) async {
          debugPrint('预览WebView加载完成: $url');
          await _injectViewport();
          await _injectCookiesViaJs();
          await _injectChaoxingMobileStyles();
          if (mounted) setState(() => _isLoading = false);
        },
        onWebResourceError: (error) {
          debugPrint(
            '预览WebView资源错误: ${error.description} (${error.errorCode}), url=${error.url}',
          );
          if (error.errorCode == -1 && mounted) {
            return;
          }
          if (mounted) {
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = '${error.description} (${error.errorCode})';
            });
          }
        },
        onNavigationRequest: (request) {
          debugPrint('预览WebView导航请求: ${request.url}');
          return NavigationDecision.navigate;
        },
      ),
    );

    await _loadPage();
  }

  Future<void> _loadPage() async {
    try {
      await _setupNativeCookies();

      final previewUrl = await _panApi.getPreviewUrl(
        resid: widget.resid,
        encryptedId: widget.encryptedId,
        isFavorite: false,
      );

      if (previewUrl == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMessage = '获取预览链接失败';
          });
        }
        return;
      }

      debugPrint('预览URL: $previewUrl');
      final headers = <String, String>{
        'User-Agent': _browserUa,
        'Referer': 'https://pan-yz.cldisk.com/pcuserpan/index',
      };
      await _controller!.loadRequest(Uri.parse(previewUrl), headers: headers);
    } catch (e) {
      debugPrint('预览WebView加载异常: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = '加载失败: $e';
        });
      }
    }
  }

  Future<void> _setupNativeCookies() async {
    try {
      final sessionIdResult = AppDependencies.instance.accountRepo
          .getCurrentSessionId();
      final userId = sessionIdResult.fold(
        (failure) {
          debugPrint('获取Session ID失败: ${failure.message}');
          return null;
        },
        (id) => id,
      );

      if (userId == null || userId.isEmpty) {
        debugPrint('User ID为空，无法设置Cookie');
        return;
      }

      final cookieJar = AppDependencies.instance.cookieManager
          .getCurrentUserCookieJar(userId);
      if (cookieJar == null) {
        debugPrint('CookieJar为null，用户 $userId');
        return;
      }

      final allCookies = <String, Cookie>{};

      for (final host in _allHosts) {
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
    } catch (e) {
      debugPrint('设置Cookie失败: $e');
    }
  }

  Future<void> _setCookiesNative(List<Cookie> cookies) async {
    final cookieManager = WebViewCookieManager();
    for (final cookie in cookies) {
      final path = cookie.path ?? '/';
      try {
        String domain = cookie.domain ?? '.chaoxing.com';
        final cldiskDomains = [
          '.cldisk.com',
          'pan-yz.cldisk.com',
          's2.cldisk.com',
        ];
        final isCldiskCookie = cldiskDomains.any(
          (d) => domain.contains(d) || d.contains(domain),
        );

        final targetDomain = isCldiskCookie ? '.cldisk.com' : domain;
        await cookieManager.setCookie(
          WebViewCookie(
            name: cookie.name,
            value: cookie.value,
            domain: targetDomain.startsWith('.') ? targetDomain : '.$targetDomain',
            path: path,
          ),
        );
      } catch (e) {
        debugPrint('设置Cookie失败 ${cookie.name}: $e');
      }
    }
  }

  Future<void> _injectViewport() async {
    if (_controller == null) return;
    try {
      await _controller!.runJavaScript('''
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

  Future<void> _injectCookiesViaJs() async {
    try {
      final sessionIdResult = AppDependencies.instance.accountRepo
          .getCurrentSessionId();
      final userId = sessionIdResult.fold(
        (failure) {
          debugPrint('获取Session ID失败: ${failure.message}');
          return null;
        },
        (id) => id,
      );

      if (userId == null || userId.isEmpty) {
        debugPrint('User ID为空，无法注入Cookie');
        return;
      }

      final cookieJar = AppDependencies.instance.cookieManager
          .getCurrentUserCookieJar(userId);
      if (cookieJar == null) {
        debugPrint('CookieJar为null，用户 $userId');
        return;
      }

      final allCookies = <String, Cookie>{};

      for (final host in _allHosts) {
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
      if (jsCode.isNotEmpty && _controller != null) {
        await _controller!.runJavaScript(jsCode);
        debugPrint('通过JavaScript注入了 ${allCookies.length} 个Cookie');
      }
    } catch (e) {
      debugPrint('注入Cookie失败: $e');
    }
  }

  String _buildCookieInjectionJs(List<Cookie> cookies) {
    if (cookies.isEmpty) return '';

    final cookieStrings = <String>[];
    final cldiskDomains = [
      '.cldisk.com',
      'pan-yz.cldisk.com',
      's2.cldisk.com',
    ];
    for (final cookie in cookies) {
      final name = cookie.name.replaceAll("'", "\\'");
      final value = cookie.value.replaceAll("'", "\\'");
      String domain = cookie.domain ?? '.chaoxing.com';
      final path = cookie.path ?? '/';

      if (cldiskDomains.any((d) => domain.contains(d) || d.contains(domain))) {
        domain = '.cldisk.com';
      }

      cookieStrings.add(
        "document.cookie = '$name=$value; domain=$domain; path=$path; Secure; SameSite=None';",
      );
    }

    return cookieStrings.join('\n');
  }

  Future<void> _injectChaoxingMobileStyles() async {
    if (_controller == null) return;
    try {
      await _controller!.runJavaScript('''
(function() {
  var style = document.createElement("style");
  style.textContent = "* { max-width: 100% !important; box-sizing: border-box !important; } body { margin: 0; padding: 0; overflow-x: hidden; } img { max-width: 100% !important; height: auto !important; } iframe { max-width: 100% !important; } video { max-width: 100% !important; }";
  document.head.appendChild(style);
})();
      ''');
    } catch (e) {
      debugPrint('移动端样式注入失败: $e');
    }
  }

  Future<void> _reload() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    if (widget.isImage) {
      _loadImageUrl();
    } else {
      await _loadPage();
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
      body: widget.isImage ? _buildImagePreview() : _buildWebViewPreview(),
    );
  }

  Widget _buildImagePreview() {
    if (_loadingImageUrl) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError || _imageUrl == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.broken_image, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('图片加载失败', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage.isNotEmpty ? _errorMessage : '无法获取图片预览链接',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('重试'),
              onPressed: _reload,
            ),
          ],
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: PhotoView(
        imageProvider: CachedNetworkImageProvider(
          _imageUrl!,
          headers: {
            'Referer': 'https://pan-yz.cldisk.com/pcuserpan/index',
            'User-Agent': _browserUa,
          },
        ),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 3.0,
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event != null && event.expectedTotalBytes != null
                ? event.cumulativeBytesLoaded / event.expectedTotalBytes!
                : null,
          ),
        ),
        errorBuilder: (context, error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image, size: 64, color: Colors.white54),
              const SizedBox(height: 16),
              const Text('图片加载失败', style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
                onPressed: _reload,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWebViewPreview() {
    return Stack(
      children: [
        if (_hasError)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('预览加载失败', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _errorMessage.isNotEmpty ? _errorMessage : '未知错误',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
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
        if (!_hasError && _controller != null)
          WebViewWidget(controller: _controller!),
        if (_isLoading && !_hasError)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }
}

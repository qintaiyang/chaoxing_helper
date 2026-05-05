import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  String? _imageUrl;
  bool _loadingImageUrl = true;

  static const _browserUa =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36';

  @override
  void initState() {
    super.initState();
    if (widget.isImage) {
      _loadImageUrl();
    } else {
      _initWebView();
    }
  }

  Future<void> _loadImageUrl() async {
    try {
      final url = await CXPanApi.getImagePreviewUrl(resid: widget.resid);
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
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(_browserUa)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          debugPrint('预览WebView开始加载: $url');
          if (mounted) setState(() => _isLoading = true);
        },
        onPageFinished: (url) async {
          debugPrint('预览WebView加载完成: $url');
          if (mounted) setState(() => _isLoading = false);
        },
        onWebResourceError: (error) {
          debugPrint('预览WebView资源错误: ${error.description}');
          if (mounted) {
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = error.description;
            });
          }
        },
        onNavigationRequest: (request) {
          debugPrint('预览WebView导航请求: ${request.url}');
          return NavigationDecision.navigate;
        },
      ));

    try {
      final previewUrl = await CXPanApi.getPreviewUrl(
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
      await _controller.loadRequest(Uri.parse(previewUrl), headers: headers);
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

  Future<void> _reload() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });
    if (widget.isImage) {
      _loadImageUrl();
    } else {
      try {
        final previewUrl = await CXPanApi.getPreviewUrl(
          resid: widget.resid,
          encryptedId: widget.encryptedId,
          isFavorite: false,
        );
        if (previewUrl != null) {
          final headers = <String, String>{
            'User-Agent': _browserUa,
            'Referer': 'https://pan-yz.cldisk.com/pcuserpan/index',
          };
          await _controller.loadRequest(Uri.parse(previewUrl), headers: headers);
        }
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
        if (!_hasError) WebViewWidget(controller: _controller),
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

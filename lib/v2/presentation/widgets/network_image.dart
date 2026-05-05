import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../app_dependencies.dart';

class ChaoxingImageCache {
  static final Map<String, Future<Uint8List?>> _cache = {};
  static final Set<String> _loadingUrls = {};
  static final Set<String> _failedUrls = {};

  static Future<Uint8List?> getImage(String url) async {
    if (_cache.containsKey(url)) return _cache[url]!;
    if (_loadingUrls.contains(url)) {
      await Future.delayed(const Duration(milliseconds: 50));
      return getImage(url);
    }
    if (_failedUrls.contains(url)) return null;

    _loadingUrls.add(url);
    final future = _fetchImage(url).whenComplete(() {
      _loadingUrls.remove(url);
    });
    _cache[url] = future;
    return future;
  }

  static Future<Uint8List?> _fetchImage(String url) async {
    try {
      final client = AppDependencies.instance.dioClient;
      final response = await client.sendRequest(
        url,
        responseType: ResponseType.bytes,
        headers: {
          'Referer': url.contains('im.chaoxing.com')
              ? 'https://im.chaoxing.com/'
              : url.contains('ananas.chaoxing.com')
              ? 'https://mooc1.chaoxing.com/'
              : 'https://www.chaoxing.com/',
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 14; Pixel 9 Pro Build/AP1A.240505.005)',
        },
      );

      if (response.data != null && response.data is List<int>) {
        final bytes = response.data is Uint8List
            ? response.data as Uint8List
            : Uint8List.fromList(response.data as List<int>);
        if (bytes.length < 4) {
          _failedUrls.add(url);
          return null;
        }
        final isPng = bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E;
        final isJpg = bytes[0] == 0xFF && bytes[1] == 0xD8;
        final isGif = bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46;
        if (!isPng && !isJpg && !isGif) {
          _failedUrls.add(url);
          return null;
        }
        return bytes;
      }
      _failedUrls.add(url);
      return null;
    } catch (e) {
      _failedUrls.add(url);
      return null;
    }
  }

  static void clear() {
    _cache.clear();
    _loadingUrls.clear();
    _failedUrls.clear();
  }
}

class ChaoxingNetworkImage extends StatefulWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget? placeholder;

  const ChaoxingNetworkImage({
    super.key,
    required this.url,
    this.width = 56,
    this.height = 56,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  ImageProvider get image {
    if (url.isEmpty) return const AssetImage('');
    return _ChaoxingImageProvider(url);
  }

  @override
  State<ChaoxingNetworkImage> createState() => _ChaoxingNetworkImageState();
}

class _ChaoxingNetworkImageState extends State<ChaoxingNetworkImage> {
  Uint8List? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant ChaoxingNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _data = null;
      _loading = true;
      _load();
    }
  }

  Future<void> _load() async {
    if (widget.url.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    final cached = await ChaoxingImageCache.getImage(widget.url);
    if (mounted) {
      setState(() {
        _data = cached;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.isEmpty) {
      return widget.placeholder ??
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Icon(Icons.image),
          );
    }
    if (_loading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (_data != null) {
      return Image.memory(
        _data!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }
    return widget.placeholder ??
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
  }
}

class _ChaoxingImageProvider extends ImageProvider<_ChaoxingImageProvider> {
  final String url;
  const _ChaoxingImageProvider(this.url);

  @override
  Future<_ChaoxingImageProvider> obtainKey(ImageConfiguration config) {
    return SynchronousFuture<_ChaoxingImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
    _ChaoxingImageProvider key,
    ImageDecoderCallback decode,
  ) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(decode),
      scale: 1.0,
      informationCollector: () => [StringProperty('URL', url)],
    );
  }

  Future<ui.Codec> _loadAsync(ImageDecoderCallback decode) async {
    final bytes = await ChaoxingImageCache.getImage(url);
    if (bytes == null || bytes.isEmpty) {
      throw StateError('Failed to load image: $url');
    }
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }
}

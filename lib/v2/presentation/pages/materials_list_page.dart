import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../app_dependencies.dart';
import '../../domain/entities/material.dart' as domain;
import '../widgets/material_icon.dart';
import 'material_preview_page.dart';

class MaterialsListPage extends StatefulWidget {
  final String courseId;
  final String classId;
  final String cpi;
  final int puid;

  const MaterialsListPage({
    super.key,
    required this.courseId,
    required this.classId,
    required this.cpi,
    required this.puid,
  });

  @override
  State<MaterialsListPage> createState() => _MaterialsListPageState();
}

class _MaterialsListPageState extends State<MaterialsListPage> {
  List<domain.Material> _items = [];
  bool _loading = true;
  String? _error;
  String? _currentRootId;
  final List<_FolderStackEntry> _folderStack = [];
  double _downloadProgress = 0.0;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials({String? rootId}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await AppDependencies.instance.getCourseMaterialsUseCase
          .execute(
            courseId: widget.courseId,
            classId: widget.classId,
            cpi: widget.cpi,
            rootId: rootId,
          );
      if (mounted) {
        result.fold(
          (f) => setState(() {
            _loading = false;
            _error = f.message;
          }),
          (list) => setState(() {
            _items = list;
            _loading = false;
          }),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  void _enterFolder(domain.Material folder) {
    _folderStack.add(_FolderStackEntry(rootId: folder.id, name: folder.name));
    _loadMaterials(rootId: folder.id);
  }

  void _goBack() {
    if (_folderStack.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    _folderStack.removeLast();
    final previous = _folderStack.isEmpty ? null : _folderStack.last;
    _currentRootId = previous?.rootId;
    _loadMaterials(rootId: _currentRootId);
  }

  void _showFileOptions(domain.Material file) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility),
              title: const Text('预览'),
              onTap: () {
                Navigator.pop(ctx);
                _previewFile(file);
              },
            ),
            if (!file.forbidDownload)
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('下载'),
                onTap: () {
                  Navigator.pop(ctx);
                  _downloadFile(file);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _previewFile(domain.Material file) async {
    if (file.objectId == null || file.ownerPuid == null) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('正在加载预览...')));

    final result = await AppDependencies.instance.getMaterialDownloadUrlUseCase
        .execute(
          objectId: file.objectId!,
          puid: widget.puid,
          sarepuid: file.ownerPuid!,
          forPreview: true,
        );

    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('预览失败: ${f.message}'))),
      (url) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MaterialPreviewPage(url: url, fileName: file.name),
          ),
        );
      },
    );
  }

  Future<void> _downloadFile(domain.Material file) async {
    if (file.objectId == null || file.ownerPuid == null) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('正在获取下载链接...')));

    final result = await AppDependencies.instance.getMaterialDownloadUrlUseCase
        .execute(
          objectId: file.objectId!,
          puid: widget.puid,
          sarepuid: file.ownerPuid!,
        );

    result.fold(
      (f) =>
          messenger.showSnackBar(SnackBar(content: Text('下载失败: ${f.message}'))),
      (url) async {
        await _performDownload(url, file.name);
      },
    );
  }

  Future<void> _performDownload(String url, String fileName) async {
    if (!mounted || _isDownloading) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      final dir = Directory('/storage/emulated/0/Download/xuexi');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final savePath = '${dir.path}/$fileName';

      final dio = AppDependencies.instance.dioClient.dio;
      await dio.download(
        url,
        savePath,
        options: Options(
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                '(KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36',
            'Referer': 'https://mooc1.chaoxing.com/',
          },
        ),
        onReceiveProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = 0.0;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('文件已保存到: $savePath')));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isDownloading = false;
          _downloadProgress = 0.0;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('下载失败: $e')));
      }
    }
  }

  String _formatSize(int? bytes) {
    if (bytes == null || bytes == 0) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _folderStack.isEmpty
            ? const Text('课程资料')
            : Row(
                children: [
                  if (_folderStack.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _goBack,
                    ),
                  Expanded(
                    child: Text(
                      _folderStack.map((e) => e.name).join(' / '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
      body: Stack(
        children: [
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(_error!),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: () => _loadMaterials(rootId: _currentRootId),
                        child: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : _items.isEmpty
              ? RefreshIndicator(
                  onRefresh: () => _loadMaterials(rootId: _currentRootId),
                  child: ListView(
                    children: const [
                      SizedBox(height: 200, child: Center(child: Text('暂无资料'))),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => _loadMaterials(rootId: _currentRootId),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _items.length,
                    itemBuilder: (_, i) {
                      final item = _items[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: ListTile(
                          leading: MaterialIcon(
                            suffix: item.suffix,
                            isFile: item.isFile,
                          ),
                          title: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: item.isFile
                              ? Text(_formatSize(item.size))
                              : null,
                          trailing: item.isFile
                              ? const Icon(Icons.more_vert, size: 18)
                              : const Icon(Icons.chevron_right, size: 18),
                          onTap: item.isFile
                              ? () => _showFileOptions(item)
                              : () => _enterFolder(item),
                        ),
                      );
                    },
                  ),
                ),
          if (_isDownloading)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Material(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          const Text('下载中'),
                          const Spacer(),
                          Text(
                            '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: _downloadProgress),
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

class _FolderStackEntry {
  final String rootId;
  final String name;

  _FolderStackEntry({required this.rootId, required this.name});
}

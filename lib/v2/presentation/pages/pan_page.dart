import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../infra/theme/theme_extensions.dart';
import '../controllers/pan_controller.dart';
import '../providers/providers.dart';
import '../../domain/entities/pan_file.dart';
import 'file_preview_page.dart';

const _kPanPageKey = 'pan_page';

class PanPage extends ConsumerStatefulWidget {
  const PanPage({super.key});
  @override
  ConsumerState<PanPage> createState() => _PanPageState();
}

class _PanPageState extends ConsumerState<PanPage>
    with SingleTickerProviderStateMixin {
  String _currentFolderId = '0';
  final List<String> _folderStack = ['0'];
  final List<String> _folderNames = ['根目录'];
  bool _isSearching = false;
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();
  String _searchValue = '';
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() {
      if (_tabCtrl.index == 1 && !_tabCtrl.indexIsChanging) {
        ref.invalidate(recycleBinProvider);
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  void _navigateToFolder(String fldid, String name) {
    setState(() {
      _folderStack.add(fldid);
      _folderNames.add(name);
      _currentFolderId = fldid;
      _searchValue = '';
      _searchCtrl.clear();
    });
    // 刷新新文件夹的数据
    ref.invalidate(panListControllerProvider(folderId: fldid));
  }

  void _goBack() {
    if (_folderStack.length <= 1) return;
    final previousFolderId = _folderStack[_folderStack.length - 2];
    setState(() {
      _folderStack.removeLast();
      _folderNames.removeLast();
      _currentFolderId = previousFolderId;
      _searchValue = '';
      _searchCtrl.clear();
    });
    // 刷新返回后的文件夹数据
    ref.invalidate(panListControllerProvider(folderId: previousFolderId));
  }

  bool _isFolder(PanFile file) => file.isFolder;

  bool _isImageFile(PanFile file) {
    if (file.isFolder) return false;
    final ext = _getFileExtension(file);
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'svg'].contains(ext);
  }

  bool _isPreviewable(PanFile file) {
    if (file.isFolder) return false;
    final ext = _getFileExtension(file);
    const previewable = [
      'pdf',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'txt',
      'md',
      'csv',
      'json',
      'xml',
      'html',
      'htm',
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'bmp',
      'svg',
      'mp4',
      'avi',
      'mov',
      'mkv',
      'mp3',
      'wav',
      'flac',
    ];
    return previewable.contains(ext);
  }

  String _getFileExtension(PanFile file) {
    if (file.fileType.isNotEmpty) return file.fileType.toLowerCase();
    return (file.fileName.contains('.') ? file.fileName.split('.').last : '')
        .toLowerCase();
  }

  Future<void> _uploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      if (file.path == null) return;

      final controller = ref.read(fileUploadControllerProvider.notifier);
      final ok = await controller.upload(File(file.path!), _currentFolderId);
      if (mounted) {
        _showSnack(ok ? '上传成功' : '上传失败');
        if (ok)
          ref.refresh(panListControllerProvider(folderId: _currentFolderId));
      }
    } catch (e) {
      if (mounted) _showSnack('上传失败: $e');
    }
  }

  Future<void> _downloadFile(PanFile file) async {
    if (!mounted) return;

    Directory downloadDir;
    final publicDownload = Directory('/storage/emulated/0/Download/xuexi');
    if (await _tryCreateDir(publicDownload)) {
      downloadDir = publicDownload;
    } else {
      final baseDir = await getApplicationDocumentsDirectory();
      downloadDir = Directory('${baseDir.path}/xuexi');
      await downloadDir.create(recursive: true);
    }

    final controller = ref.read(fileDownloadControllerProvider.notifier);
    final ok = await controller.download(file, downloadDir);
    if (mounted) {
      _showSnack(ok ? '下载成功: ${file.fileName}' : '下载失败');
    }
  }

  Future<bool> _tryCreateDir(Directory dir) async {
    try {
      await dir.create(recursive: true);
      return await dir.exists();
    } catch (e) {
      return false;
    }
  }

  void _previewFile(PanFile file) {
    final isImage = _isImageFile(file);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilePreviewPage(
          resid: file.fileId,
          fileName: file.fileName,
          encryptedId: file.encryptedId,
          isImage: isImage,
        ),
      ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes == 0) return '';
    final b = bytes.toDouble();
    if (b < 1024) return '${b.toInt()} B';
    if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(1)} KB';
    if (b < 1024 * 1024 * 1024)
      return '${(b / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(b / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDate(int ts) {
    if (ts == 0) return '';
    final dt = DateTime.fromMillisecondsSinceEpoch(ts);
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  IconData _fileIcon(PanFile file) {
    if (file.isFolder) return Icons.folder;
    final ext = _getFileExtension(file);
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'mkv':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
      case 'flac':
      case 'aac':
        return Icons.audio_file;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      case 'txt':
      case 'md':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen<int>(sessionVersionProvider, (previous, next) {
      if (previous != next) {
        debugPrint('云盘页面检测到账号变更，重置状态并刷新数据');
        setState(() {
          _currentFolderId = '0';
          _folderStack.clear();
          _folderStack.add('0');
          _folderNames.clear();
          _folderNames.add('根目录');
          _searchValue = '';
          _searchCtrl.clear();
        });
        ref.invalidate(panListControllerProvider(folderId: '0'));
        ref.invalidate(recycleBinProvider);
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchCtrl,
                focusNode: _searchFocus,
                decoration: const InputDecoration(
                  hintText: '搜索...',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
                style: const TextStyle(color: Colors.white),
                onSubmitted: (v) {
                  setState(() => _searchValue = v.trim());
                  ref.refresh(
                    panListControllerProvider(folderId: _currentFolderId),
                  );
                },
              )
            : Text(_folderNames.last),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                setState(() => _isSearching = false);
                _searchValue = '';
                _searchCtrl.clear();
                ref.refresh(
                  panListControllerProvider(folderId: _currentFolderId),
                );
              },
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => setState(() => _isSearching = true),
            ),
            IconButton(
              icon: const Icon(Icons.create_new_folder, color: Colors.white),
              tooltip: '新建文件夹',
              onPressed: _showCreateFolder,
            ),
            IconButton(
              icon: const Icon(Icons.upload_file, color: Colors.white),
              tooltip: '上传',
              onPressed: _uploadFile,
            ),
          ],
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(text: '我的云盘'),
            Tab(text: '回收站'),
          ],
        ),
      ),
      body: Container(
        decoration: _buildBackgroundDecoration(context),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + kToolbarHeight + 48,
          ),
          child: TabBarView(
            controller: _tabCtrl,
            children: [_buildCloudTab(theme), _buildRecycleTab(theme)],
          ),
        ),
      ),
    );
  }

  Decoration? _buildBackgroundDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final bgExt = theme.extension<ThemeBackgrounds>();
    final decoration = bgExt?.getBackgroundDecoration(_kPanPageKey);
    if (decoration != null) return decoration;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          theme.colorScheme.primary.withValues(alpha: 0.3),
          theme.colorScheme.surface,
        ],
      ),
    );
  }

  Widget _buildCloudTab(ThemeData theme) {
    final filesAsync = ref.watch(
      panListControllerProvider(folderId: _currentFolderId),
    );

    return Column(
      children: [
        if (_folderStack.length > 1)
          InkWell(
            onTap: _goBack,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '返回上级 (${_folderNames[_folderNames.length - 2]})',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        _buildUploadProgress(theme),
        _buildDownloadProgress(theme),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => ref.refresh(
              panListControllerProvider(folderId: _currentFolderId),
            ),
            child: filesAsync.when(
              data: (files) => files.isEmpty
                  ? Center(
                      child: Text(
                        _searchValue.isNotEmpty ? '未找到' : '暂无文件',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: files.length,
                      itemBuilder: (_, i) {
                        final file = files[i];
                        return _buildFileCard(file, theme);
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  '加载失败: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileCard(PanFile file, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: file.isFolder ? Colors.amber[700] : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _fileIcon(file),
            color: file.isFolder ? Colors.white : theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          file.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            if (!file.isFolder)
              Text(
                _formatSize(file.fileSize),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            if (!file.isFolder) const SizedBox(width: 8),
            Text(
              _formatDate(file.createTime),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, size: 18),
          onPressed: () => _showFileOptions(file),
        ),
        onTap: file.isFolder
            ? () => _navigateToFolder(file.fileId, file.fileName)
            : _isPreviewable(file)
            ? () => _previewFile(file)
            : () => _showFileOptions(file),
        onLongPress: () => _showFileOptions(file),
      ),
    );
  }

  Widget _buildUploadProgress(ThemeData theme) {
    final progress = ref.watch(fileUploadControllerProvider);
    if (progress < 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '上传中...',
            style: TextStyle(fontSize: 13, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: progress, minHeight: 4),
        ],
      ),
    );
  }

  Widget _buildDownloadProgress(ThemeData theme) {
    final progress = ref.watch(fileDownloadControllerProvider);
    if (progress < 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '下载中...',
            style: TextStyle(fontSize: 13, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: progress, minHeight: 4),
        ],
      ),
    );
  }

  Widget _buildRecycleTab(ThemeData theme) {
    final recycleAsync = ref.watch(recycleBinProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(recycleBinProvider),
      child: recycleAsync.when(
        data: (files) => files.isEmpty
            ? const Center(
                child: Text(
                  '回收站为空',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: files.length,
                itemBuilder: (_, i) {
                  final file = files[i];
                  return _buildRecycleFileCard(file, theme);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('加载失败: $e', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget _buildRecycleFileCard(PanFile file, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_fileIcon(file), color: Colors.white, size: 20),
        ),
        title: Text(
          file.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatDate(file.createTime),
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.restore, size: 18),
              tooltip: '还原',
              onPressed: () => _restoreFile(file),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_forever,
                size: 18,
                color: Colors.red,
              ),
              tooltip: '彻底删除',
              onPressed: () => _permanentDelete(file),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _restoreFile(PanFile file) async {
    final panRepo = ref.read(panRepositoryProvider);
    final result = await panRepo.restoreFiles(file.fileId);
    if (mounted) {
      result.fold((failure) => _showSnack('还原失败'), (success) {
        if (success) {
          _showSnack('还原成功');
          ref.invalidate(recycleBinProvider);
          ref.refresh(panListControllerProvider(folderId: _currentFolderId));
        } else {
          _showSnack('还原失败');
        }
      });
    }
  }

  Future<void> _permanentDelete(PanFile file) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认彻底删除'),
        content: Text('确定要永久删除 "${file.fileName}" 吗？此操作不可恢复！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final panRepo = ref.read(panRepositoryProvider);
    final result = await panRepo.deleteRecycleFiles(file.fileId);
    if (mounted) {
      result.fold((failure) => _showSnack('删除失败'), (success) {
        if (success) {
          _showSnack('已彻底删除');
          ref.invalidate(recycleBinProvider);
        } else {
          _showSnack('删除失败');
        }
      });
    }
  }

  void _showCreateFolder() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('新建文件夹'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: '文件夹名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(ctx);
              final controller = ref.read(
                panListControllerProvider(folderId: _currentFolderId).notifier,
              );
              final ok = await controller.createFolder(name);
              if (mounted) _showSnack(ok ? '创建成功' : '创建失败');
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  void _showFileOptions(PanFile file) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                file.fileName,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('详情'),
              onTap: () {
                Navigator.pop(ctx);
                _showDetail(file);
              },
            ),
            if (!file.isFolder)
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('下载'),
                onTap: () {
                  Navigator.pop(ctx);
                  _downloadFile(file);
                },
              ),
            if (!file.isFolder)
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('分享'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showShareDialog(file);
                },
              ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('重命名'),
              onTap: () {
                Navigator.pop(ctx);
                _showRename(file);
              },
            ),
            ListTile(
              leading: Icon(
                file.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
              ),
              title: Text(file.isPinned ? '取消置顶' : '置顶'),
              onTap: () {
                Navigator.pop(ctx);
                _togglePin(file);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('删除', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _deleteFile(file);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _togglePin(PanFile file) async {
    final controller = ref.read(
      panListControllerProvider(folderId: _currentFolderId).notifier,
    );
    final data = await controller.togglePin(
      file.fileId,
      _currentFolderId,
      file.isPinned,
    );

    if (mounted) {
      if (data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(file.isPinned ? '已取消置顶' : '已置顶')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('操作失败')));
      }
    }
  }

  void _showShareDialog(PanFile file) {
    String shareType = 'public';
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('分享: ${file.fileName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('公开链接 - 任何人可访问'),
                value: 'public',
                groupValue: shareType,
                onChanged: (v) => setDialogState(() => shareType = v!),
                contentPadding: EdgeInsets.zero,
              ),
              RadioListTile<String>(
                title: const Text('加密链接 - 需要密码访问'),
                value: 'password',
                groupValue: shareType,
                onChanged: (v) => setDialogState(() => shareType = v!),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final controller = ref.read(
                  panListControllerProvider(
                    folderId: _currentFolderId,
                  ).notifier,
                );
                final data = await controller.shareFile(
                  resids: file.fileId,
                  encryptedId: file.encryptedId,
                  shareType: shareType,
                );
                if (mounted) {
                  if (data != null && data['success'] == true) {
                    final weburl = data['data']?['weburl'] ?? '';
                    final password = data['data']?['password'] ?? '';
                    if (weburl.isNotEmpty) {
                      _showShareResultDialog(weburl, password);
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('分享链接已生成')));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('分享失败: ${data?['msg']}')),
                    );
                  }
                }
              },
              child: const Text('创建分享'),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareResultDialog(String weburl, String password) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('分享成功'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '分享链接:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SelectableText(weburl, style: const TextStyle(fontSize: 14)),
            if (password.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                '提取密码:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SelectableText(
                password,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('关闭'),
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              // 复制链接到剪贴板
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('链接已复制')));
            },
          ),
        ],
      ),
    );
  }

  void _showDetail(PanFile file) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('文件详情'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('名称', file.fileName),
            if (!file.isFolder) _buildInfoRow('大小', _formatSize(file.fileSize)),
            if (file.fileType.isNotEmpty) _buildInfoRow('类型', file.fileType),
            _buildInfoRow('上传时间', _formatDate(file.createTime)),
            _buildInfoRow('类型', file.isFolder ? '文件夹' : '文件'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  void _showRename(PanFile file) {
    final ctrl = TextEditingController(text: file.fileName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('重命名'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '新名称',
            hintText: '请输入新名称',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              final newName = ctrl.text.trim();
              if (newName.isEmpty || newName == file.fileName) {
                Navigator.pop(ctx);
                return;
              }
              Navigator.pop(ctx);
              final controller = ref.read(
                panListControllerProvider(folderId: _currentFolderId).notifier,
              );
              final ok = await controller.renameFile(
                file.fileId,
                newName,
                file.encryptedId,
              );
              if (mounted) _showSnack(ok ? '重命名成功' : '重命名失败');
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFile(PanFile file) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定将 "${file.fileName}" 移到回收站吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    final controller = ref.read(
      panListControllerProvider(folderId: _currentFolderId).notifier,
    );
    final success = await controller.deleteFile(file.fileId, file.encryptedId);
    if (mounted) _showSnack(success ? '已移到回收站' : '删除失败');
  }

  void _showSnack(String msg) {
    if (mounted)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

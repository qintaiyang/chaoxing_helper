import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../utils/image_picker_helper.dart';
import '../../infra/theme/theme_data.dart';

class ThemeSettingsPage extends ConsumerWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentTheme = ref.watch(themeProvider);
    final themes = ref.read(themeProvider.notifier).getAvailableThemes();

    return Scaffold(
      appBar: AppBar(title: const Text('主题设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '选择主题',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...themes.map(
            (t) => _buildThemeCard(context, ref, t, currentTheme),
          ),
          const SizedBox(height: 24),
          Text(
            '自定义页面背景',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '支持渐变、纯色、图片背景',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          _buildCustomBgSection(context, ref, '云盘页面', 'pan_page'),
          _buildCustomBgSection(context, ref, '账号页面', 'accounts_page'),
          _buildCustomBgSection(context, ref, '课程详情', 'course_detail'),
        ],
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context,
    WidgetRef ref,
    AppThemeData theme,
    AppThemeData currentTheme,
  ) {
    final isSelected = theme.id == currentTheme.id;
    final gradient = _getThemeGradient(theme);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          ref.read(themeProvider.notifier).setTheme(theme.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('已切换到 ${theme.name}')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (theme.description != null)
                      Text(
                        theme.description!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _getThemeGradient(AppThemeData theme) {
    switch (theme.id) {
      case 'blue_gradient':
        return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        );
      case 'purple_gradient':
        return const LinearGradient(
          colors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
        );
      case 'green_gradient':
        return const LinearGradient(
          colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
        );
      case 'sunset_gradient':
        return const LinearGradient(
          colors: [Color(0xFFfa709a), Color(0xFFfee140)],
        );
      case 'ocean_gradient':
        return const LinearGradient(
          colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
        );
      case 'pink_gradient':
        return const LinearGradient(
          colors: [Color(0xFFee9ca7), Color(0xFFffdde1)],
        );
      case 'dark':
        return const LinearGradient(
          colors: [Color(0xFF232526), Color(0xFF414345)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
        );
    }
  }

  Widget _buildCustomBgSection(
    BuildContext context,
    WidgetRef ref,
    String label,
    String pageKey,
  ) {
    final currentConfig = ref
        .read(themeProvider.notifier)
        .customBackgrounds[pageKey];
    final currentType = currentConfig?['type'] as String?;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(child: Text(label)),
            if (currentType != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _typeLabel(currentType),
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildGradientOption(
                  context,
                  ref,
                  pageKey,
                  '蓝色渐变',
                  const [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                _buildGradientOption(
                  context,
                  ref,
                  pageKey,
                  '紫色渐变',
                  const [Color(0xFFa8edea), Color(0xFFfed6e3)],
                ),
                _buildGradientOption(
                  context,
                  ref,
                  pageKey,
                  '绿色渐变',
                  const [Color(0xFF11998e), Color(0xFF38ef7d)],
                ),
                _buildGradientOption(
                  context,
                  ref,
                  pageKey,
                  '日落渐变',
                  const [Color(0xFFfa709a), Color(0xFFfee140)],
                ),
                const Divider(),
                _buildCustomColorOption(context, ref, pageKey),
                _buildImageBackgroundOption(context, ref, pageKey),
                const Divider(),
                _buildClearOption(context, ref, pageKey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'gradient':
        return '渐变';
      case 'solid':
        return '纯色';
      case 'custom_color':
        return '自定义色';
      case 'image':
        return '图片';
      default:
        return type;
    }
  }

  Widget _buildGradientOption(
    BuildContext context,
    WidgetRef ref,
    String pageKey,
    String label,
    List<Color> colors,
  ) {
    return ListTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      title: Text(label),
      onTap: () {
        ref.read(themeProvider.notifier).setCustomBackground(pageKey, {
          'type': 'gradient',
          'colors': colors
              .map((c) => '#${c.toARGB32().toRadixString(16).substring(2)}')
              .toList(),
          'begin': [-1.0, 0.0],
          'end': [1.0, 0.0],
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已设置 $label 背景')),
        );
      },
    );
  }

  Widget _buildCustomColorOption(
    BuildContext context,
    WidgetRef ref,
    String pageKey,
  ) {
    return ListTile(
      leading: const Icon(Icons.color_lens),
      title: const Text('自定义颜色'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showColorPicker(context, ref, pageKey),
    );
  }

  void _showColorPicker(BuildContext context, WidgetRef ref, String pageKey) {
    Color pickerColor = Colors.blue;
    final notifier = ref.read(themeProvider.notifier);
    final existing = notifier.customBackgrounds[pageKey];
    if (existing != null && existing['type'] == 'custom_color') {
      final colorStr = existing['color'] as String;
      pickerColor = _parseColor(colorStr);
    }

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('选择背景颜色'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                pickerColor = color;
                setDialogState(() {});
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () {
                notifier.setCustomColorBackground(pageKey, pickerColor);
                Navigator.pop(dialogCtx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已设置自定义颜色背景')),
                );
              },
              child: const Text('确定'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageBackgroundOption(
    BuildContext context,
    WidgetRef ref,
    String pageKey,
  ) {
    return ListTile(
      leading: const Icon(Icons.image),
      title: const Text('图片背景'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showImagePicker(context, ref, pageKey),
    );
  }

  void _showImagePicker(BuildContext context, WidgetRef ref, String pageKey) {
    final notifier = ref.read(themeProvider.notifier);
    showDialog(
      context: context,
      builder: (dialogCtx) => _ImageBackgroundConfigDialog(
        pageKey: pageKey,
        onApply: (imagePath, opacity, fit, alignment) {
          notifier.setImageBackground(
            pageKey,
            imagePath,
            opacity: opacity,
            fit: fit,
            alignment: alignment,
          );
        },
      ),
    );
  }

  Color _parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  Widget _buildClearOption(
    BuildContext context,
    WidgetRef ref,
    String pageKey,
  ) {
    return ListTile(
      leading: const Icon(Icons.clear, color: Colors.red),
      title: const Text('恢复默认', style: TextStyle(color: Colors.red)),
      onTap: () {
        ref.read(themeProvider.notifier).clearCustomBackground(pageKey);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已恢复默认背景')),
        );
      },
    );
  }
}

class _ImageBackgroundConfigDialog extends StatefulWidget {
  final String pageKey;
  final Function(
    String imagePath,
    double opacity,
    String fit,
    String alignment,
  ) onApply;
  const _ImageBackgroundConfigDialog({
    required this.pageKey,
    required this.onApply,
  });

  @override
  State<_ImageBackgroundConfigDialog> createState() =>
      _ImageBackgroundConfigDialogState();
}

class _ImageBackgroundConfigDialogState
    extends State<_ImageBackgroundConfigDialog> {
  String? _selectedImagePath;
  double _opacity = 1.0;
  String _fit = 'cover';
  String _alignment = 'center';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('设置图片背景'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: FilledButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('从相册选择'),
              ),
            ),
            if (_selectedImagePath != null) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_selectedImagePath!),
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '透明度',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Row(
                children: [
                  const Icon(Icons.opacity, size: 18),
                  Expanded(
                    child: Slider(
                      value: _opacity,
                      min: 0.3,
                      max: 1.0,
                      divisions: 7,
                      label: '${(_opacity * 100).round()}%',
                      onChanged: (v) => setState(() => _opacity = v),
                    ),
                  ),
                  Text('${(_opacity * 100).round()}%'),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '裁剪方式',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              DropdownButtonFormField<String>(
                value: _fit,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'cover',
                    child: Text('Cover - 裁剪填满'),
                  ),
                  DropdownMenuItem(
                    value: 'contain',
                    child: Text('Contain - 完整显示'),
                  ),
                  DropdownMenuItem(
                    value: 'fill',
                    child: Text('Fill - 拉伸填充'),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _fit = v);
                },
              ),
              const SizedBox(height: 16),
              Text(
                '对齐方式',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              DropdownButtonFormField<String>(
                value: _alignment,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'topLeft',
                    child: Text('左上'),
                  ),
                  DropdownMenuItem(
                    value: 'topCenter',
                    child: Text('上中'),
                  ),
                  DropdownMenuItem(
                    value: 'topRight',
                    child: Text('右上'),
                  ),
                  DropdownMenuItem(
                    value: 'centerLeft',
                    child: Text('左中'),
                  ),
                  DropdownMenuItem(
                    value: 'center',
                    child: Text('居中'),
                  ),
                  DropdownMenuItem(
                    value: 'centerRight',
                    child: Text('右中'),
                  ),
                  DropdownMenuItem(
                    value: 'bottomLeft',
                    child: Text('左下'),
                  ),
                  DropdownMenuItem(
                    value: 'bottomCenter',
                    child: Text('下中'),
                  ),
                  DropdownMenuItem(
                    value: 'bottomRight',
                    child: Text('右下'),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _alignment = v);
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _selectedImagePath != null ? _apply : null,
          child: const Text('应用'),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final path = await ImagePickerHelper.pickAndSaveImage();
    if (path != null && mounted) {
      setState(() => _selectedImagePath = path);
    }
  }

  void _apply() {
    if (_selectedImagePath == null) return;
    widget.onApply(
      _selectedImagePath!,
      _opacity,
      _fit,
      _alignment,
    );
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已设置图片背景')),
      );
    }
  }
}

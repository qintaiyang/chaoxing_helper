import 'package:flutter/material.dart';

class MaterialIcon extends StatelessWidget {
  final String? suffix;
  final bool isFile;
  final double size;

  const MaterialIcon({
    super.key,
    this.suffix,
    this.isFile = true,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    if (!isFile) {
      return Icon(Icons.folder, color: Colors.amber.shade700, size: size);
    }

    final color = _colorForSuffix(suffix);
    final icon = _iconForSuffix(suffix);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: color, size: size * 0.75),
    );
  }

  Color _colorForSuffix(String? suffix) {
    switch (suffix?.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Colors.purple;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Colors.teal;
      case 'mp3':
      case 'wav':
        return Colors.pink;
      case 'zip':
      case 'rar':
      case '7z':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  IconData _iconForSuffix(String? suffix) {
    switch (suffix?.toLowerCase()) {
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
        return Icons.video_library;
      case 'mp3':
      case 'wav':
        return Icons.audio_file;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }
}

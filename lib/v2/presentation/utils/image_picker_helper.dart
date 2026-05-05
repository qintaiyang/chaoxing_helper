import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ImagePickerHelper {
  static final _picker = ImagePicker();

  static Future<String?> pickAndSaveImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (picked == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final bgDir = Directory('${appDir.path}/backgrounds');
    if (!await bgDir.exists()) {
      await bgDir.create(recursive: true);
    }

    final ext = picked.path.split('.').last;
    final fileName = 'bg_${const Uuid().v4().substring(0, 8)}.$ext';
    final targetPath = '${bgDir.path}/$fileName';

    await File(picked.path).copy(targetPath);
    return targetPath;
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class IconSplashLocalDataSource {
  static const _platform = MethodChannel('com.chaoxinghelper/icon_manager');
  static final _picker = ImagePicker();

  Future<String?> pickAndProcessAppIcon() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 100,
      );
      if (picked == null) return null;

      final appDir = await getApplicationDocumentsDirectory();
      final iconDir = Directory('${appDir.path}/custom_icon_source');
      if (!await iconDir.exists()) {
        await iconDir.create(recursive: true);
      }

      final fileName = 'icon_${const Uuid().v4().substring(0, 8)}.png';
      final targetPath = '${iconDir.path}/$fileName';

      final bytes = await File(picked.path).readAsBytes();
      final decodedImage = img.decodeImage(bytes);

      if (decodedImage != null) {
        final resized = img.copyResize(decodedImage, width: 1024, height: 1024);
        final pngBytes = img.encodePng(resized);
        await File(targetPath).writeAsBytes(pngBytes);
      } else {
        await File(picked.path).copy(targetPath);
      }

      return targetPath;
    } catch (e) {
      debugPrint('IconSplashLocalDataSource.pickAndProcessAppIcon error: $e');
      return null;
    }
  }

  Future<String?> pickAndProcessSplashImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 95,
      );
      if (picked == null) return null;

      final appDir = await getApplicationDocumentsDirectory();
      final splashDir = Directory('${appDir.path}/custom_splash');
      if (!await splashDir.exists()) {
        await splashDir.create(recursive: true);
      }

      final fileName = 'splash_${const Uuid().v4().substring(0, 8)}.png';
      final targetPath = '${splashDir.path}/$fileName';

      final bytes = await File(picked.path).readAsBytes();
      final decodedImage = img.decodeImage(bytes);

      if (decodedImage != null) {
        final resized = img.copyResize(decodedImage, width: 1080, height: 1920);
        final pngBytes = img.encodePng(resized);
        await File(targetPath).writeAsBytes(pngBytes);
      } else {
        await File(picked.path).copy(targetPath);
      }

      return targetPath;
    } catch (e) {
      debugPrint(
        'IconSplashLocalDataSource.pickAndProcessSplashImage error: $e',
      );
      return null;
    }
  }

  Future<bool> pinCustomIcon(String iconPath, String iconName) async {
    try {
      final result = await _platform.invokeMethod('pinCustomIcon', {
        'iconPath': iconPath,
        'iconName': iconName,
      });
      return result == true;
    } catch (e) {
      debugPrint('IconSplashLocalDataSource.pinCustomIcon error: $e');
      return false;
    }
  }

  Future<bool> restoreDefaultIcon() async {
    try {
      final result = await _platform.invokeMethod('restoreDefaultIcon');
      return result == true;
    } catch (e) {
      debugPrint('IconSplashLocalDataSource.restoreDefaultIcon error: $e');
      return false;
    }
  }

  Future<String> getCurrentIconType() async {
    try {
      final result = await _platform.invokeMethod('getCurrentIcon');
      return (result as String?) ?? 'default';
    } catch (e) {
      debugPrint('IconSplashLocalDataSource.getCurrentIconType error: $e');
      return 'default';
    }
  }

  Future<int> getCurrentIconIndex() async {
    final type = await getCurrentIconType();
    return type == 'custom' ? 1 : 0;
  }

  Future<bool> updateNativeSplashImage(String splashPath) async {
    try {
      final result = await _platform.invokeMethod('updateSplashImage', {
        'splashPath': splashPath,
      });
      return result == true;
    } catch (e) {
      debugPrint('IconSplashLocalDataSource.updateNativeSplashImage error: $e');
      return false;
    }
  }

  Future<bool> iconExists(String iconPath) async {
    return await File(iconPath).exists();
  }

  Future<bool> splashExists(String splashPath) async {
    return await File(splashPath).exists();
  }
}

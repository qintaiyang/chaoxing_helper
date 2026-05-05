import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app_dependencies.dart';
import '../../controllers/sign_in_controller.dart';
import '../../../domain/entities/user.dart';

class NormalSignArea extends ConsumerStatefulWidget {
  final SignInController controller;
  final String courseId;
  final String activeId;
  final String classId;
  final String cpi;
  final bool needPhoto;
  final List<User> selectedAccounts;
  final Map<String, String> userObjectIds;

  const NormalSignArea({
    super.key,
    required this.controller,
    required this.courseId,
    required this.activeId,
    required this.classId,
    required this.cpi,
    this.needPhoto = false,
    this.selectedAccounts = const [],
    this.userObjectIds = const {},
  });

  @override
  ConsumerState<NormalSignArea> createState() => _NormalSignAreaState();
}

class _NormalSignAreaState extends ConsumerState<NormalSignArea> {
  Future<void> _takeBatchPhoto(ImageSource source) async {
    final selectedAccounts = widget.selectedAccounts;

    if (selectedAccounts.isEmpty) return;

    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('需要相机权限才能拍照')));
        }
        return;
      }
    } else {
      final status = await Permission.photos.request();
      if (status != PermissionStatus.granted) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('需要相册权限')));
        }
        return;
      }
    }

    final picker = ImagePicker();
    List<XFile> pickedFiles = [];

    final userObjectIds = ref.read(signInControllerProvider).userObjectIds;
    final startIndex = userObjectIds.length;
    final neededCount = selectedAccounts.length;

    try {
      if (source == ImageSource.gallery) {
        final photoCount = neededCount - startIndex;
        if (photoCount <= 1) {
          final pickedFile = await picker.pickImage(
            source: ImageSource.gallery,
          );
          if (pickedFile != null) {
            pickedFiles = [pickedFile];
          }
        } else {
          pickedFiles = await picker.pickMultiImage(limit: photoCount);
        }
      } else {
        final pickedFile = await picker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
          pickedFiles = [pickedFile];
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('选择图片错误：$e')));
      }
      return;
    }

    if (pickedFiles.isEmpty) return;

    final int remainingCount = neededCount - startIndex;
    if (pickedFiles.length > remainingCount) {
      pickedFiles = pickedFiles.sublist(0, remainingCount);
    }

    for (int i = 0; i < pickedFiles.length; i++) {
      final int index = startIndex + i;
      if (index >= selectedAccounts.length) break;

      final user = selectedAccounts[index];
      final pickedFile = pickedFiles[i];

      widget.controller.setUserObjectId(user.uid, '');

      try {
        final objectId = await AppDependencies.instance.cxUploadApi.uploadImage(
          File(pickedFile.path),
          user.uid,
        );

        if (objectId != null) {
          widget.controller.setUserObjectId(user.uid, objectId);
        } else {
          widget.controller.setUserObjectId(user.uid, '');
        }
      } catch (e) {
        widget.controller.setUserObjectId(user.uid, '');
      }
    }
  }

  void _performSign() {
    final state = ref.read(signInControllerProvider);

    if (state.needPhoto) {
      final allPhotoTaken = state.selectedAccounts.every((user) {
        final objectId = state.userObjectIds[user.uid];
        return objectId != null && objectId.isNotEmpty;
      });

      if (!allPhotoTaken) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '请为所有账号上传照片（已上传 ${state.userObjectIds.length}/${state.selectedAccounts.length}）',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        return;
      }
    }

    widget.controller.performMultiSign(
      courseId: widget.courseId,
      activeId: widget.activeId,
      classId: widget.classId,
      cpi: widget.cpi,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);
    final needPhoto = state.needPhoto;
    final selectedAccounts = state.selectedAccounts;
    final userObjectIds = state.userObjectIds;

    final allPhotoTaken = selectedAccounts.every((user) {
      final objectId = userObjectIds[user.uid];
      return objectId != null && objectId.isNotEmpty;
    });
    final canSign =
        selectedAccounts.isNotEmpty && (!needPhoto || allPhotoTaken);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (needPhoto) ...[
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: selectedAccounts.isEmpty || allPhotoTaken
                          ? null
                          : () => _takeBatchPhoto(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('拍照'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 32),
                    ElevatedButton.icon(
                      onPressed: selectedAccounts.isEmpty || allPhotoTaken
                          ? null
                          : () => _takeBatchPhoto(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('相册'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSign ? _performSign : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  '立即签到',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

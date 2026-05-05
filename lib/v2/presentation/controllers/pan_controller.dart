import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/pan_file.dart';
import '../providers/providers.dart';

part 'pan_controller.g.dart';

@riverpod
class PanListController extends _$PanListController {
  @override
  Future<List<PanFile>> build({String folderId = '0'}) async {
    final useCase = ref.read(getCloudFilesUseCaseProvider);
    final result = await useCase.execute(fldid: folderId);
    return result.fold((failure) => throw failure, (files) => files);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<bool> createFolder(String name) async {
    final useCase = ref.read(createCloudFolderUseCaseProvider);
    final result = await useCase.execute(name: name, fldid: folderId);
    return result.fold((failure) => false, (_) {
      refresh();
      return true;
    });
  }

  Future<bool> deleteFile(String resids, String encryptedId) async {
    final useCase = ref.read(deleteCloudFileUseCaseProvider);
    final result = await useCase.execute(
      resids: resids,
      encryptedId: encryptedId,
    );
    return result.fold((failure) => false, (success) {
      if (success) refresh();
      return success;
    });
  }

  Future<bool> renameFile(
    String resids,
    String name,
    String encryptedId,
  ) async {
    final useCase = ref.read(renameCloudFileUseCaseProvider);
    final result = await useCase.execute(
      resids: resids,
      name: name,
      encryptedId: encryptedId,
    );
    return result.fold((failure) => false, (success) {
      if (success) refresh();
      return success;
    });
  }

  Future<Map<String, dynamic>?> togglePin(
    String resid,
    String parentId,
    bool isPinned,
  ) async {
    final useCase = ref.read(togglePinUseCaseProvider);
    final result = await useCase.execute(
      resid: resid,
      parentId: parentId,
      isPinned: isPinned,
    );
    return result.fold((failure) => null, (data) {
      if (data['success'] == true) {
        refresh();
      }
      return data;
    });
  }

  Future<Map<String, dynamic>?> shareFile({
    required String resids,
    required String encryptedId,
    String shareType = 'public',
    String? password,
  }) async {
    final useCase = ref.read(shareCloudFileUseCaseProvider);
    final result = await useCase.execute(
      resids: resids,
      encryptedId: encryptedId,
      shareType: shareType,
      password: password,
    );
    return result.fold((failure) => null, (data) => data);
  }
}

@riverpod
class FileUploadController extends _$FileUploadController {
  @override
  double build() => -1.0;

  Future<bool> upload(File file, String folderId) async {
    final useCase = ref.read(uploadFileUseCaseProvider);
    final result = await useCase.execute(
      file: file,
      folderId: folderId,
      onProgress: (sent, total) {
        state = sent / total;
      },
    );
    return result.fold(
      (failure) {
        state = -1.0;
        return false;
      },
      (_) {
        state = -1.0;
        return true;
      },
    );
  }
}

@riverpod
class FileDownloadController extends _$FileDownloadController {
  @override
  double build() => -1.0;

  Future<bool> download(PanFile file, Directory saveDir) async {
    final useCase = ref.read(downloadFileUseCaseProvider);
    final result = await useCase.execute(
      file: file,
      saveDir: saveDir,
      onProgress: (received, total) {
        state = received / total;
      },
    );
    return result.fold(
      (failure) {
        state = -1.0;
        return false;
      },
      (_) {
        state = -1.0;
        return true;
      },
    );
  }
}

@riverpod
Future<List<PanFile>> recycleBin(RecycleBinRef ref) async {
  final panRepo = ref.read(panRepositoryProvider);
  final result = await panRepo.getRecycleBin();
  return result.fold((failure) => throw failure, (files) => files);
}

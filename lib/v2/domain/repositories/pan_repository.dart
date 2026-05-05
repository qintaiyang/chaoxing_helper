import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../entities/pan_file.dart';
import '../failures/failure.dart';

abstract class PanRepository {
  Future<Either<Failure, List<PanFile>>> getMyCloudFiles({
    String fldid,
    int page,
    int size,
    String filterType,
    String orderField,
    String orderType,
    String searchValue,
  });
  Future<Either<Failure, Map<String, dynamic>>> getCloudDownloadUrl({
    required String fleid,
    required String encryptedId,
    String currentFolderId,
  });
  Future<Either<Failure, Map<String, dynamic>>> getCloudUploadUrl({
    String fldid,
  });
  Future<Either<Failure, Map<String, dynamic>>> createCloudFolder({
    required String name,
    String fldid,
    String visibility,
  });
  Future<Either<Failure, bool>> deleteCloudFiles({
    required String resids,
    required String encryptedId,
  });
  Future<Either<Failure, bool>> renameCloudFile({
    required String resids,
    required String name,
    required String encryptedId,
  });
  Future<Either<Failure, File>> downloadFile({
    required PanFile file,
    required Directory saveDir,
    void Function(int, int)? onProgress,
  });
  Future<Either<Failure, PanFile>> uploadFile({
    required File file,
    required String folderId,
    void Function(int, int)? onProgress,
  });
  Future<Either<Failure, List<PanFile>>> getRecycleBin();
  Future<Either<Failure, bool>> restoreFiles(String resids);
  Future<Either<Failure, bool>> deleteRecycleFiles(String resids);
  Future<Either<Failure, Map<String, dynamic>>> setupTop({
    required String resid,
    required String parentId,
  });
  Future<Either<Failure, Map<String, dynamic>>> cancelTop({
    required String resid,
    required String parentId,
  });
  Future<Either<Failure, Map<String, dynamic>>> getCloudFileInfo({
    required String fleids,
  });
  Future<Either<Failure, Map<String, dynamic>>> shareCloudFile({
    required String resids,
    required String encryptedId,
    String shareType,
    String? password,
  });
  Future<Either<Failure, String?>> getImagePreviewUrl({required String resid});
  void clearCache();
}

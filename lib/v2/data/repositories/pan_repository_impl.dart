import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/pan_file.dart';
import '../../domain/repositories/pan_repository.dart';
import '../../domain/failures/failure.dart';
import '../datasources/remote/chaoxing/cx_pan_api.dart';
import '../mappers/pan_file_mapper.dart';
import '../models/pan_file_dto.dart';
import '../../app_dependencies.dart';

class PanRepositoryImpl implements PanRepository {
  final CXPanApi _cxApi;

  PanRepositoryImpl(this._cxApi);

  @override
  Future<Either<Failure, List<PanFile>>> getMyCloudFiles({
    String fldid = '0',
    int page = 1,
    int size = 20,
    String filterType = '',
    String orderField = 'default',
    String orderType = 'desc',
    String searchValue = '',
  }) async {
    try {
      final dtos = await _cxApi.getMyCloudFiles(
        fldid: fldid,
        page: page,
        size: size,
        filterType: filterType,
        orderField: orderField,
        orderType: orderType,
        searchValue: searchValue,
      );
      return Right(PanFileMapper.toEntityList(dtos));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCloudDownloadUrl({
    required String fleid,
    required String encryptedId,
    String currentFolderId = '0',
  }) async {
    try {
      final result = await _cxApi.getCloudDownloadUrl(
        fleid: fleid,
        encryptedId: encryptedId,
        currentFolderId: currentFolderId,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取下载链接失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCloudUploadUrl({
    String fldid = '0',
  }) async {
    try {
      final result = await _cxApi.getCloudUploadUrl(fldid: fldid);
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取上传链接失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createCloudFolder({
    required String name,
    String fldid = '0',
    String visibility = 'onlyme',
  }) async {
    try {
      final result = await _cxApi.createCloudFolder(
        name: name,
        fldid: fldid,
        visibility: visibility,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '创建文件夹失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteCloudFiles({
    required String resids,
    required String encryptedId,
  }) async {
    try {
      final result = await _cxApi.deleteCloudFiles(
        resids: resids,
        encryptedId: encryptedId,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '删除文件失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, bool>> renameCloudFile({
    required String resids,
    required String name,
    required String encryptedId,
  }) async {
    try {
      final result = await _cxApi.renameCloudFile(
        resids: resids,
        name: name,
        encryptedId: encryptedId,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '重命名文件失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  void clearCache() {
    _cxApi.clearCache();
  }

  @override
  Future<Either<Failure, File>> downloadFile({
    required PanFile file,
    required Directory saveDir,
    void Function(int, int)? onProgress,
  }) async {
    try {
      final urlResult = await _cxApi.getCloudDownloadUrl(
        fleid: file.fileId,
        encryptedId: file.encryptedId,
        currentFolderId: file.parentId,
      );
      final downloadUrl = urlResult?['downloadUrl'] as String?;
      if (downloadUrl == null || downloadUrl.isEmpty) {
        return const Left(Failure.business(message: '获取下载链接失败'));
      }
      debugPrint('下载URL: $downloadUrl');

      final saveFile = File('${saveDir.path}/${file.fileName}');
      debugPrint('保存路径: ${saveFile.path}');

      // 使用AppDioClient的Dio实例，确保携带cookie
      final dio = AppDependencies.instance.dioClient.dio;
      await dio.download(
        downloadUrl,
        saveFile.path,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            onProgress?.call(received, total);
          }
        },
        options: Options(
          followRedirects: true,
          maxRedirects: 5,
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

      if (await saveFile.exists()) {
        debugPrint('下载成功: ${file.fileName}');
        return Right(saveFile);
      } else {
        return const Left(Failure.business(message: '下载文件不存在'));
      }
    } catch (e) {
      debugPrint('下载失败: $e');
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, PanFile>> uploadFile({
    required File file,
    required String folderId,
    void Function(int, int)? onProgress,
  }) async {
    try {
      final uploadResult = await _cxApi.uploadFileToCloud(
        filePath: file.path,
        fldid: folderId,
        onProgress: (progress) {
          // 模拟进度回调
          if (onProgress != null) {
            onProgress((progress * 100).toInt(), 100);
          }
        },
      );

      if (uploadResult == null) {
        return const Left(Failure.business(message: '获取上传链接失败'));
      }

      final isSuccess =
          uploadResult['result'] == true ||
          uploadResult['result'] == 'true' ||
          uploadResult['success'] == true ||
          uploadResult['success'] == 'true' ||
          uploadResult['msg']?.toString().contains('成功') == true;

      if (isSuccess) {
        return Right(
          PanFile(
            fileId: uploadResult['objectId']?.toString() ?? '',
            fileName:
                uploadResult['name']?.toString() ??
                file.path.split(Platform.pathSeparator).last,
            fileType: uploadResult['fileType']?.toString() ?? '',
            fileSize:
                int.tryParse(uploadResult['size']?.toString() ?? '0') ?? 0,
            encryptedId: uploadResult['encryptedId']?.toString() ?? '',
            parentId: folderId,
            isFolder: false,
          ),
        );
      } else {
        final errorMsg = uploadResult['msg']?.toString() ?? '上传失败';
        return Left(Failure.business(message: errorMsg));
      }
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, List<PanFile>>> getRecycleBin() async {
    try {
      final result = await _cxApi.getCloudRecyclebin();
      if (result == null) {
        return const Left(Failure.business(message: '获取回收站失败'));
      }
      final list = result['data'] ?? result['list'];
      if (list is List) {
        final dtos = list
            .whereType<Map<String, dynamic>>()
            .map((json) => PanFileDto.fromJson(json))
            .toList();
        return Right(PanFileMapper.toEntityList(dtos));
      }
      return const Right([]);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, bool>> restoreFiles(String resids) async {
    try {
      final result = await _cxApi.restoreCloudFiles(resids: resids);
      return Right(result == true);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteRecycleFiles(String resids) async {
    try {
      final result = await _cxApi.deleteRecycleFiles(resids: resids);
      return Right(result == true);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> setupTop({
    required String resid,
    required String parentId,
  }) async {
    try {
      final result = await _cxApi.setupTop(resid: resid, parentId: parentId);
      if (result == null) {
        return const Left(Failure.business(message: '置顶失败'));
      }
      return Right(result);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> cancelTop({
    required String resid,
    required String parentId,
  }) async {
    try {
      final result = await _cxApi.cancelTop(resid: resid, parentId: parentId);
      if (result == null) {
        return const Left(Failure.business(message: '取消置顶失败'));
      }
      return Right(result);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCloudFileInfo({
    required String fleids,
  }) async {
    try {
      final result = await _cxApi.getCloudFileInfo(fleids: fleids);
      if (result == null) {
        return const Left(Failure.business(message: '获取文件信息失败'));
      }
      return Right(result);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> shareCloudFile({
    required String resids,
    required String encryptedId,
    String shareType = 'public',
    String? password,
  }) async {
    try {
      final result = await _cxApi.shareCloudFile(
        resids: resids,
        encryptedId: encryptedId,
        shareType: shareType,
        password: password,
      );
      if (result == null) {
        return const Left(Failure.business(message: '分享文件失败'));
      }
      return Right(result);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, String?>> getImagePreviewUrl({
    required String resid,
  }) async {
    try {
      final result = await CXPanApi.getImagePreviewUrl(resid: resid);
      return Right(result);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }
}

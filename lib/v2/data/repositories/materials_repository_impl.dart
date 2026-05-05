import 'package:fpdart/fpdart.dart';
import '../../domain/entities/material.dart';
import '../../domain/repositories/materials_repository.dart';
import '../../domain/failures/failure.dart';
import '../datasources/remote/chaoxing/cx_materials_api.dart';
import '../mappers/material_mapper.dart';

class MaterialsRepositoryImpl implements MaterialsRepository {
  final CXMaterialsApi _cxApi;

  MaterialsRepositoryImpl(this._cxApi);

  @override
  Future<Either<Failure, List<Material>>> getCourseMaterials({
    required String courseId,
    required String classId,
    required String cpi,
    String? rootId,
    int pageNum = 1,
  }) async {
    try {
      final dtos = await _cxApi.getCourseMaterials(
        courseId: courseId,
        classId: classId,
        cpi: cpi,
        rootId: rootId,
        pageNum: pageNum,
      );
      return Right(MaterialMapper.toEntityList(dtos));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, String>> getMaterialPreviewUrl({
    required String objectId,
    required int puid,
    required int sarepuid,
  }) async {
    try {
      final result = await _cxApi.getMaterialPreviewUrl(
        objectId: objectId,
        puid: puid,
        sarepuid: sarepuid,
      );
      if (result != null && result.isNotEmpty) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取预览URL失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, String>> getMaterialDownloadUrl({
    required String objectId,
    required int puid,
    required int sarepuid,
  }) async {
    try {
      final result = await _cxApi.getMaterialDownloadUrl(
        objectId: objectId,
        puid: puid,
        sarepuid: sarepuid,
      );
      if (result != null && result.isNotEmpty) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取下载URL失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }
}

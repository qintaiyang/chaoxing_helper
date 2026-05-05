import 'package:fpdart/fpdart.dart';
import '../entities/material.dart';
import '../failures/failure.dart';

abstract class MaterialsRepository {
  Future<Either<Failure, List<Material>>> getCourseMaterials({
    required String courseId,
    required String classId,
    required String cpi,
    String? rootId,
    int pageNum,
  });

  Future<Either<Failure, String>> getMaterialPreviewUrl({
    required String objectId,
    required int puid,
    required int sarepuid,
  });

  Future<Either<Failure, String>> getMaterialDownloadUrl({
    required String objectId,
    required int puid,
    required int sarepuid,
  });
}

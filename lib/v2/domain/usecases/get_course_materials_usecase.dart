import 'package:fpdart/fpdart.dart';
import '../entities/material.dart';
import '../repositories/materials_repository.dart';
import '../failures/failure.dart';

class GetCourseMaterialsUseCase {
  final MaterialsRepository _materialsRepo;

  GetCourseMaterialsUseCase(this._materialsRepo);

  Future<Either<Failure, List<Material>>> execute({
    required String courseId,
    required String classId,
    required String cpi,
    String? rootId,
    int pageNum = 1,
  }) {
    return _materialsRepo.getCourseMaterials(
      courseId: courseId,
      classId: classId,
      cpi: cpi,
      rootId: rootId,
      pageNum: pageNum,
    );
  }
}

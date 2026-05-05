import 'package:fpdart/fpdart.dart';
import '../repositories/materials_repository.dart';
import '../failures/failure.dart';

class GetMaterialDownloadUrlUseCase {
  final MaterialsRepository _materialsRepo;

  GetMaterialDownloadUrlUseCase(this._materialsRepo);

  Future<Either<Failure, String>> execute({
    required String objectId,
    required int puid,
    required int sarepuid,
    bool forPreview = false,
  }) {
    if (forPreview) {
      return _materialsRepo.getMaterialPreviewUrl(
        objectId: objectId,
        puid: puid,
        sarepuid: sarepuid,
      );
    }
    return _materialsRepo.getMaterialDownloadUrl(
      objectId: objectId,
      puid: puid,
      sarepuid: sarepuid,
    );
  }
}

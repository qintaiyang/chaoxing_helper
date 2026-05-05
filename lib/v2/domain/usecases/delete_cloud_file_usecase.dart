import 'package:fpdart/fpdart.dart';
import '../repositories/pan_repository.dart';
import '../failures/failure.dart';

class DeleteCloudFileUseCase {
  final PanRepository _repo;
  DeleteCloudFileUseCase(this._repo);

  Future<Either<Failure, bool>> execute({
    required String resids,
    required String encryptedId,
  }) {
    return _repo.deleteCloudFiles(resids: resids, encryptedId: encryptedId);
  }
}

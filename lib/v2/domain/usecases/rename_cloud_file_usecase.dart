import 'package:fpdart/fpdart.dart';
import '../repositories/pan_repository.dart';
import '../failures/failure.dart';

class RenameCloudFileUseCase {
  final PanRepository _repo;
  RenameCloudFileUseCase(this._repo);

  Future<Either<Failure, bool>> execute({
    required String resids,
    required String name,
    required String encryptedId,
  }) {
    return _repo.renameCloudFile(
      resids: resids,
      name: name,
      encryptedId: encryptedId,
    );
  }
}

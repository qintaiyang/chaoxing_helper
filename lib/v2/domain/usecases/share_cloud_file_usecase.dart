import 'package:fpdart/fpdart.dart';
import '../repositories/pan_repository.dart';
import '../failures/failure.dart';

class ShareCloudFileUseCase {
  final PanRepository _repo;
  ShareCloudFileUseCase(this._repo);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required String resids,
    required String encryptedId,
    String shareType = 'public',
    String? password,
  }) {
    return _repo.shareCloudFile(
      resids: resids,
      encryptedId: encryptedId,
      shareType: shareType,
      password: password,
    );
  }
}

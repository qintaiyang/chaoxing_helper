import 'package:fpdart/fpdart.dart';
import '../repositories/pan_repository.dart';
import '../failures/failure.dart';

class CreateCloudFolderUseCase {
  final PanRepository _repo;
  CreateCloudFolderUseCase(this._repo);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required String name,
    String fldid = '0',
    String visibility = 'onlyme',
  }) {
    return _repo.createCloudFolder(
      name: name,
      fldid: fldid,
      visibility: visibility,
    );
  }
}

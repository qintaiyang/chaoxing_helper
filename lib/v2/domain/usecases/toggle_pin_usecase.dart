import 'package:fpdart/fpdart.dart';
import '../repositories/pan_repository.dart';
import '../failures/failure.dart';

class TogglePinUseCase {
  final PanRepository _repo;
  TogglePinUseCase(this._repo);

  Future<Either<Failure, Map<String, dynamic>>> execute({
    required String resid,
    required String parentId,
    required bool isPinned,
  }) {
    return isPinned
        ? _repo.cancelTop(resid: resid, parentId: parentId)
        : _repo.setupTop(resid: resid, parentId: parentId);
  }
}

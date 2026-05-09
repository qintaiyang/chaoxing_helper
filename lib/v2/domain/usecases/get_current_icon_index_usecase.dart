import 'package:fpdart/fpdart.dart';
import '../repositories/icon_splash_repository.dart';
import '../failures/failure.dart';

class GetCurrentIconIndexUseCase {
  final IconSplashRepository _repository;
  GetCurrentIconIndexUseCase(this._repository);
  Future<Either<Failure, int>> execute() => _repository.getCurrentIconIndex();
}

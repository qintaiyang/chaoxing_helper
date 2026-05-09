import 'package:fpdart/fpdart.dart';
import '../repositories/icon_splash_repository.dart';
import '../failures/failure.dart';

class ClearSavedIconUseCase {
  final IconSplashRepository _repository;
  ClearSavedIconUseCase(this._repository);
  Future<Either<Failure, void>> execute() => _repository.clearSavedIcon();
}

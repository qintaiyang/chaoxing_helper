import 'package:fpdart/fpdart.dart';
import '../repositories/icon_splash_repository.dart';
import '../failures/failure.dart';

class ClearSavedSplashUseCase {
  final IconSplashRepository _repository;
  ClearSavedSplashUseCase(this._repository);
  Future<Either<Failure, void>> execute() => _repository.clearSavedSplash();
}

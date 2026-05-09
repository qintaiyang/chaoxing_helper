import 'package:fpdart/fpdart.dart';
import '../repositories/icon_splash_repository.dart';
import '../failures/failure.dart';

class UpdateSplashImageUseCase {
  final IconSplashRepository _repository;
  UpdateSplashImageUseCase(this._repository);
  Future<Either<Failure, bool>> execute(String splashPath) =>
      _repository.updateSplashImage(splashPath);
}

import 'package:fpdart/fpdart.dart';
import '../repositories/icon_splash_repository.dart';
import '../failures/failure.dart';

class GetSavedSplashPathUseCase {
  final IconSplashRepository _repository;
  GetSavedSplashPathUseCase(this._repository);
  Future<Either<Failure, String?>> execute() =>
      _repository.getSavedSplashPath();
}

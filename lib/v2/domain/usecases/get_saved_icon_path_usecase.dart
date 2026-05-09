import 'package:fpdart/fpdart.dart';
import '../repositories/icon_splash_repository.dart';
import '../failures/failure.dart';

class GetSavedIconPathUseCase {
  final IconSplashRepository _repository;
  GetSavedIconPathUseCase(this._repository);
  Future<Either<Failure, String?>> execute() => _repository.getSavedIconPath();
}

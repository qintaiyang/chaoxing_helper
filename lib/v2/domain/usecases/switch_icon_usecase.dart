import 'package:fpdart/fpdart.dart';
import '../repositories/icon_splash_repository.dart';
import '../failures/failure.dart';

class SwitchIconUseCase {
  final IconSplashRepository _repository;
  SwitchIconUseCase(this._repository);
  Future<Either<Failure, bool>> execute(int iconIndex) =>
      _repository.switchIcon(iconIndex);
}

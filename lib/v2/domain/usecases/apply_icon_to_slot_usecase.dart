import 'package:fpdart/fpdart.dart';
import '../repositories/icon_splash_repository.dart';
import '../failures/failure.dart';

class ApplyIconToSlotUseCase {
  final IconSplashRepository _repository;
  ApplyIconToSlotUseCase(this._repository);
  Future<Either<Failure, bool>> execute({
    required String iconPath,
    required int iconIndex,
  }) =>
      _repository.applyIconToSlot(iconPath: iconPath, iconIndex: iconIndex);
}

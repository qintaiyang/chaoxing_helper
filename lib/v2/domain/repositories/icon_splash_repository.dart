import 'package:fpdart/fpdart.dart';
import '../failures/failure.dart';

abstract interface class IconSplashRepository {
  Future<Either<Failure, String>> pickAndSaveIcon();

  Future<Either<Failure, String>> pickAndSaveSplashImage();

  Future<Either<Failure, bool>> switchIcon(int iconIndex);

  Future<Either<Failure, int>> getCurrentIconIndex();

  Future<Either<Failure, bool>> updateSplashImage(String splashPath);

  Future<Either<Failure, bool>> applyIconToSlot({
    required String iconPath,
    required int iconIndex,
  });

  Future<Either<Failure, String?>> getSavedIconPath();

  Future<Either<Failure, String?>> getSavedSplashPath();

  Future<Either<Failure, void>> clearSavedIcon();

  Future<Either<Failure, void>> clearSavedSplash();
}

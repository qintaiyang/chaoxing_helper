import 'package:fpdart/fpdart.dart';
import 'package:flutter/foundation.dart';
import '../../domain/repositories/icon_splash_repository.dart';
import '../../domain/repositories/storage_repository.dart';
import '../../domain/failures/failure.dart';
import '../datasources/local/icon_splash_local_data_source.dart';

class IconSplashRepositoryImpl implements IconSplashRepository {
  final IconSplashLocalDataSource _localDataSource;
  final StorageRepository _storage;

  IconSplashRepositoryImpl(this._localDataSource, this._storage);

  static const String _iconPathKey = 'custom_icon_path';
  static const String _splashPathKey = 'custom_splash_path';

  @override
  Future<Either<Failure, String>> pickAndSaveIcon() async {
    try {
      final iconPath = await _localDataSource.pickAndProcessAppIcon();
      if (iconPath == null) {
        return const Left(
          Failure.imageProcessing(message: '未选择图片或处理失败'),
        );
      }
      await _storage.setString(_iconPathKey, iconPath);
      return Right(iconPath);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> pickAndSaveSplashImage() async {
    try {
      final splashPath = await _localDataSource.pickAndProcessSplashImage();
      if (splashPath == null) {
        return const Left(
          Failure.splashUpdateFailed(message: '未选择图片或处理失败'),
        );
      }
      await _storage.setString(_splashPathKey, splashPath);

      final success = await _localDataSource.updateNativeSplashImage(splashPath);
      if (!success) {
        return const Left(
          Failure.splashUpdateFailed(message: '更新原生启动图失败'),
        );
      }

      return Right(splashPath);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> switchIcon(int iconIndex) async {
    return applyIconToSlot(iconPath: '', iconIndex: iconIndex);
  }

  @override
  Future<Either<Failure, int>> getCurrentIconIndex() async {
    try {
      final index = await _localDataSource.getCurrentIconIndex();
      return Right(index);
    } catch (e) {
      return const Right(0);
    }
  }

  @override
  Future<Either<Failure, bool>> updateSplashImage(String splashPath) async {
    try {
      final exists = await _localDataSource.splashExists(splashPath);
      if (!exists) {
        return Left(
          Failure.splashUpdateFailed(message: '启动图文件不存在: $splashPath'),
        );
      }

      final success = await _localDataSource.updateNativeSplashImage(splashPath);
      if (!success) {
        return const Left(
          Failure.splashUpdateFailed(message: '更新启动图失败'),
        );
      }

      return const Right(true);
    } catch (e) {
      return Left(
        Failure.splashUpdateFailed(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> applyIconToSlot({
    required String iconPath,
    required int iconIndex,
  }) async {
    try {
      if (iconIndex == 0) {
        final success = await _localDataSource.restoreDefaultIcon();
        return Right(success);
      }

      final exists = await _localDataSource.iconExists(iconPath);
      if (!exists || iconPath.isEmpty) {
        return const Left(Failure.storage(message: '图标文件不存在'));
      }

      final success = await _localDataSource.pinCustomIcon(iconPath, '超星');
      return Right(success);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getSavedIconPath() async {
    try {
      final result = await _storage.getString(_iconPathKey);
      return result.match(
        (failure) => Left(failure),
        (path) => Right(path),
      );
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getSavedSplashPath() async {
    try {
      final result = await _storage.getString(_splashPathKey);
      return result.match(
        (failure) => Left(failure),
        (path) => Right(path),
      );
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearSavedIcon() async {
    try {
      await _storage.remove(_iconPathKey);
      return const Right(null);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearSavedSplash() async {
    try {
      await _storage.remove(_splashPathKey);
      return const Right(null);
    } catch (e) {
      return Left(Failure.storage(message: e.toString()));
    }
  }
}

import 'package:fpdart/fpdart.dart';
import '../../domain/entities/sign_in.dart';
import '../../domain/repositories/signin_repository.dart';
import '../../domain/failures/failure.dart';
import '../datasources/remote/chaoxing/cx_signin_api.dart';
import '../mappers/signin_mapper.dart';

class SignInRepositoryImpl implements SignInRepository {
  final CXSignInApi _cxApi;

  SignInRepositoryImpl(this._cxApi);

  @override
  Future<Either<Failure, SignIn>> normalSignIn({
    required String courseId,
    required String activeId,
    required String uid,
    required String name,
    String? objectId,
    String? validate,
  }) async {
    try {
      final result = await _cxApi.normalSignIn(
        courseId: courseId,
        activeId: activeId,
        uid: uid,
        name: name,
        objectId: objectId,
        validate: validate,
      );
      if (result != null) {
        return Right(
          SignInMapper.toEntity(result, courseId: courseId, activeId: activeId),
        );
      }
      return const Left(Failure.business(message: '签到失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, bool>> checkSignCode({
    required String activeId,
    required String signCode,
  }) async {
    try {
      final result = await _cxApi.checkSignCode(
        activeId: activeId,
        signCode: signCode,
      );
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '验证签到码失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, SignIn>> codeSignIn({
    required String courseId,
    required String activeId,
    required String signCode,
    required String uid,
    required String name,
    String? validate,
  }) async {
    try {
      final result = await _cxApi.codeSignIn(
        courseId: courseId,
        activeId: activeId,
        signCode: signCode,
        uid: uid,
        name: name,
        validate: validate,
      );
      if (result != null) {
        return Right(
          SignInMapper.toEntity(result, courseId: courseId, activeId: activeId),
        );
      }
      return const Left(Failure.business(message: '签到码签到失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, SignIn>> locationSignIn({
    required String courseId,
    required String activeId,
    required String address,
    required double latitude,
    required double longitude,
    required String uid,
    required String name,
    String? validate,
    String? faceId,
  }) async {
    try {
      final result = await _cxApi.locationSignIn(
        courseId: courseId,
        activeId: activeId,
        address: address,
        latitude: latitude,
        longitude: longitude,
        uid: uid,
        name: name,
        validate: validate,
        faceId: faceId,
      );
      if (result != null) {
        return Right(
          SignInMapper.toEntity(result, courseId: courseId, activeId: activeId),
        );
      }
      return const Left(Failure.business(message: '位置签到失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, SignIn>> qrCodeSignIn({
    String? courseId,
    required String activeId,
    required String enc,
    required String uid,
    required String name,
    String? address,
    double? latitude,
    double? longitude,
    String? enc2,
    String? validate,
    String? faceId,
  }) async {
    try {
      final result = await _cxApi.qrCodeSignIn(
        courseId: courseId,
        activeId: activeId,
        enc: enc,
        uid: uid,
        name: name,
        address: address,
        latitude: latitude,
        longitude: longitude,
        enc2: enc2,
        validate: validate,
        faceId: faceId,
      );
      if (result != null) {
        return Right(
          SignInMapper.toEntity(result, courseId: courseId ?? '', activeId: activeId),
        );
      }
      return const Left(Failure.business(message: '二维码签到失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSignDetail(
    String activeId,
  ) async {
    try {
      final result = await _cxApi.getSignDetail(activeId);
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取签到详情失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAttendInfo(
    String activeId,
  ) async {
    try {
      final result = await _cxApi.getAttendInfo(activeId);
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取参与信息失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, SignIn>> groupSignIn({
    required String activeId,
    required String uid,
  }) async {
    try {
      final result = await _cxApi.groupSignIn(activeId: activeId, uid: uid);
      if (result != null) {
        return Right(SignInMapper.toEntity(result, activeId: activeId));
      }
      return const Left(Failure.business(message: '群聊签到失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> groupPreSignIn(
    String activeId,
  ) async {
    try {
      final result = await _cxApi.groupPreSignIn(activeId);
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '群聊预签到失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSignReceipt(
    String activeId,
  ) async {
    try {
      final result = await _cxApi.getSignReceipt(activeId);
      if (result != null) {
        return Right(result);
      }
      return const Left(Failure.business(message: '获取签到回执失败'));
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }
}

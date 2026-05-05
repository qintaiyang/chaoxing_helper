import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/failures/failure.dart';
import '../datasources/remote/chaoxing/cx_auth_api.dart';
import '../models/user_dto.dart';
import '../mappers/user_mapper.dart';
import '../../infra/storage/cookie_manager.dart';

class AuthRepositoryImpl implements AuthRepository {
  final CXAuthApi _cxApi;
  final CookieManager _cookieManager;
  final AccountRepository _accountRepo;

  AuthRepositoryImpl(this._cxApi, this._cookieManager, this._accountRepo);

  @override
  Future<Either<Failure, User>> loginWithPassword(
    String username,
    String password,
  ) async {
    try {
      final result = await _cxApi.loginWeb(username, password);
      if (result == null || result['status'] != true) {
        return Left(
          Failure.auth(message: result?['msg']?.toString() ?? '登录失败'),
        );
      }

      _cxApi.setLoggingInFlag(true);
      final userDto = await _cxApi.getUserInfo();
      _cxApi.setLoggingInFlag(false);

      if (userDto == null) {
        return const Left(Failure.auth(message: '获取用户信息失败'));
      }
      final user = UserDto(
        uid: result['puid']?.toString() ?? userDto.uid,
        name: userDto.name,
        avatar: userDto.avatar,
        phone: userDto.phone,
        school: userDto.school,
        platform: 'chaoxing',
        imAccount: userDto.imAccount,
        status: true,
      ).toEntity();

      await _cookieManager.saveTempCookiesToUser(user.uid);
      await _accountRepo.setCxPassword(user.uid, password);
      debugPrint('✅ 已保存 Cookie 和密码用于自动登录');

      return Right(user);
    } on DioException catch (e) {
      _cxApi.setLoggingInFlag(false);
      return Left(
        Failure.network(
          message: e.message ?? '网络错误',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      _cxApi.setLoggingInFlag(false);
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithPhone(
    String phone,
    String code,
  ) async {
    try {
      final result = await _cxApi.loginWithPhone(phone, code);
      if (result == null || result['status'] != true) {
        return Left(
          Failure.auth(message: result?['msg']?.toString() ?? '登录失败'),
        );
      }

      _cxApi.setLoggingInFlag(true);
      final userDto = await _cxApi.getUserInfo();
      _cxApi.setLoggingInFlag(false);

      if (userDto == null) {
        return const Left(Failure.auth(message: '获取用户信息失败'));
      }
      final user = UserDto(
        uid: result['puid']?.toString() ?? userDto.uid,
        name: userDto.name,
        avatar: userDto.avatar,
        phone: userDto.phone,
        school: userDto.school,
        platform: 'chaoxing',
        imAccount: userDto.imAccount,
        status: true,
      ).toEntity();

      await _cookieManager.saveTempCookiesToUser(user.uid);
      debugPrint('✅ 已保存 Cookie 用于自动登录');

      return Right(user);
    } on DioException catch (e) {
      _cxApi.setLoggingInFlag(false);
      return Left(
        Failure.network(
          message: e.message ?? '网络错误',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      _cxApi.setLoggingInFlag(false);
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithQRCode() async {
    return const Left(Failure.business(message: '二维码登录暂未实现'));
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userDto = await _cxApi.getUserInfo();
      if (userDto == null) {
        return const Left(Failure.auth(message: '未登录'));
      }
      return Right(userDto.toEntity());
    } on DioException catch (e) {
      return Left(
        Failure.network(
          message: e.message ?? '网络错误',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> sendCaptcha(
    String phone,
  ) async {
    try {
      final success = await _cxApi.sendCaptcha(phone);
      if (!success) {
        return const Left(Failure.business(message: '发送验证码失败'));
      }
      return const Right(null);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> checkQRAuthStatus(
    String uuid,
    String enc,
  ) async {
    try {
      final result = await _cxApi.checkQRAuthStatus(uuid, enc);
      return Right(result);
    } catch (e) {
      return Left(Failure.unknown(message: e.toString(), error: e));
    }
  }
}

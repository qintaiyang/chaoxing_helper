import 'package:fpdart/fpdart.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/account_repository.dart';
import '../failures/failure.dart';

class LoginUseCase {
  final AuthRepository _authRepo;
  final AccountRepository _accountRepo;

  LoginUseCase(this._authRepo, this._accountRepo);

  Future<Either<Failure, User>> executeWithPassword(
    String username,
    String password,
  ) async {
    final result = await _authRepo.loginWithPassword(username, password);
    return result.fold((failure) => Left(failure), (user) async {
      final saveResult = await _accountRepo.addAccount(user);
      return saveResult.fold((f) => Left(f), (_) async {
        await _accountRepo.setCurrentSession(user.uid);
        return Right(user);
      });
    });
  }

  Future<Either<Failure, User>> executeWithPhone(
    String phone,
    String code,
  ) async {
    final result = await _authRepo.loginWithPhone(phone, code);
    return result.fold((failure) => Left(failure), (user) async {
      final saveResult = await _accountRepo.addAccount(user);
      return saveResult.fold((f) => Left(f), (_) async {
        await _accountRepo.setCurrentSession(user.uid);
        return Right(user);
      });
    });
  }
}

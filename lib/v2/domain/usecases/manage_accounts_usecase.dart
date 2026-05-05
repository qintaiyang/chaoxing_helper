import 'package:fpdart/fpdart.dart';
import '../entities/user.dart';
import '../repositories/account_repository.dart';
import '../failures/failure.dart';

class ManageAccountsUseCase {
  final AccountRepository _accountRepo;

  ManageAccountsUseCase(this._accountRepo);

  Either<Failure, List<User>> getAllAccounts() => _accountRepo.getAllAccounts();

  Either<Failure, User?> getCurrentAccount() {
    final sessionIdResult = _accountRepo.getCurrentSessionId();
    return sessionIdResult.fold((f) => Left(f), (sessionId) {
      if (sessionId == null) return const Right(null);
      return _accountRepo.getAccountById(sessionId);
    });
  }

  Future<Either<Failure, void>> removeAccounts(List<String> userIds) {
    return _accountRepo.removeAccounts(userIds);
  }

  Future<Either<Failure, void>> switchAccount(String userId) {
    return _accountRepo.setCurrentSession(userId);
  }
}

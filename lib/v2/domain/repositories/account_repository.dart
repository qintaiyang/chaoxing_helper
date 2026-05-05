import 'package:fpdart/fpdart.dart';
import '../entities/user.dart';
import '../failures/failure.dart';

abstract class AccountRepository {
  Either<Failure, String?> getCurrentSessionId();
  Future<Either<Failure, void>> setCurrentSession(String? userId);
  Either<Failure, bool> hasActiveSession();
  Future<Either<Failure, void>> addAccount(User user);
  Future<Either<Failure, void>> removeAccounts(List<String> userIds);
  Either<Failure, List<User>> getAllAccounts();
  Either<Failure, User?> getAccountById(String userId);
  Future<Either<Failure, void>> setCxPassword(String uid, String password);
  Either<Failure, String?> getCxPassword(String uid);
  Future<Either<Failure, void>> deleteCxPassword(String uid);
}

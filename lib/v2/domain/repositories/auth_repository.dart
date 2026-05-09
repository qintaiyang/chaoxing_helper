import 'package:fpdart/fpdart.dart';
import '../entities/user.dart';
import '../failures/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> loginWithApp(String username, String password);
  Future<Either<Failure, User>> loginWithPassword(
    String username,
    String password,
  );
  Future<Either<Failure, User>> loginWithPhone(String phone, String code);
  Future<Either<Failure, User>> loginWithQRCode(String uuid, String enc);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, Map<String, dynamic>?>> sendCaptcha(String phone);
  Future<Either<Failure, Map<String, dynamic>?>> checkQRAuthStatus(
    String uuid,
    String enc,
  );
}

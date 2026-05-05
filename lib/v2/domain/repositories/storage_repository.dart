import 'package:fpdart/fpdart.dart';
import '../failures/failure.dart';

abstract class StorageRepository {
  Future<Either<Failure, String?>> getString(String key);
  String? getStringSync(String key);
  Future<Either<Failure, bool>> setString(String key, String value);
  Future<Either<Failure, bool>> remove(String key);
  Future<Either<Failure, bool>> containsKey(String key);
}

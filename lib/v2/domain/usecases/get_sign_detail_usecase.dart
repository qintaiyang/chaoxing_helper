import 'package:fpdart/fpdart.dart';
import '../repositories/signin_repository.dart';
import '../failures/failure.dart';

class GetSignDetailUseCase {
  final SignInRepository _signInRepo;

  GetSignDetailUseCase(this._signInRepo);

  Future<Either<Failure, Map<String, dynamic>>> execute(String activeId) {
    return _signInRepo.getSignDetail(activeId);
  }
}

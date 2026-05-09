import 'package:fpdart/fpdart.dart';
import '../entities/sign_in.dart';
import '../repositories/signin_repository.dart';
import '../failures/failure.dart';

class GroupSignInUseCase {
  final SignInRepository _signInRepo;

  GroupSignInUseCase(this._signInRepo);

  Future<Either<Failure, SignIn>> execute({
    required String activeId,
    required String uid,
  }) {
    return _signInRepo.groupSignIn(activeId: activeId, uid: uid);
  }
}

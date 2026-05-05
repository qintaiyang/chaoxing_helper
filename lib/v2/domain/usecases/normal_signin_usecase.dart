import 'package:fpdart/fpdart.dart';
import '../entities/sign_in.dart';
import '../repositories/signin_repository.dart';
import '../failures/failure.dart';

class NormalSignInUseCase {
  final SignInRepository _signInRepo;

  NormalSignInUseCase(this._signInRepo);

  Future<Either<Failure, SignIn>> execute({
    required String courseId,
    required String activeId,
    required String uid,
    required String name,
    String? objectId,
    String? validate,
  }) {
    return _signInRepo.normalSignIn(
      courseId: courseId,
      activeId: activeId,
      uid: uid,
      name: name,
      objectId: objectId,
      validate: validate,
    );
  }
}

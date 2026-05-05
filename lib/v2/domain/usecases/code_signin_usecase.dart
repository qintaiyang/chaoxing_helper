import 'package:fpdart/fpdart.dart';
import '../entities/sign_in.dart';
import '../repositories/signin_repository.dart';
import '../failures/failure.dart';

class CodeSignInUseCase {
  final SignInRepository _signInRepo;

  CodeSignInUseCase(this._signInRepo);

  Future<Either<Failure, SignIn>> execute({
    required String courseId,
    required String activeId,
    required String signCode,
    required String uid,
    required String name,
    String? validate,
  }) {
    return _signInRepo.codeSignIn(
      courseId: courseId,
      activeId: activeId,
      signCode: signCode,
      uid: uid,
      name: name,
      validate: validate,
    );
  }
}

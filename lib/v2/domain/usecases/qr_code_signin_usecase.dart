import 'package:fpdart/fpdart.dart';
import '../entities/sign_in.dart';
import '../repositories/signin_repository.dart';
import '../failures/failure.dart';

class QrCodeSignInUseCase {
  final SignInRepository _signInRepo;

  QrCodeSignInUseCase(this._signInRepo);

  Future<Either<Failure, SignIn>> execute({
    String? courseId,
    required String activeId,
    required String enc,
    required String uid,
    required String name,
    String? address,
    double? latitude,
    double? longitude,
    String? enc2,
    String? validate,
    String? faceId,
  }) {
    return _signInRepo.qrCodeSignIn(
      courseId: courseId,
      activeId: activeId,
      enc: enc,
      uid: uid,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
      enc2: enc2,
      validate: validate,
      faceId: faceId,
    );
  }
}

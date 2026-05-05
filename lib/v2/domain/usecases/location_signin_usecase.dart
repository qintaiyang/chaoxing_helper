import 'package:fpdart/fpdart.dart';
import '../entities/sign_in.dart';
import '../repositories/signin_repository.dart';
import '../failures/failure.dart';

class LocationSignInUseCase {
  final SignInRepository _signInRepo;

  LocationSignInUseCase(this._signInRepo);

  Future<Either<Failure, SignIn>> execute({
    required String courseId,
    required String activeId,
    required String address,
    required double latitude,
    required double longitude,
    required String uid,
    required String name,
    String? validate,
    String? faceId,
  }) {
    return _signInRepo.locationSignIn(
      courseId: courseId,
      activeId: activeId,
      address: address,
      latitude: latitude,
      longitude: longitude,
      uid: uid,
      name: name,
      validate: validate,
      faceId: faceId,
    );
  }
}

import 'package:fpdart/fpdart.dart';
import '../entities/sign_in.dart';
import '../failures/failure.dart';

abstract class SignInRepository {
  Future<Either<Failure, SignIn>> normalSignIn({
    required String courseId,
    required String activeId,
    required String uid,
    required String name,
    String? objectId,
    String? validate,
  });
  Future<Either<Failure, bool>> checkSignCode({
    required String activeId,
    required String signCode,
  });
  Future<Either<Failure, SignIn>> codeSignIn({
    required String courseId,
    required String activeId,
    required String signCode,
    required String uid,
    required String name,
    String? validate,
  });
  Future<Either<Failure, SignIn>> locationSignIn({
    required String courseId,
    required String activeId,
    required String address,
    required double latitude,
    required double longitude,
    required String uid,
    required String name,
    String? validate,
    String? faceId,
  });
  Future<Either<Failure, SignIn>> qrCodeSignIn({
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
  });
  Future<Either<Failure, Map<String, dynamic>>> getSignDetail(String activeId);
  Future<Either<Failure, Map<String, dynamic>>> getAttendInfo(String activeId);
  Future<Either<Failure, SignIn>> groupSignIn({
    required String activeId,
    required String uid,
  });
  Future<Either<Failure, Map<String, dynamic>>> groupPreSignIn(String activeId);
  Future<Either<Failure, Map<String, dynamic>>> getSignReceipt(String activeId);
}

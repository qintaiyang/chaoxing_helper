import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@Freezed(unionKey: 'type')
sealed class Failure with _$Failure {
  const factory Failure.network({required String message, int? statusCode}) =
      NetworkFailure;

  const factory Failure.auth({required String message}) = AuthFailure;

  const factory Failure.business({required String message, String? code}) =
      BusinessFailure;

  const factory Failure.storage({required String message}) = StorageFailure;

  const factory Failure.unknown({required String message, Object? error}) =
      UnknownFailure;

  const factory Failure.imageProcessing({required String message}) =
      ImageProcessingFailure;

  const factory Failure.iconSwitchFailed({required String message}) =
      IconSwitchFailed;

  const factory Failure.splashUpdateFailed({required String message}) =
      SplashUpdateFailed;
}

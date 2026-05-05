import 'package:freezed_annotation/freezed_annotation.dart';

part 'signin_dto.freezed.dart';
part 'signin_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class SignInDto with _$SignInDto {
  const factory SignInDto({
    @Default('') String result,
    @Default('') String message,
    @Default(false) bool success,
    @Default('') String activeId,
    @Default('') String courseId,
    @Default(0) int signType,
    @Default('') String address,
    @Default(0) double latitude,
    @Default(0) double longitude,
  }) = _SignInDto;

  factory SignInDto.fromJson(Map<String, dynamic> json) =>
      _$SignInDtoFromJson(json);
}

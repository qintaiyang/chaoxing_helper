import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class UserDto with _$UserDto {
  const factory UserDto({
    required String uid,
    @Default('') String puid,
    @Default('未知用户') String name,
    @Default('') String avatar,
    @Default('') String phone,
    @Default('未知学校') String school,
    @Default('chaoxing') String platform,
    ImAccountDto? imAccount,
    @Default(true) bool status,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
class ImAccountDto with _$ImAccountDto {
  const factory ImAccountDto({
    required String userName,
    required String password,
  }) = _ImAccountDto;

  factory ImAccountDto.fromJson(Map<String, dynamic> json) =>
      _$ImAccountDtoFromJson(json);
}

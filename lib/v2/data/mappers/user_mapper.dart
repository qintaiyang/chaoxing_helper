import '../../domain/entities/user.dart';
import '../../domain/entities/enums.dart';
import '../models/user_dto.dart';

extension UserDtoX on UserDto {
  User toEntity() => User(
    uid: uid,
    puid: puid,
    name: name,
    avatar: avatar,
    phone: phone,
    school: school,
    platform: PlatformType.values.byName(platform),
    imAccount: imAccount?.toEntity(),
    isActive: status,
  );
}

extension ImAccountDtoX on ImAccountDto {
  ImAccount toEntity() => ImAccount(userName: userName, password: password);
}

extension UserX on User {
  UserDto toDto() => UserDto(
    uid: uid,
    puid: puid,
    name: name,
    avatar: avatar,
    phone: phone,
    school: school,
    platform: platform.name,
    imAccount: imAccount != null
        ? ImAccountDto(
            userName: imAccount!.userName,
            password: imAccount!.password,
          )
        : null,
    status: isActive,
  );
}

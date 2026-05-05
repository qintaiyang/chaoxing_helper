import 'enums.dart';

class ImAccount {
  final String userName;
  final String password;

  const ImAccount({required this.userName, required this.password});
}

class User {
  final String uid;
  final String puid;
  final String name;
  final String avatar;
  final String phone;
  final String school;
  final PlatformType platform;
  final ImAccount? imAccount;
  final bool isActive;

  const User({
    required this.uid,
    this.puid = '',
    required this.name,
    this.avatar = '',
    this.phone = '',
    this.school = '',
    this.platform = PlatformType.chaoxing,
    this.imAccount,
    this.isActive = true,
  });

  User copyWith({
    String? uid,
    String? puid,
    String? name,
    String? avatar,
    String? phone,
    String? school,
    PlatformType? platform,
    ImAccount? imAccount,
    bool? isActive,
  }) {
    return User(
      uid: uid ?? this.uid,
      puid: puid ?? this.puid,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      school: school ?? this.school,
      platform: platform ?? this.platform,
      imAccount: imAccount ?? this.imAccount,
      isActive: isActive ?? this.isActive,
    );
  }

  bool get isChaoxing => platform == PlatformType.chaoxing;
  bool get isRainClassroom => platform == PlatformType.rainClassroom;
}

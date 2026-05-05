// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDtoImpl _$$UserDtoImplFromJson(Map<String, dynamic> json) =>
    _$UserDtoImpl(
      uid: json['uid'] as String,
      puid: json['puid'] as String? ?? '',
      name: json['name'] as String? ?? '未知用户',
      avatar: json['avatar'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      school: json['school'] as String? ?? '未知学校',
      platform: json['platform'] as String? ?? 'chaoxing',
      imAccount: json['imAccount'] == null
          ? null
          : ImAccountDto.fromJson(json['imAccount'] as Map<String, dynamic>),
      status: json['status'] as bool? ?? true,
    );

Map<String, dynamic> _$$UserDtoImplToJson(_$UserDtoImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'puid': instance.puid,
      'name': instance.name,
      'avatar': instance.avatar,
      'phone': instance.phone,
      'school': instance.school,
      'platform': instance.platform,
      'imAccount': instance.imAccount,
      'status': instance.status,
    };

_$ImAccountDtoImpl _$$ImAccountDtoImplFromJson(Map<String, dynamic> json) =>
    _$ImAccountDtoImpl(
      userName: json['userName'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$ImAccountDtoImplToJson(_$ImAccountDtoImpl instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
    };

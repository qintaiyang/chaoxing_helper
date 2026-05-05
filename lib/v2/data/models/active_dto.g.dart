// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ActiveDtoImpl _$$ActiveDtoImplFromJson(Map<String, dynamic> json) =>
    _$ActiveDtoImpl(
      type: (json['type'] as num?)?.toInt() ?? 0,
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startTime: (json['startTime'] as num?)?.toInt() ?? 0,
      url: json['url'] as String? ?? '',
      attendNum: (json['attendNum'] as num?)?.toInt() ?? 0,
      status: json['status'] as bool? ?? false,
      extras: json['extras'] as Map<String, dynamic>? ?? const {},
      signType: (json['signType'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ActiveDtoImplToJson(_$ActiveDtoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'startTime': instance.startTime,
      'url': instance.url,
      'attendNum': instance.attendNum,
      'status': instance.status,
      'extras': instance.extras,
      'signType': instance.signType,
    };

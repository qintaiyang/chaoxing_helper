// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignInDtoImpl _$$SignInDtoImplFromJson(Map<String, dynamic> json) =>
    _$SignInDtoImpl(
      result: json['result'] as String? ?? '',
      message: json['message'] as String? ?? '',
      success: json['success'] as bool? ?? false,
      activeId: json['activeId'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      signType: (json['signType'] as num?)?.toInt() ?? 0,
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$SignInDtoImplToJson(_$SignInDtoImpl instance) =>
    <String, dynamic>{
      'result': instance.result,
      'message': instance.message,
      'success': instance.success,
      'activeId': instance.activeId,
      'courseId': instance.courseId,
      'signType': instance.signType,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

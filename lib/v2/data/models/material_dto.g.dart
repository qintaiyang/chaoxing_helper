// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MaterialDtoImpl _$$MaterialDtoImplFromJson(Map<String, dynamic> json) =>
    _$MaterialDtoImpl(
      id: json['id'] as String? ?? '',
      dataName: json['dataName'] as String? ?? '',
      isfile: json['isfile'] as bool? ?? false,
      suffix: json['suffix'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      objectId: json['objectId'] as String? ?? '',
      puid: (json['puid'] as num?)?.toInt() ?? 0,
      ownerPuid: (json['ownerPuid'] as num?)?.toInt() ?? 0,
      forbidDownload: (json['forbidDownload'] as num?)?.toInt() ?? 0,
      cfid: (json['cfid'] as num?)?.toInt() ?? -1,
      dataId: (json['dataId'] as num?)?.toInt() ?? 0,
      orderId: (json['orderId'] as num?)?.toInt() ?? 0,
      norder: (json['norder'] as num?)?.toInt() ?? 0,
      cataName: json['cataName'] as String? ?? '',
      cataid: (json['cataid'] as num?)?.toInt() ?? 0,
      key: json['key'] as String? ?? '',
      content: json['content'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$MaterialDtoImplToJson(_$MaterialDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dataName': instance.dataName,
      'isfile': instance.isfile,
      'suffix': instance.suffix,
      'size': instance.size,
      'objectId': instance.objectId,
      'puid': instance.puid,
      'ownerPuid': instance.ownerPuid,
      'forbidDownload': instance.forbidDownload,
      'cfid': instance.cfid,
      'dataId': instance.dataId,
      'orderId': instance.orderId,
      'norder': instance.norder,
      'cataName': instance.cataName,
      'cataid': instance.cataid,
      'key': instance.key,
      'content': instance.content,
    };

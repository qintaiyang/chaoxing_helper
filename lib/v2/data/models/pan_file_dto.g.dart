// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pan_file_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PanFileDtoImpl _$$PanFileDtoImplFromJson(Map<String, dynamic> json) =>
    _$PanFileDtoImpl(
      fileId: json['id'] as String? ?? '',
      fileName: json['name'] as String? ?? '',
      fileType: json['suffix'] as String? ?? '',
      fileSize: (json['filesize'] as num?)?.toInt() ?? 0,
      fileUrl: json['fileUrl'] as String? ?? '',
      encryptedId: json['encryptedId'] as String? ?? '',
      parentId: json['parentId'] as String? ?? '',
      isFolder: json['isFolder'] as bool? ?? false,
      isPinned: json['topsort'] as bool? ?? false,
      createTime: (json['uploadDate'] as num?)?.toInt() ?? 0,
      updateTime: (json['modifyDate'] as num?)?.toInt() ?? 0,
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      extras: json['extras'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$PanFileDtoImplToJson(_$PanFileDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.fileId,
      'name': instance.fileName,
      'suffix': instance.fileType,
      'filesize': instance.fileSize,
      'fileUrl': instance.fileUrl,
      'encryptedId': instance.encryptedId,
      'parentId': instance.parentId,
      'isFolder': instance.isFolder,
      'topsort': instance.isPinned,
      'uploadDate': instance.createTime,
      'modifyDate': instance.updateTime,
      'thumbnailUrl': instance.thumbnailUrl,
      'extras': instance.extras,
    };

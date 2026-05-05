import 'package:freezed_annotation/freezed_annotation.dart';

part 'material_dto.freezed.dart';
part 'material_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class MaterialDto with _$MaterialDto {
  const factory MaterialDto({
    @Default('') String id,
    @Default('') String dataName,
    @Default(false) bool isfile,
    @Default('') String suffix,
    @Default(0) int size,
    @Default('') String objectId,
    @Default(0) int puid,
    @Default(0) int ownerPuid,
    @Default(0) int forbidDownload,
    @Default(-1) int cfid,
    @Default(0) int dataId,
    @Default(0) int orderId,
    @Default(0) int norder,
    @Default('') String cataName,
    @Default(0) int cataid,
    @Default('') String key,
    @Default({}) Map<String, dynamic> content,
  }) = _MaterialDto;

  factory MaterialDto.fromJson(Map<String, dynamic> json) =>
      _$MaterialDtoFromJson(_mergeContent(json));

  static Map<String, dynamic> _mergeContent(Map<String, dynamic> json) {
    final content = json['content'] as Map<String, dynamic>?;
    if (content == null) return json;

    return {
      ...json,
      if (content['isfile'] != null) 'isfile': content['isfile'],
      if (content['name'] != null) 'dataName': content['name'],
      if (content['suffix'] != null) 'suffix': content['suffix'],
      if (content['size'] != null) 'size': content['size'],
      if (content['objectId'] != null) 'objectId': content['objectId'],
      if (content['puid'] != null) 'ownerPuid': content['puid'],
      if (content['id'] != null && json['id'] == '') 'id': content['id'],
    };
  }
}

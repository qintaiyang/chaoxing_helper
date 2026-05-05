import 'package:freezed_annotation/freezed_annotation.dart';

part 'pan_file_dto.freezed.dart';
part 'pan_file_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class PanFileDto with _$PanFileDto {
  const factory PanFileDto({
    @JsonKey(name: 'id') @Default('') String fileId,
    @JsonKey(name: 'name') @Default('') String fileName,
    @JsonKey(name: 'suffix') @Default('') String fileType,
    @JsonKey(name: 'filesize') @Default(0) int fileSize,
    @JsonKey(name: 'fileUrl') @Default('') String fileUrl,
    @JsonKey(name: 'encryptedId') @Default('') String encryptedId,
    @JsonKey(name: 'parentId') @Default('') String parentId,
    @Default(false) bool isFolder,
    @JsonKey(name: 'topsort') @Default(false) bool isPinned,
    @JsonKey(name: 'uploadDate') @Default(0) int createTime,
    @JsonKey(name: 'modifyDate') @Default(0) int updateTime,
    @JsonKey(name: 'thumbnailUrl') @Default('') String thumbnailUrl,
    @Default({}) Map<String, dynamic> extras,
  }) = _PanFileDto;

  factory PanFileDto.fromJson(Map<String, dynamic> json) {
    final isfile = json['isfile'];
    bool isFolder = false;
    if (isfile is bool) {
      isFolder = !isfile;
    } else if (isfile is int) {
      isFolder = isfile == 0;
    } else if (isfile is String) {
      isFolder = isfile == '0' || isfile == 'false';
    }
    json['isFolder'] = isFolder;

    final topsort = json['topsort'];
    bool isPinned = false;
    if (topsort is int) {
      isPinned = topsort > 0;
    } else if (topsort is String) {
      isPinned = int.tryParse(topsort) != null && int.tryParse(topsort)! > 0;
    } else if (topsort is bool) {
      isPinned = topsort;
    }
    json['isPinned'] = isPinned;
    json['topsort'] = isPinned;

    return _$PanFileDtoFromJson(json);
  }
}

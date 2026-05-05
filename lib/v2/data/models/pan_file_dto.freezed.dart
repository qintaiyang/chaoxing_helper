// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pan_file_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PanFileDto _$PanFileDtoFromJson(Map<String, dynamic> json) {
  return _PanFileDto.fromJson(json);
}

/// @nodoc
mixin _$PanFileDto {
  @JsonKey(name: 'id')
  String get fileId => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get fileName => throw _privateConstructorUsedError;
  @JsonKey(name: 'suffix')
  String get fileType => throw _privateConstructorUsedError;
  @JsonKey(name: 'filesize')
  int get fileSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'fileUrl')
  String get fileUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'encryptedId')
  String get encryptedId => throw _privateConstructorUsedError;
  @JsonKey(name: 'parentId')
  String get parentId => throw _privateConstructorUsedError;
  bool get isFolder => throw _privateConstructorUsedError;
  @JsonKey(name: 'topsort')
  bool get isPinned => throw _privateConstructorUsedError;
  @JsonKey(name: 'uploadDate')
  int get createTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'modifyDate')
  int get updateTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnailUrl')
  String get thumbnailUrl => throw _privateConstructorUsedError;
  Map<String, dynamic> get extras => throw _privateConstructorUsedError;

  /// Serializes this PanFileDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PanFileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PanFileDtoCopyWith<PanFileDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PanFileDtoCopyWith<$Res> {
  factory $PanFileDtoCopyWith(
    PanFileDto value,
    $Res Function(PanFileDto) then,
  ) = _$PanFileDtoCopyWithImpl<$Res, PanFileDto>;
  @useResult
  $Res call({
    @JsonKey(name: 'id') String fileId,
    @JsonKey(name: 'name') String fileName,
    @JsonKey(name: 'suffix') String fileType,
    @JsonKey(name: 'filesize') int fileSize,
    @JsonKey(name: 'fileUrl') String fileUrl,
    @JsonKey(name: 'encryptedId') String encryptedId,
    @JsonKey(name: 'parentId') String parentId,
    bool isFolder,
    @JsonKey(name: 'topsort') bool isPinned,
    @JsonKey(name: 'uploadDate') int createTime,
    @JsonKey(name: 'modifyDate') int updateTime,
    @JsonKey(name: 'thumbnailUrl') String thumbnailUrl,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class _$PanFileDtoCopyWithImpl<$Res, $Val extends PanFileDto>
    implements $PanFileDtoCopyWith<$Res> {
  _$PanFileDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PanFileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? fileName = null,
    Object? fileType = null,
    Object? fileSize = null,
    Object? fileUrl = null,
    Object? encryptedId = null,
    Object? parentId = null,
    Object? isFolder = null,
    Object? isPinned = null,
    Object? createTime = null,
    Object? updateTime = null,
    Object? thumbnailUrl = null,
    Object? extras = null,
  }) {
    return _then(
      _value.copyWith(
            fileId: null == fileId
                ? _value.fileId
                : fileId // ignore: cast_nullable_to_non_nullable
                      as String,
            fileName: null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String,
            fileType: null == fileType
                ? _value.fileType
                : fileType // ignore: cast_nullable_to_non_nullable
                      as String,
            fileSize: null == fileSize
                ? _value.fileSize
                : fileSize // ignore: cast_nullable_to_non_nullable
                      as int,
            fileUrl: null == fileUrl
                ? _value.fileUrl
                : fileUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            encryptedId: null == encryptedId
                ? _value.encryptedId
                : encryptedId // ignore: cast_nullable_to_non_nullable
                      as String,
            parentId: null == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String,
            isFolder: null == isFolder
                ? _value.isFolder
                : isFolder // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPinned: null == isPinned
                ? _value.isPinned
                : isPinned // ignore: cast_nullable_to_non_nullable
                      as bool,
            createTime: null == createTime
                ? _value.createTime
                : createTime // ignore: cast_nullable_to_non_nullable
                      as int,
            updateTime: null == updateTime
                ? _value.updateTime
                : updateTime // ignore: cast_nullable_to_non_nullable
                      as int,
            thumbnailUrl: null == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            extras: null == extras
                ? _value.extras
                : extras // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PanFileDtoImplCopyWith<$Res>
    implements $PanFileDtoCopyWith<$Res> {
  factory _$$PanFileDtoImplCopyWith(
    _$PanFileDtoImpl value,
    $Res Function(_$PanFileDtoImpl) then,
  ) = __$$PanFileDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'id') String fileId,
    @JsonKey(name: 'name') String fileName,
    @JsonKey(name: 'suffix') String fileType,
    @JsonKey(name: 'filesize') int fileSize,
    @JsonKey(name: 'fileUrl') String fileUrl,
    @JsonKey(name: 'encryptedId') String encryptedId,
    @JsonKey(name: 'parentId') String parentId,
    bool isFolder,
    @JsonKey(name: 'topsort') bool isPinned,
    @JsonKey(name: 'uploadDate') int createTime,
    @JsonKey(name: 'modifyDate') int updateTime,
    @JsonKey(name: 'thumbnailUrl') String thumbnailUrl,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class __$$PanFileDtoImplCopyWithImpl<$Res>
    extends _$PanFileDtoCopyWithImpl<$Res, _$PanFileDtoImpl>
    implements _$$PanFileDtoImplCopyWith<$Res> {
  __$$PanFileDtoImplCopyWithImpl(
    _$PanFileDtoImpl _value,
    $Res Function(_$PanFileDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PanFileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fileId = null,
    Object? fileName = null,
    Object? fileType = null,
    Object? fileSize = null,
    Object? fileUrl = null,
    Object? encryptedId = null,
    Object? parentId = null,
    Object? isFolder = null,
    Object? isPinned = null,
    Object? createTime = null,
    Object? updateTime = null,
    Object? thumbnailUrl = null,
    Object? extras = null,
  }) {
    return _then(
      _$PanFileDtoImpl(
        fileId: null == fileId
            ? _value.fileId
            : fileId // ignore: cast_nullable_to_non_nullable
                  as String,
        fileName: null == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String,
        fileType: null == fileType
            ? _value.fileType
            : fileType // ignore: cast_nullable_to_non_nullable
                  as String,
        fileSize: null == fileSize
            ? _value.fileSize
            : fileSize // ignore: cast_nullable_to_non_nullable
                  as int,
        fileUrl: null == fileUrl
            ? _value.fileUrl
            : fileUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        encryptedId: null == encryptedId
            ? _value.encryptedId
            : encryptedId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: null == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String,
        isFolder: null == isFolder
            ? _value.isFolder
            : isFolder // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPinned: null == isPinned
            ? _value.isPinned
            : isPinned // ignore: cast_nullable_to_non_nullable
                  as bool,
        createTime: null == createTime
            ? _value.createTime
            : createTime // ignore: cast_nullable_to_non_nullable
                  as int,
        updateTime: null == updateTime
            ? _value.updateTime
            : updateTime // ignore: cast_nullable_to_non_nullable
                  as int,
        thumbnailUrl: null == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        extras: null == extras
            ? _value._extras
            : extras // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PanFileDtoImpl implements _PanFileDto {
  const _$PanFileDtoImpl({
    @JsonKey(name: 'id') this.fileId = '',
    @JsonKey(name: 'name') this.fileName = '',
    @JsonKey(name: 'suffix') this.fileType = '',
    @JsonKey(name: 'filesize') this.fileSize = 0,
    @JsonKey(name: 'fileUrl') this.fileUrl = '',
    @JsonKey(name: 'encryptedId') this.encryptedId = '',
    @JsonKey(name: 'parentId') this.parentId = '',
    this.isFolder = false,
    @JsonKey(name: 'topsort') this.isPinned = false,
    @JsonKey(name: 'uploadDate') this.createTime = 0,
    @JsonKey(name: 'modifyDate') this.updateTime = 0,
    @JsonKey(name: 'thumbnailUrl') this.thumbnailUrl = '',
    final Map<String, dynamic> extras = const {},
  }) : _extras = extras;

  factory _$PanFileDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PanFileDtoImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String fileId;
  @override
  @JsonKey(name: 'name')
  final String fileName;
  @override
  @JsonKey(name: 'suffix')
  final String fileType;
  @override
  @JsonKey(name: 'filesize')
  final int fileSize;
  @override
  @JsonKey(name: 'fileUrl')
  final String fileUrl;
  @override
  @JsonKey(name: 'encryptedId')
  final String encryptedId;
  @override
  @JsonKey(name: 'parentId')
  final String parentId;
  @override
  @JsonKey()
  final bool isFolder;
  @override
  @JsonKey(name: 'topsort')
  final bool isPinned;
  @override
  @JsonKey(name: 'uploadDate')
  final int createTime;
  @override
  @JsonKey(name: 'modifyDate')
  final int updateTime;
  @override
  @JsonKey(name: 'thumbnailUrl')
  final String thumbnailUrl;
  final Map<String, dynamic> _extras;
  @override
  @JsonKey()
  Map<String, dynamic> get extras {
    if (_extras is EqualUnmodifiableMapView) return _extras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extras);
  }

  @override
  String toString() {
    return 'PanFileDto(fileId: $fileId, fileName: $fileName, fileType: $fileType, fileSize: $fileSize, fileUrl: $fileUrl, encryptedId: $encryptedId, parentId: $parentId, isFolder: $isFolder, isPinned: $isPinned, createTime: $createTime, updateTime: $updateTime, thumbnailUrl: $thumbnailUrl, extras: $extras)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PanFileDtoImpl &&
            (identical(other.fileId, fileId) || other.fileId == fileId) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.fileUrl, fileUrl) || other.fileUrl == fileUrl) &&
            (identical(other.encryptedId, encryptedId) ||
                other.encryptedId == encryptedId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.isFolder, isFolder) ||
                other.isFolder == isFolder) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.updateTime, updateTime) ||
                other.updateTime == updateTime) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fileId,
    fileName,
    fileType,
    fileSize,
    fileUrl,
    encryptedId,
    parentId,
    isFolder,
    isPinned,
    createTime,
    updateTime,
    thumbnailUrl,
    const DeepCollectionEquality().hash(_extras),
  );

  /// Create a copy of PanFileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PanFileDtoImplCopyWith<_$PanFileDtoImpl> get copyWith =>
      __$$PanFileDtoImplCopyWithImpl<_$PanFileDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PanFileDtoImplToJson(this);
  }
}

abstract class _PanFileDto implements PanFileDto {
  const factory _PanFileDto({
    @JsonKey(name: 'id') final String fileId,
    @JsonKey(name: 'name') final String fileName,
    @JsonKey(name: 'suffix') final String fileType,
    @JsonKey(name: 'filesize') final int fileSize,
    @JsonKey(name: 'fileUrl') final String fileUrl,
    @JsonKey(name: 'encryptedId') final String encryptedId,
    @JsonKey(name: 'parentId') final String parentId,
    final bool isFolder,
    @JsonKey(name: 'topsort') final bool isPinned,
    @JsonKey(name: 'uploadDate') final int createTime,
    @JsonKey(name: 'modifyDate') final int updateTime,
    @JsonKey(name: 'thumbnailUrl') final String thumbnailUrl,
    final Map<String, dynamic> extras,
  }) = _$PanFileDtoImpl;

  factory _PanFileDto.fromJson(Map<String, dynamic> json) =
      _$PanFileDtoImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get fileId;
  @override
  @JsonKey(name: 'name')
  String get fileName;
  @override
  @JsonKey(name: 'suffix')
  String get fileType;
  @override
  @JsonKey(name: 'filesize')
  int get fileSize;
  @override
  @JsonKey(name: 'fileUrl')
  String get fileUrl;
  @override
  @JsonKey(name: 'encryptedId')
  String get encryptedId;
  @override
  @JsonKey(name: 'parentId')
  String get parentId;
  @override
  bool get isFolder;
  @override
  @JsonKey(name: 'topsort')
  bool get isPinned;
  @override
  @JsonKey(name: 'uploadDate')
  int get createTime;
  @override
  @JsonKey(name: 'modifyDate')
  int get updateTime;
  @override
  @JsonKey(name: 'thumbnailUrl')
  String get thumbnailUrl;
  @override
  Map<String, dynamic> get extras;

  /// Create a copy of PanFileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PanFileDtoImplCopyWith<_$PanFileDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

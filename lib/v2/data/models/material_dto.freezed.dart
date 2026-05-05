// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'material_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MaterialDto _$MaterialDtoFromJson(Map<String, dynamic> json) {
  return _MaterialDto.fromJson(json);
}

/// @nodoc
mixin _$MaterialDto {
  String get id => throw _privateConstructorUsedError;
  String get dataName => throw _privateConstructorUsedError;
  bool get isfile => throw _privateConstructorUsedError;
  String get suffix => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  String get objectId => throw _privateConstructorUsedError;
  int get puid => throw _privateConstructorUsedError;
  int get ownerPuid => throw _privateConstructorUsedError;
  int get forbidDownload => throw _privateConstructorUsedError;
  int get cfid => throw _privateConstructorUsedError;
  int get dataId => throw _privateConstructorUsedError;
  int get orderId => throw _privateConstructorUsedError;
  int get norder => throw _privateConstructorUsedError;
  String get cataName => throw _privateConstructorUsedError;
  int get cataid => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  Map<String, dynamic> get content => throw _privateConstructorUsedError;

  /// Serializes this MaterialDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MaterialDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MaterialDtoCopyWith<MaterialDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MaterialDtoCopyWith<$Res> {
  factory $MaterialDtoCopyWith(
    MaterialDto value,
    $Res Function(MaterialDto) then,
  ) = _$MaterialDtoCopyWithImpl<$Res, MaterialDto>;
  @useResult
  $Res call({
    String id,
    String dataName,
    bool isfile,
    String suffix,
    int size,
    String objectId,
    int puid,
    int ownerPuid,
    int forbidDownload,
    int cfid,
    int dataId,
    int orderId,
    int norder,
    String cataName,
    int cataid,
    String key,
    Map<String, dynamic> content,
  });
}

/// @nodoc
class _$MaterialDtoCopyWithImpl<$Res, $Val extends MaterialDto>
    implements $MaterialDtoCopyWith<$Res> {
  _$MaterialDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MaterialDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dataName = null,
    Object? isfile = null,
    Object? suffix = null,
    Object? size = null,
    Object? objectId = null,
    Object? puid = null,
    Object? ownerPuid = null,
    Object? forbidDownload = null,
    Object? cfid = null,
    Object? dataId = null,
    Object? orderId = null,
    Object? norder = null,
    Object? cataName = null,
    Object? cataid = null,
    Object? key = null,
    Object? content = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            dataName: null == dataName
                ? _value.dataName
                : dataName // ignore: cast_nullable_to_non_nullable
                      as String,
            isfile: null == isfile
                ? _value.isfile
                : isfile // ignore: cast_nullable_to_non_nullable
                      as bool,
            suffix: null == suffix
                ? _value.suffix
                : suffix // ignore: cast_nullable_to_non_nullable
                      as String,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int,
            objectId: null == objectId
                ? _value.objectId
                : objectId // ignore: cast_nullable_to_non_nullable
                      as String,
            puid: null == puid
                ? _value.puid
                : puid // ignore: cast_nullable_to_non_nullable
                      as int,
            ownerPuid: null == ownerPuid
                ? _value.ownerPuid
                : ownerPuid // ignore: cast_nullable_to_non_nullable
                      as int,
            forbidDownload: null == forbidDownload
                ? _value.forbidDownload
                : forbidDownload // ignore: cast_nullable_to_non_nullable
                      as int,
            cfid: null == cfid
                ? _value.cfid
                : cfid // ignore: cast_nullable_to_non_nullable
                      as int,
            dataId: null == dataId
                ? _value.dataId
                : dataId // ignore: cast_nullable_to_non_nullable
                      as int,
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as int,
            norder: null == norder
                ? _value.norder
                : norder // ignore: cast_nullable_to_non_nullable
                      as int,
            cataName: null == cataName
                ? _value.cataName
                : cataName // ignore: cast_nullable_to_non_nullable
                      as String,
            cataid: null == cataid
                ? _value.cataid
                : cataid // ignore: cast_nullable_to_non_nullable
                      as int,
            key: null == key
                ? _value.key
                : key // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MaterialDtoImplCopyWith<$Res>
    implements $MaterialDtoCopyWith<$Res> {
  factory _$$MaterialDtoImplCopyWith(
    _$MaterialDtoImpl value,
    $Res Function(_$MaterialDtoImpl) then,
  ) = __$$MaterialDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String dataName,
    bool isfile,
    String suffix,
    int size,
    String objectId,
    int puid,
    int ownerPuid,
    int forbidDownload,
    int cfid,
    int dataId,
    int orderId,
    int norder,
    String cataName,
    int cataid,
    String key,
    Map<String, dynamic> content,
  });
}

/// @nodoc
class __$$MaterialDtoImplCopyWithImpl<$Res>
    extends _$MaterialDtoCopyWithImpl<$Res, _$MaterialDtoImpl>
    implements _$$MaterialDtoImplCopyWith<$Res> {
  __$$MaterialDtoImplCopyWithImpl(
    _$MaterialDtoImpl _value,
    $Res Function(_$MaterialDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MaterialDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dataName = null,
    Object? isfile = null,
    Object? suffix = null,
    Object? size = null,
    Object? objectId = null,
    Object? puid = null,
    Object? ownerPuid = null,
    Object? forbidDownload = null,
    Object? cfid = null,
    Object? dataId = null,
    Object? orderId = null,
    Object? norder = null,
    Object? cataName = null,
    Object? cataid = null,
    Object? key = null,
    Object? content = null,
  }) {
    return _then(
      _$MaterialDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        dataName: null == dataName
            ? _value.dataName
            : dataName // ignore: cast_nullable_to_non_nullable
                  as String,
        isfile: null == isfile
            ? _value.isfile
            : isfile // ignore: cast_nullable_to_non_nullable
                  as bool,
        suffix: null == suffix
            ? _value.suffix
            : suffix // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int,
        objectId: null == objectId
            ? _value.objectId
            : objectId // ignore: cast_nullable_to_non_nullable
                  as String,
        puid: null == puid
            ? _value.puid
            : puid // ignore: cast_nullable_to_non_nullable
                  as int,
        ownerPuid: null == ownerPuid
            ? _value.ownerPuid
            : ownerPuid // ignore: cast_nullable_to_non_nullable
                  as int,
        forbidDownload: null == forbidDownload
            ? _value.forbidDownload
            : forbidDownload // ignore: cast_nullable_to_non_nullable
                  as int,
        cfid: null == cfid
            ? _value.cfid
            : cfid // ignore: cast_nullable_to_non_nullable
                  as int,
        dataId: null == dataId
            ? _value.dataId
            : dataId // ignore: cast_nullable_to_non_nullable
                  as int,
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as int,
        norder: null == norder
            ? _value.norder
            : norder // ignore: cast_nullable_to_non_nullable
                  as int,
        cataName: null == cataName
            ? _value.cataName
            : cataName // ignore: cast_nullable_to_non_nullable
                  as String,
        cataid: null == cataid
            ? _value.cataid
            : cataid // ignore: cast_nullable_to_non_nullable
                  as int,
        key: null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value._content
            : content // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MaterialDtoImpl implements _MaterialDto {
  const _$MaterialDtoImpl({
    this.id = '',
    this.dataName = '',
    this.isfile = false,
    this.suffix = '',
    this.size = 0,
    this.objectId = '',
    this.puid = 0,
    this.ownerPuid = 0,
    this.forbidDownload = 0,
    this.cfid = -1,
    this.dataId = 0,
    this.orderId = 0,
    this.norder = 0,
    this.cataName = '',
    this.cataid = 0,
    this.key = '',
    final Map<String, dynamic> content = const {},
  }) : _content = content;

  factory _$MaterialDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MaterialDtoImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String dataName;
  @override
  @JsonKey()
  final bool isfile;
  @override
  @JsonKey()
  final String suffix;
  @override
  @JsonKey()
  final int size;
  @override
  @JsonKey()
  final String objectId;
  @override
  @JsonKey()
  final int puid;
  @override
  @JsonKey()
  final int ownerPuid;
  @override
  @JsonKey()
  final int forbidDownload;
  @override
  @JsonKey()
  final int cfid;
  @override
  @JsonKey()
  final int dataId;
  @override
  @JsonKey()
  final int orderId;
  @override
  @JsonKey()
  final int norder;
  @override
  @JsonKey()
  final String cataName;
  @override
  @JsonKey()
  final int cataid;
  @override
  @JsonKey()
  final String key;
  final Map<String, dynamic> _content;
  @override
  @JsonKey()
  Map<String, dynamic> get content {
    if (_content is EqualUnmodifiableMapView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_content);
  }

  @override
  String toString() {
    return 'MaterialDto(id: $id, dataName: $dataName, isfile: $isfile, suffix: $suffix, size: $size, objectId: $objectId, puid: $puid, ownerPuid: $ownerPuid, forbidDownload: $forbidDownload, cfid: $cfid, dataId: $dataId, orderId: $orderId, norder: $norder, cataName: $cataName, cataid: $cataid, key: $key, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MaterialDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dataName, dataName) ||
                other.dataName == dataName) &&
            (identical(other.isfile, isfile) || other.isfile == isfile) &&
            (identical(other.suffix, suffix) || other.suffix == suffix) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.objectId, objectId) ||
                other.objectId == objectId) &&
            (identical(other.puid, puid) || other.puid == puid) &&
            (identical(other.ownerPuid, ownerPuid) ||
                other.ownerPuid == ownerPuid) &&
            (identical(other.forbidDownload, forbidDownload) ||
                other.forbidDownload == forbidDownload) &&
            (identical(other.cfid, cfid) || other.cfid == cfid) &&
            (identical(other.dataId, dataId) || other.dataId == dataId) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.norder, norder) || other.norder == norder) &&
            (identical(other.cataName, cataName) ||
                other.cataName == cataName) &&
            (identical(other.cataid, cataid) || other.cataid == cataid) &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other._content, _content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    dataName,
    isfile,
    suffix,
    size,
    objectId,
    puid,
    ownerPuid,
    forbidDownload,
    cfid,
    dataId,
    orderId,
    norder,
    cataName,
    cataid,
    key,
    const DeepCollectionEquality().hash(_content),
  );

  /// Create a copy of MaterialDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MaterialDtoImplCopyWith<_$MaterialDtoImpl> get copyWith =>
      __$$MaterialDtoImplCopyWithImpl<_$MaterialDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MaterialDtoImplToJson(this);
  }
}

abstract class _MaterialDto implements MaterialDto {
  const factory _MaterialDto({
    final String id,
    final String dataName,
    final bool isfile,
    final String suffix,
    final int size,
    final String objectId,
    final int puid,
    final int ownerPuid,
    final int forbidDownload,
    final int cfid,
    final int dataId,
    final int orderId,
    final int norder,
    final String cataName,
    final int cataid,
    final String key,
    final Map<String, dynamic> content,
  }) = _$MaterialDtoImpl;

  factory _MaterialDto.fromJson(Map<String, dynamic> json) =
      _$MaterialDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get dataName;
  @override
  bool get isfile;
  @override
  String get suffix;
  @override
  int get size;
  @override
  String get objectId;
  @override
  int get puid;
  @override
  int get ownerPuid;
  @override
  int get forbidDownload;
  @override
  int get cfid;
  @override
  int get dataId;
  @override
  int get orderId;
  @override
  int get norder;
  @override
  String get cataName;
  @override
  int get cataid;
  @override
  String get key;
  @override
  Map<String, dynamic> get content;

  /// Create a copy of MaterialDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MaterialDtoImplCopyWith<_$MaterialDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

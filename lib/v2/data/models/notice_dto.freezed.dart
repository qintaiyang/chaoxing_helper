// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notice_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NoticeDto _$NoticeDtoFromJson(Map<String, dynamic> json) {
  return _NoticeDto.fromJson(json);
}

/// @nodoc
mixin _$NoticeDto {
  String get noticeId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  int get createTime => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  String get courseId => throw _privateConstructorUsedError;
  String get folderId => throw _privateConstructorUsedError;
  Map<String, dynamic> get extras => throw _privateConstructorUsedError;

  /// Serializes this NoticeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NoticeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoticeDtoCopyWith<NoticeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoticeDtoCopyWith<$Res> {
  factory $NoticeDtoCopyWith(NoticeDto value, $Res Function(NoticeDto) then) =
      _$NoticeDtoCopyWithImpl<$Res, NoticeDto>;
  @useResult
  $Res call({
    String noticeId,
    String title,
    String content,
    String author,
    int createTime,
    bool isRead,
    String courseId,
    String folderId,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class _$NoticeDtoCopyWithImpl<$Res, $Val extends NoticeDto>
    implements $NoticeDtoCopyWith<$Res> {
  _$NoticeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NoticeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noticeId = null,
    Object? title = null,
    Object? content = null,
    Object? author = null,
    Object? createTime = null,
    Object? isRead = null,
    Object? courseId = null,
    Object? folderId = null,
    Object? extras = null,
  }) {
    return _then(
      _value.copyWith(
            noticeId: null == noticeId
                ? _value.noticeId
                : noticeId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            createTime: null == createTime
                ? _value.createTime
                : createTime // ignore: cast_nullable_to_non_nullable
                      as int,
            isRead: null == isRead
                ? _value.isRead
                : isRead // ignore: cast_nullable_to_non_nullable
                      as bool,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            folderId: null == folderId
                ? _value.folderId
                : folderId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$NoticeDtoImplCopyWith<$Res>
    implements $NoticeDtoCopyWith<$Res> {
  factory _$$NoticeDtoImplCopyWith(
    _$NoticeDtoImpl value,
    $Res Function(_$NoticeDtoImpl) then,
  ) = __$$NoticeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String noticeId,
    String title,
    String content,
    String author,
    int createTime,
    bool isRead,
    String courseId,
    String folderId,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class __$$NoticeDtoImplCopyWithImpl<$Res>
    extends _$NoticeDtoCopyWithImpl<$Res, _$NoticeDtoImpl>
    implements _$$NoticeDtoImplCopyWith<$Res> {
  __$$NoticeDtoImplCopyWithImpl(
    _$NoticeDtoImpl _value,
    $Res Function(_$NoticeDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NoticeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? noticeId = null,
    Object? title = null,
    Object? content = null,
    Object? author = null,
    Object? createTime = null,
    Object? isRead = null,
    Object? courseId = null,
    Object? folderId = null,
    Object? extras = null,
  }) {
    return _then(
      _$NoticeDtoImpl(
        noticeId: null == noticeId
            ? _value.noticeId
            : noticeId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        createTime: null == createTime
            ? _value.createTime
            : createTime // ignore: cast_nullable_to_non_nullable
                  as int,
        isRead: null == isRead
            ? _value.isRead
            : isRead // ignore: cast_nullable_to_non_nullable
                  as bool,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        folderId: null == folderId
            ? _value.folderId
            : folderId // ignore: cast_nullable_to_non_nullable
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
class _$NoticeDtoImpl implements _NoticeDto {
  const _$NoticeDtoImpl({
    this.noticeId = '',
    this.title = '',
    this.content = '',
    this.author = '',
    this.createTime = 0,
    this.isRead = false,
    this.courseId = '',
    this.folderId = '',
    final Map<String, dynamic> extras = const {},
  }) : _extras = extras;

  factory _$NoticeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoticeDtoImplFromJson(json);

  @override
  @JsonKey()
  final String noticeId;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String author;
  @override
  @JsonKey()
  final int createTime;
  @override
  @JsonKey()
  final bool isRead;
  @override
  @JsonKey()
  final String courseId;
  @override
  @JsonKey()
  final String folderId;
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
    return 'NoticeDto(noticeId: $noticeId, title: $title, content: $content, author: $author, createTime: $createTime, isRead: $isRead, courseId: $courseId, folderId: $folderId, extras: $extras)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoticeDtoImpl &&
            (identical(other.noticeId, noticeId) ||
                other.noticeId == noticeId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    noticeId,
    title,
    content,
    author,
    createTime,
    isRead,
    courseId,
    folderId,
    const DeepCollectionEquality().hash(_extras),
  );

  /// Create a copy of NoticeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoticeDtoImplCopyWith<_$NoticeDtoImpl> get copyWith =>
      __$$NoticeDtoImplCopyWithImpl<_$NoticeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoticeDtoImplToJson(this);
  }
}

abstract class _NoticeDto implements NoticeDto {
  const factory _NoticeDto({
    final String noticeId,
    final String title,
    final String content,
    final String author,
    final int createTime,
    final bool isRead,
    final String courseId,
    final String folderId,
    final Map<String, dynamic> extras,
  }) = _$NoticeDtoImpl;

  factory _NoticeDto.fromJson(Map<String, dynamic> json) =
      _$NoticeDtoImpl.fromJson;

  @override
  String get noticeId;
  @override
  String get title;
  @override
  String get content;
  @override
  String get author;
  @override
  int get createTime;
  @override
  bool get isRead;
  @override
  String get courseId;
  @override
  String get folderId;
  @override
  Map<String, dynamic> get extras;

  /// Create a copy of NoticeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoticeDtoImplCopyWith<_$NoticeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

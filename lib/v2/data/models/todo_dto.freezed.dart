// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TodoDto _$TodoDtoFromJson(Map<String, dynamic> json) {
  return _TodoDto.fromJson(json);
}

/// @nodoc
mixin _$TodoDto {
  String get todoId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get courseId => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  int get remind => throw _privateConstructorUsedError;
  int get remindType => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  int get createTime => throw _privateConstructorUsedError;
  Map<String, dynamic> get extras => throw _privateConstructorUsedError;

  /// Serializes this TodoDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodoDtoCopyWith<TodoDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoDtoCopyWith<$Res> {
  factory $TodoDtoCopyWith(TodoDto value, $Res Function(TodoDto) then) =
      _$TodoDtoCopyWithImpl<$Res, TodoDto>;
  @useResult
  $Res call({
    String todoId,
    String title,
    String content,
    String courseId,
    String endTime,
    int remind,
    int remindType,
    bool isCompleted,
    int createTime,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class _$TodoDtoCopyWithImpl<$Res, $Val extends TodoDto>
    implements $TodoDtoCopyWith<$Res> {
  _$TodoDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todoId = null,
    Object? title = null,
    Object? content = null,
    Object? courseId = null,
    Object? endTime = null,
    Object? remind = null,
    Object? remindType = null,
    Object? isCompleted = null,
    Object? createTime = null,
    Object? extras = null,
  }) {
    return _then(
      _value.copyWith(
            todoId: null == todoId
                ? _value.todoId
                : todoId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as String,
            remind: null == remind
                ? _value.remind
                : remind // ignore: cast_nullable_to_non_nullable
                      as int,
            remindType: null == remindType
                ? _value.remindType
                : remindType // ignore: cast_nullable_to_non_nullable
                      as int,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            createTime: null == createTime
                ? _value.createTime
                : createTime // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$TodoDtoImplCopyWith<$Res> implements $TodoDtoCopyWith<$Res> {
  factory _$$TodoDtoImplCopyWith(
    _$TodoDtoImpl value,
    $Res Function(_$TodoDtoImpl) then,
  ) = __$$TodoDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String todoId,
    String title,
    String content,
    String courseId,
    String endTime,
    int remind,
    int remindType,
    bool isCompleted,
    int createTime,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class __$$TodoDtoImplCopyWithImpl<$Res>
    extends _$TodoDtoCopyWithImpl<$Res, _$TodoDtoImpl>
    implements _$$TodoDtoImplCopyWith<$Res> {
  __$$TodoDtoImplCopyWithImpl(
    _$TodoDtoImpl _value,
    $Res Function(_$TodoDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todoId = null,
    Object? title = null,
    Object? content = null,
    Object? courseId = null,
    Object? endTime = null,
    Object? remind = null,
    Object? remindType = null,
    Object? isCompleted = null,
    Object? createTime = null,
    Object? extras = null,
  }) {
    return _then(
      _$TodoDtoImpl(
        todoId: null == todoId
            ? _value.todoId
            : todoId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as String,
        remind: null == remind
            ? _value.remind
            : remind // ignore: cast_nullable_to_non_nullable
                  as int,
        remindType: null == remindType
            ? _value.remindType
            : remindType // ignore: cast_nullable_to_non_nullable
                  as int,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        createTime: null == createTime
            ? _value.createTime
            : createTime // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$TodoDtoImpl implements _TodoDto {
  const _$TodoDtoImpl({
    this.todoId = '',
    this.title = '',
    this.content = '',
    this.courseId = '',
    this.endTime = '',
    this.remind = 0,
    this.remindType = 0,
    this.isCompleted = false,
    this.createTime = 0,
    final Map<String, dynamic> extras = const {},
  }) : _extras = extras;

  factory _$TodoDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodoDtoImplFromJson(json);

  @override
  @JsonKey()
  final String todoId;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String courseId;
  @override
  @JsonKey()
  final String endTime;
  @override
  @JsonKey()
  final int remind;
  @override
  @JsonKey()
  final int remindType;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  @JsonKey()
  final int createTime;
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
    return 'TodoDto(todoId: $todoId, title: $title, content: $content, courseId: $courseId, endTime: $endTime, remind: $remind, remindType: $remindType, isCompleted: $isCompleted, createTime: $createTime, extras: $extras)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodoDtoImpl &&
            (identical(other.todoId, todoId) || other.todoId == todoId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.remind, remind) || other.remind == remind) &&
            (identical(other.remindType, remindType) ||
                other.remindType == remindType) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    todoId,
    title,
    content,
    courseId,
    endTime,
    remind,
    remindType,
    isCompleted,
    createTime,
    const DeepCollectionEquality().hash(_extras),
  );

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoDtoImplCopyWith<_$TodoDtoImpl> get copyWith =>
      __$$TodoDtoImplCopyWithImpl<_$TodoDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodoDtoImplToJson(this);
  }
}

abstract class _TodoDto implements TodoDto {
  const factory _TodoDto({
    final String todoId,
    final String title,
    final String content,
    final String courseId,
    final String endTime,
    final int remind,
    final int remindType,
    final bool isCompleted,
    final int createTime,
    final Map<String, dynamic> extras,
  }) = _$TodoDtoImpl;

  factory _TodoDto.fromJson(Map<String, dynamic> json) = _$TodoDtoImpl.fromJson;

  @override
  String get todoId;
  @override
  String get title;
  @override
  String get content;
  @override
  String get courseId;
  @override
  String get endTime;
  @override
  int get remind;
  @override
  int get remindType;
  @override
  bool get isCompleted;
  @override
  int get createTime;
  @override
  Map<String, dynamic> get extras;

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodoDtoImplCopyWith<_$TodoDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

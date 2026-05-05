// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

QuizDto _$QuizDtoFromJson(Map<String, dynamic> json) {
  return _QuizDto.fromJson(json);
}

/// @nodoc
mixin _$QuizDto {
  String get quizId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get type => throw _privateConstructorUsedError;
  int get startTime => throw _privateConstructorUsedError;
  int get endTime => throw _privateConstructorUsedError;
  bool get isAnswer => throw _privateConstructorUsedError;
  int get questionCount => throw _privateConstructorUsedError;
  Map<String, dynamic> get extras => throw _privateConstructorUsedError;

  /// Serializes this QuizDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizDtoCopyWith<QuizDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizDtoCopyWith<$Res> {
  factory $QuizDtoCopyWith(QuizDto value, $Res Function(QuizDto) then) =
      _$QuizDtoCopyWithImpl<$Res, QuizDto>;
  @useResult
  $Res call({
    String quizId,
    String title,
    String description,
    int type,
    int startTime,
    int endTime,
    bool isAnswer,
    int questionCount,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class _$QuizDtoCopyWithImpl<$Res, $Val extends QuizDto>
    implements $QuizDtoCopyWith<$Res> {
  _$QuizDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizId = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAnswer = null,
    Object? questionCount = null,
    Object? extras = null,
  }) {
    return _then(
      _value.copyWith(
            quizId: null == quizId
                ? _value.quizId
                : quizId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as int,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as int,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as int,
            isAnswer: null == isAnswer
                ? _value.isAnswer
                : isAnswer // ignore: cast_nullable_to_non_nullable
                      as bool,
            questionCount: null == questionCount
                ? _value.questionCount
                : questionCount // ignore: cast_nullable_to_non_nullable
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
abstract class _$$QuizDtoImplCopyWith<$Res> implements $QuizDtoCopyWith<$Res> {
  factory _$$QuizDtoImplCopyWith(
    _$QuizDtoImpl value,
    $Res Function(_$QuizDtoImpl) then,
  ) = __$$QuizDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String quizId,
    String title,
    String description,
    int type,
    int startTime,
    int endTime,
    bool isAnswer,
    int questionCount,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class __$$QuizDtoImplCopyWithImpl<$Res>
    extends _$QuizDtoCopyWithImpl<$Res, _$QuizDtoImpl>
    implements _$$QuizDtoImplCopyWith<$Res> {
  __$$QuizDtoImplCopyWithImpl(
    _$QuizDtoImpl _value,
    $Res Function(_$QuizDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quizId = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAnswer = null,
    Object? questionCount = null,
    Object? extras = null,
  }) {
    return _then(
      _$QuizDtoImpl(
        quizId: null == quizId
            ? _value.quizId
            : quizId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as int,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as int,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as int,
        isAnswer: null == isAnswer
            ? _value.isAnswer
            : isAnswer // ignore: cast_nullable_to_non_nullable
                  as bool,
        questionCount: null == questionCount
            ? _value.questionCount
            : questionCount // ignore: cast_nullable_to_non_nullable
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
class _$QuizDtoImpl implements _QuizDto {
  const _$QuizDtoImpl({
    this.quizId = '',
    this.title = '',
    this.description = '',
    this.type = 0,
    this.startTime = 0,
    this.endTime = 0,
    this.isAnswer = false,
    this.questionCount = 0,
    final Map<String, dynamic> extras = const {},
  }) : _extras = extras;

  factory _$QuizDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizDtoImplFromJson(json);

  @override
  @JsonKey()
  final String quizId;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final int type;
  @override
  @JsonKey()
  final int startTime;
  @override
  @JsonKey()
  final int endTime;
  @override
  @JsonKey()
  final bool isAnswer;
  @override
  @JsonKey()
  final int questionCount;
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
    return 'QuizDto(quizId: $quizId, title: $title, description: $description, type: $type, startTime: $startTime, endTime: $endTime, isAnswer: $isAnswer, questionCount: $questionCount, extras: $extras)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizDtoImpl &&
            (identical(other.quizId, quizId) || other.quizId == quizId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isAnswer, isAnswer) ||
                other.isAnswer == isAnswer) &&
            (identical(other.questionCount, questionCount) ||
                other.questionCount == questionCount) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    quizId,
    title,
    description,
    type,
    startTime,
    endTime,
    isAnswer,
    questionCount,
    const DeepCollectionEquality().hash(_extras),
  );

  /// Create a copy of QuizDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizDtoImplCopyWith<_$QuizDtoImpl> get copyWith =>
      __$$QuizDtoImplCopyWithImpl<_$QuizDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizDtoImplToJson(this);
  }
}

abstract class _QuizDto implements QuizDto {
  const factory _QuizDto({
    final String quizId,
    final String title,
    final String description,
    final int type,
    final int startTime,
    final int endTime,
    final bool isAnswer,
    final int questionCount,
    final Map<String, dynamic> extras,
  }) = _$QuizDtoImpl;

  factory _QuizDto.fromJson(Map<String, dynamic> json) = _$QuizDtoImpl.fromJson;

  @override
  String get quizId;
  @override
  String get title;
  @override
  String get description;
  @override
  int get type;
  @override
  int get startTime;
  @override
  int get endTime;
  @override
  bool get isAnswer;
  @override
  int get questionCount;
  @override
  Map<String, dynamic> get extras;

  /// Create a copy of QuizDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizDtoImplCopyWith<_$QuizDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

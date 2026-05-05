// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExamDto _$ExamDtoFromJson(Map<String, dynamic> json) {
  return _ExamDto.fromJson(json);
}

/// @nodoc
mixin _$ExamDto {
  String get examId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get startTime => throw _privateConstructorUsedError;
  int get endTime => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get totalScore => throw _privateConstructorUsedError;
  int get passScore => throw _privateConstructorUsedError;
  int get questionCount => throw _privateConstructorUsedError;
  Map<String, dynamic> get extras => throw _privateConstructorUsedError;

  /// Serializes this ExamDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExamDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExamDtoCopyWith<ExamDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamDtoCopyWith<$Res> {
  factory $ExamDtoCopyWith(ExamDto value, $Res Function(ExamDto) then) =
      _$ExamDtoCopyWithImpl<$Res, ExamDto>;
  @useResult
  $Res call({
    String examId,
    String title,
    String description,
    int startTime,
    int endTime,
    int duration,
    String status,
    int totalScore,
    int passScore,
    int questionCount,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class _$ExamDtoCopyWithImpl<$Res, $Val extends ExamDto>
    implements $ExamDtoCopyWith<$Res> {
  _$ExamDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExamDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? examId = null,
    Object? title = null,
    Object? description = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? duration = null,
    Object? status = null,
    Object? totalScore = null,
    Object? passScore = null,
    Object? questionCount = null,
    Object? extras = null,
  }) {
    return _then(
      _value.copyWith(
            examId: null == examId
                ? _value.examId
                : examId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as int,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as int,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            totalScore: null == totalScore
                ? _value.totalScore
                : totalScore // ignore: cast_nullable_to_non_nullable
                      as int,
            passScore: null == passScore
                ? _value.passScore
                : passScore // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$ExamDtoImplCopyWith<$Res> implements $ExamDtoCopyWith<$Res> {
  factory _$$ExamDtoImplCopyWith(
    _$ExamDtoImpl value,
    $Res Function(_$ExamDtoImpl) then,
  ) = __$$ExamDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String examId,
    String title,
    String description,
    int startTime,
    int endTime,
    int duration,
    String status,
    int totalScore,
    int passScore,
    int questionCount,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class __$$ExamDtoImplCopyWithImpl<$Res>
    extends _$ExamDtoCopyWithImpl<$Res, _$ExamDtoImpl>
    implements _$$ExamDtoImplCopyWith<$Res> {
  __$$ExamDtoImplCopyWithImpl(
    _$ExamDtoImpl _value,
    $Res Function(_$ExamDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExamDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? examId = null,
    Object? title = null,
    Object? description = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? duration = null,
    Object? status = null,
    Object? totalScore = null,
    Object? passScore = null,
    Object? questionCount = null,
    Object? extras = null,
  }) {
    return _then(
      _$ExamDtoImpl(
        examId: null == examId
            ? _value.examId
            : examId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as int,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as int,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        totalScore: null == totalScore
            ? _value.totalScore
            : totalScore // ignore: cast_nullable_to_non_nullable
                  as int,
        passScore: null == passScore
            ? _value.passScore
            : passScore // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$ExamDtoImpl implements _ExamDto {
  const _$ExamDtoImpl({
    this.examId = '',
    this.title = '',
    this.description = '',
    this.startTime = 0,
    this.endTime = 0,
    this.duration = 0,
    this.status = '',
    this.totalScore = 0,
    this.passScore = 0,
    this.questionCount = 0,
    final Map<String, dynamic> extras = const {},
  }) : _extras = extras;

  factory _$ExamDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamDtoImplFromJson(json);

  @override
  @JsonKey()
  final String examId;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final int startTime;
  @override
  @JsonKey()
  final int endTime;
  @override
  @JsonKey()
  final int duration;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final int totalScore;
  @override
  @JsonKey()
  final int passScore;
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
    return 'ExamDto(examId: $examId, title: $title, description: $description, startTime: $startTime, endTime: $endTime, duration: $duration, status: $status, totalScore: $totalScore, passScore: $passScore, questionCount: $questionCount, extras: $extras)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamDtoImpl &&
            (identical(other.examId, examId) || other.examId == examId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.passScore, passScore) ||
                other.passScore == passScore) &&
            (identical(other.questionCount, questionCount) ||
                other.questionCount == questionCount) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    examId,
    title,
    description,
    startTime,
    endTime,
    duration,
    status,
    totalScore,
    passScore,
    questionCount,
    const DeepCollectionEquality().hash(_extras),
  );

  /// Create a copy of ExamDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamDtoImplCopyWith<_$ExamDtoImpl> get copyWith =>
      __$$ExamDtoImplCopyWithImpl<_$ExamDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamDtoImplToJson(this);
  }
}

abstract class _ExamDto implements ExamDto {
  const factory _ExamDto({
    final String examId,
    final String title,
    final String description,
    final int startTime,
    final int endTime,
    final int duration,
    final String status,
    final int totalScore,
    final int passScore,
    final int questionCount,
    final Map<String, dynamic> extras,
  }) = _$ExamDtoImpl;

  factory _ExamDto.fromJson(Map<String, dynamic> json) = _$ExamDtoImpl.fromJson;

  @override
  String get examId;
  @override
  String get title;
  @override
  String get description;
  @override
  int get startTime;
  @override
  int get endTime;
  @override
  int get duration;
  @override
  String get status;
  @override
  int get totalScore;
  @override
  int get passScore;
  @override
  int get questionCount;
  @override
  Map<String, dynamic> get extras;

  /// Create a copy of ExamDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExamDtoImplCopyWith<_$ExamDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

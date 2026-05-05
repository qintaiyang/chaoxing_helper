// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signin_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SignInDto _$SignInDtoFromJson(Map<String, dynamic> json) {
  return _SignInDto.fromJson(json);
}

/// @nodoc
mixin _$SignInDto {
  String get result => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String get activeId => throw _privateConstructorUsedError;
  String get courseId => throw _privateConstructorUsedError;
  int get signType => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  /// Serializes this SignInDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SignInDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignInDtoCopyWith<SignInDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignInDtoCopyWith<$Res> {
  factory $SignInDtoCopyWith(SignInDto value, $Res Function(SignInDto) then) =
      _$SignInDtoCopyWithImpl<$Res, SignInDto>;
  @useResult
  $Res call({
    String result,
    String message,
    bool success,
    String activeId,
    String courseId,
    int signType,
    String address,
    double latitude,
    double longitude,
  });
}

/// @nodoc
class _$SignInDtoCopyWithImpl<$Res, $Val extends SignInDto>
    implements $SignInDtoCopyWith<$Res> {
  _$SignInDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignInDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? message = null,
    Object? success = null,
    Object? activeId = null,
    Object? courseId = null,
    Object? signType = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(
      _value.copyWith(
            result: null == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as String,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            success: null == success
                ? _value.success
                : success // ignore: cast_nullable_to_non_nullable
                      as bool,
            activeId: null == activeId
                ? _value.activeId
                : activeId // ignore: cast_nullable_to_non_nullable
                      as String,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            signType: null == signType
                ? _value.signType
                : signType // ignore: cast_nullable_to_non_nullable
                      as int,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SignInDtoImplCopyWith<$Res>
    implements $SignInDtoCopyWith<$Res> {
  factory _$$SignInDtoImplCopyWith(
    _$SignInDtoImpl value,
    $Res Function(_$SignInDtoImpl) then,
  ) = __$$SignInDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String result,
    String message,
    bool success,
    String activeId,
    String courseId,
    int signType,
    String address,
    double latitude,
    double longitude,
  });
}

/// @nodoc
class __$$SignInDtoImplCopyWithImpl<$Res>
    extends _$SignInDtoCopyWithImpl<$Res, _$SignInDtoImpl>
    implements _$$SignInDtoImplCopyWith<$Res> {
  __$$SignInDtoImplCopyWithImpl(
    _$SignInDtoImpl _value,
    $Res Function(_$SignInDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SignInDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? message = null,
    Object? success = null,
    Object? activeId = null,
    Object? courseId = null,
    Object? signType = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(
      _$SignInDtoImpl(
        result: null == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                  as String,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        success: null == success
            ? _value.success
            : success // ignore: cast_nullable_to_non_nullable
                  as bool,
        activeId: null == activeId
            ? _value.activeId
            : activeId // ignore: cast_nullable_to_non_nullable
                  as String,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        signType: null == signType
            ? _value.signType
            : signType // ignore: cast_nullable_to_non_nullable
                  as int,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SignInDtoImpl implements _SignInDto {
  const _$SignInDtoImpl({
    this.result = '',
    this.message = '',
    this.success = false,
    this.activeId = '',
    this.courseId = '',
    this.signType = 0,
    this.address = '',
    this.latitude = 0,
    this.longitude = 0,
  });

  factory _$SignInDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignInDtoImplFromJson(json);

  @override
  @JsonKey()
  final String result;
  @override
  @JsonKey()
  final String message;
  @override
  @JsonKey()
  final bool success;
  @override
  @JsonKey()
  final String activeId;
  @override
  @JsonKey()
  final String courseId;
  @override
  @JsonKey()
  final int signType;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final double latitude;
  @override
  @JsonKey()
  final double longitude;

  @override
  String toString() {
    return 'SignInDto(result: $result, message: $message, success: $success, activeId: $activeId, courseId: $courseId, signType: $signType, address: $address, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInDtoImpl &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.activeId, activeId) ||
                other.activeId == activeId) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.signType, signType) ||
                other.signType == signType) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    result,
    message,
    success,
    activeId,
    courseId,
    signType,
    address,
    latitude,
    longitude,
  );

  /// Create a copy of SignInDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignInDtoImplCopyWith<_$SignInDtoImpl> get copyWith =>
      __$$SignInDtoImplCopyWithImpl<_$SignInDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignInDtoImplToJson(this);
  }
}

abstract class _SignInDto implements SignInDto {
  const factory _SignInDto({
    final String result,
    final String message,
    final bool success,
    final String activeId,
    final String courseId,
    final int signType,
    final String address,
    final double latitude,
    final double longitude,
  }) = _$SignInDtoImpl;

  factory _SignInDto.fromJson(Map<String, dynamic> json) =
      _$SignInDtoImpl.fromJson;

  @override
  String get result;
  @override
  String get message;
  @override
  bool get success;
  @override
  String get activeId;
  @override
  String get courseId;
  @override
  int get signType;
  @override
  String get address;
  @override
  double get latitude;
  @override
  double get longitude;

  /// Create a copy of SignInDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignInDtoImplCopyWith<_$SignInDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

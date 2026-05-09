// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message) storage,
    required TResult Function(String message, Object? error) unknown,
    required TResult Function(String message) imageProcessing,
    required TResult Function(String message) iconSwitchFailed,
    required TResult Function(String message) splashUpdateFailed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message)? storage,
    TResult? Function(String message, Object? error)? unknown,
    TResult? Function(String message)? imageProcessing,
    TResult? Function(String message)? iconSwitchFailed,
    TResult? Function(String message)? splashUpdateFailed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message)? storage,
    TResult Function(String message, Object? error)? unknown,
    TResult Function(String message)? imageProcessing,
    TResult Function(String message)? iconSwitchFailed,
    TResult Function(String message)? splashUpdateFailed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(BusinessFailure value) business,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(UnknownFailure value) unknown,
    required TResult Function(ImageProcessingFailure value) imageProcessing,
    required TResult Function(IconSwitchFailed value) iconSwitchFailed,
    required TResult Function(SplashUpdateFailed value) splashUpdateFailed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(BusinessFailure value)? business,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(UnknownFailure value)? unknown,
    TResult? Function(ImageProcessingFailure value)? imageProcessing,
    TResult? Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult? Function(SplashUpdateFailed value)? splashUpdateFailed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(BusinessFailure value)? business,
    TResult Function(StorageFailure value)? storage,
    TResult Function(UnknownFailure value)? unknown,
    TResult Function(ImageProcessingFailure value)? imageProcessing,
    TResult Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult Function(SplashUpdateFailed value)? splashUpdateFailed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NetworkFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NetworkFailureImplCopyWith(
    _$NetworkFailureImpl value,
    $Res Function(_$NetworkFailureImpl) then,
  ) = __$$NetworkFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? statusCode});
}

/// @nodoc
class __$$NetworkFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NetworkFailureImpl>
    implements _$$NetworkFailureImplCopyWith<$Res> {
  __$$NetworkFailureImplCopyWithImpl(
    _$NetworkFailureImpl _value,
    $Res Function(_$NetworkFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? statusCode = freezed}) {
    return _then(
      _$NetworkFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        statusCode: freezed == statusCode
            ? _value.statusCode
            : statusCode // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc

class _$NetworkFailureImpl implements NetworkFailure {
  const _$NetworkFailureImpl({required this.message, this.statusCode});

  @override
  final String message;
  @override
  final int? statusCode;

  @override
  String toString() {
    return 'Failure.network(message: $message, statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      __$$NetworkFailureImplCopyWithImpl<_$NetworkFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message) storage,
    required TResult Function(String message, Object? error) unknown,
    required TResult Function(String message) imageProcessing,
    required TResult Function(String message) iconSwitchFailed,
    required TResult Function(String message) splashUpdateFailed,
  }) {
    return network(message, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message)? storage,
    TResult? Function(String message, Object? error)? unknown,
    TResult? Function(String message)? imageProcessing,
    TResult? Function(String message)? iconSwitchFailed,
    TResult? Function(String message)? splashUpdateFailed,
  }) {
    return network?.call(message, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message)? storage,
    TResult Function(String message, Object? error)? unknown,
    TResult Function(String message)? imageProcessing,
    TResult Function(String message)? iconSwitchFailed,
    TResult Function(String message)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message, statusCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(BusinessFailure value) business,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(UnknownFailure value) unknown,
    required TResult Function(ImageProcessingFailure value) imageProcessing,
    required TResult Function(IconSwitchFailed value) iconSwitchFailed,
    required TResult Function(SplashUpdateFailed value) splashUpdateFailed,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(BusinessFailure value)? business,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(UnknownFailure value)? unknown,
    TResult? Function(ImageProcessingFailure value)? imageProcessing,
    TResult? Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult? Function(SplashUpdateFailed value)? splashUpdateFailed,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(BusinessFailure value)? business,
    TResult Function(StorageFailure value)? storage,
    TResult Function(UnknownFailure value)? unknown,
    TResult Function(ImageProcessingFailure value)? imageProcessing,
    TResult Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult Function(SplashUpdateFailed value)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkFailure implements Failure {
  const factory NetworkFailure({
    required final String message,
    final int? statusCode,
  }) = _$NetworkFailureImpl;

  @override
  String get message;
  int? get statusCode;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NetworkFailureImplCopyWith<_$NetworkFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$AuthFailureImplCopyWith(
    _$AuthFailureImpl value,
    $Res Function(_$AuthFailureImpl) then,
  ) = __$$AuthFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AuthFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$AuthFailureImpl>
    implements _$$AuthFailureImplCopyWith<$Res> {
  __$$AuthFailureImplCopyWithImpl(
    _$AuthFailureImpl _value,
    $Res Function(_$AuthFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$AuthFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$AuthFailureImpl implements AuthFailure {
  const _$AuthFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.auth(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthFailureImplCopyWith<_$AuthFailureImpl> get copyWith =>
      __$$AuthFailureImplCopyWithImpl<_$AuthFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message) storage,
    required TResult Function(String message, Object? error) unknown,
    required TResult Function(String message) imageProcessing,
    required TResult Function(String message) iconSwitchFailed,
    required TResult Function(String message) splashUpdateFailed,
  }) {
    return auth(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message)? storage,
    TResult? Function(String message, Object? error)? unknown,
    TResult? Function(String message)? imageProcessing,
    TResult? Function(String message)? iconSwitchFailed,
    TResult? Function(String message)? splashUpdateFailed,
  }) {
    return auth?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message)? storage,
    TResult Function(String message, Object? error)? unknown,
    TResult Function(String message)? imageProcessing,
    TResult Function(String message)? iconSwitchFailed,
    TResult Function(String message)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(BusinessFailure value) business,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(UnknownFailure value) unknown,
    required TResult Function(ImageProcessingFailure value) imageProcessing,
    required TResult Function(IconSwitchFailed value) iconSwitchFailed,
    required TResult Function(SplashUpdateFailed value) splashUpdateFailed,
  }) {
    return auth(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(BusinessFailure value)? business,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(UnknownFailure value)? unknown,
    TResult? Function(ImageProcessingFailure value)? imageProcessing,
    TResult? Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult? Function(SplashUpdateFailed value)? splashUpdateFailed,
  }) {
    return auth?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(BusinessFailure value)? business,
    TResult Function(StorageFailure value)? storage,
    TResult Function(UnknownFailure value)? unknown,
    TResult Function(ImageProcessingFailure value)? imageProcessing,
    TResult Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult Function(SplashUpdateFailed value)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (auth != null) {
      return auth(this);
    }
    return orElse();
  }
}

abstract class AuthFailure implements Failure {
  const factory AuthFailure({required final String message}) =
      _$AuthFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthFailureImplCopyWith<_$AuthFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BusinessFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$BusinessFailureImplCopyWith(
    _$BusinessFailureImpl value,
    $Res Function(_$BusinessFailureImpl) then,
  ) = __$$BusinessFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? code});
}

/// @nodoc
class __$$BusinessFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$BusinessFailureImpl>
    implements _$$BusinessFailureImplCopyWith<$Res> {
  __$$BusinessFailureImplCopyWithImpl(
    _$BusinessFailureImpl _value,
    $Res Function(_$BusinessFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? code = freezed}) {
    return _then(
      _$BusinessFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        code: freezed == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$BusinessFailureImpl implements BusinessFailure {
  const _$BusinessFailureImpl({required this.message, this.code});

  @override
  final String message;
  @override
  final String? code;

  @override
  String toString() {
    return 'Failure.business(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessFailureImplCopyWith<_$BusinessFailureImpl> get copyWith =>
      __$$BusinessFailureImplCopyWithImpl<_$BusinessFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message) storage,
    required TResult Function(String message, Object? error) unknown,
    required TResult Function(String message) imageProcessing,
    required TResult Function(String message) iconSwitchFailed,
    required TResult Function(String message) splashUpdateFailed,
  }) {
    return business(message, code);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message)? storage,
    TResult? Function(String message, Object? error)? unknown,
    TResult? Function(String message)? imageProcessing,
    TResult? Function(String message)? iconSwitchFailed,
    TResult? Function(String message)? splashUpdateFailed,
  }) {
    return business?.call(message, code);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message)? storage,
    TResult Function(String message, Object? error)? unknown,
    TResult Function(String message)? imageProcessing,
    TResult Function(String message)? iconSwitchFailed,
    TResult Function(String message)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (business != null) {
      return business(message, code);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(BusinessFailure value) business,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(UnknownFailure value) unknown,
    required TResult Function(ImageProcessingFailure value) imageProcessing,
    required TResult Function(IconSwitchFailed value) iconSwitchFailed,
    required TResult Function(SplashUpdateFailed value) splashUpdateFailed,
  }) {
    return business(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(BusinessFailure value)? business,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(UnknownFailure value)? unknown,
    TResult? Function(ImageProcessingFailure value)? imageProcessing,
    TResult? Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult? Function(SplashUpdateFailed value)? splashUpdateFailed,
  }) {
    return business?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(BusinessFailure value)? business,
    TResult Function(StorageFailure value)? storage,
    TResult Function(UnknownFailure value)? unknown,
    TResult Function(ImageProcessingFailure value)? imageProcessing,
    TResult Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult Function(SplashUpdateFailed value)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (business != null) {
      return business(this);
    }
    return orElse();
  }
}

abstract class BusinessFailure implements Failure {
  const factory BusinessFailure({
    required final String message,
    final String? code,
  }) = _$BusinessFailureImpl;

  @override
  String get message;
  String? get code;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessFailureImplCopyWith<_$BusinessFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StorageFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$StorageFailureImplCopyWith(
    _$StorageFailureImpl value,
    $Res Function(_$StorageFailureImpl) then,
  ) = __$$StorageFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$StorageFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$StorageFailureImpl>
    implements _$$StorageFailureImplCopyWith<$Res> {
  __$$StorageFailureImplCopyWithImpl(
    _$StorageFailureImpl _value,
    $Res Function(_$StorageFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$StorageFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$StorageFailureImpl implements StorageFailure {
  const _$StorageFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.storage(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StorageFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      __$$StorageFailureImplCopyWithImpl<_$StorageFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message) storage,
    required TResult Function(String message, Object? error) unknown,
    required TResult Function(String message) imageProcessing,
    required TResult Function(String message) iconSwitchFailed,
    required TResult Function(String message) splashUpdateFailed,
  }) {
    return storage(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message)? storage,
    TResult? Function(String message, Object? error)? unknown,
    TResult? Function(String message)? imageProcessing,
    TResult? Function(String message)? iconSwitchFailed,
    TResult? Function(String message)? splashUpdateFailed,
  }) {
    return storage?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message)? storage,
    TResult Function(String message, Object? error)? unknown,
    TResult Function(String message)? imageProcessing,
    TResult Function(String message)? iconSwitchFailed,
    TResult Function(String message)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(BusinessFailure value) business,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(UnknownFailure value) unknown,
    required TResult Function(ImageProcessingFailure value) imageProcessing,
    required TResult Function(IconSwitchFailed value) iconSwitchFailed,
    required TResult Function(SplashUpdateFailed value) splashUpdateFailed,
  }) {
    return storage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(BusinessFailure value)? business,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(UnknownFailure value)? unknown,
    TResult? Function(ImageProcessingFailure value)? imageProcessing,
    TResult? Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult? Function(SplashUpdateFailed value)? splashUpdateFailed,
  }) {
    return storage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(BusinessFailure value)? business,
    TResult Function(StorageFailure value)? storage,
    TResult Function(UnknownFailure value)? unknown,
    TResult Function(ImageProcessingFailure value)? imageProcessing,
    TResult Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult Function(SplashUpdateFailed value)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (storage != null) {
      return storage(this);
    }
    return orElse();
  }
}

abstract class StorageFailure implements Failure {
  const factory StorageFailure({required final String message}) =
      _$StorageFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StorageFailureImplCopyWith<_$StorageFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$UnknownFailureImplCopyWith(
    _$UnknownFailureImpl value,
    $Res Function(_$UnknownFailureImpl) then,
  ) = __$$UnknownFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, Object? error});
}

/// @nodoc
class __$$UnknownFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnknownFailureImpl>
    implements _$$UnknownFailureImplCopyWith<$Res> {
  __$$UnknownFailureImplCopyWithImpl(
    _$UnknownFailureImpl _value,
    $Res Function(_$UnknownFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? error = freezed}) {
    return _then(
      _$UnknownFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        error: freezed == error ? _value.error : error,
      ),
    );
  }
}

/// @nodoc

class _$UnknownFailureImpl implements UnknownFailure {
  const _$UnknownFailureImpl({required this.message, this.error});

  @override
  final String message;
  @override
  final Object? error;

  @override
  String toString() {
    return 'Failure.unknown(message: $message, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownFailureImpl &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    message,
    const DeepCollectionEquality().hash(error),
  );

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      __$$UnknownFailureImplCopyWithImpl<_$UnknownFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message) storage,
    required TResult Function(String message, Object? error) unknown,
    required TResult Function(String message) imageProcessing,
    required TResult Function(String message) iconSwitchFailed,
    required TResult Function(String message) splashUpdateFailed,
  }) {
    return unknown(message, error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message)? storage,
    TResult? Function(String message, Object? error)? unknown,
    TResult? Function(String message)? imageProcessing,
    TResult? Function(String message)? iconSwitchFailed,
    TResult? Function(String message)? splashUpdateFailed,
  }) {
    return unknown?.call(message, error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message)? storage,
    TResult Function(String message, Object? error)? unknown,
    TResult Function(String message)? imageProcessing,
    TResult Function(String message)? iconSwitchFailed,
    TResult Function(String message)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message, error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(BusinessFailure value) business,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(UnknownFailure value) unknown,
    required TResult Function(ImageProcessingFailure value) imageProcessing,
    required TResult Function(IconSwitchFailed value) iconSwitchFailed,
    required TResult Function(SplashUpdateFailed value) splashUpdateFailed,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(BusinessFailure value)? business,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(UnknownFailure value)? unknown,
    TResult? Function(ImageProcessingFailure value)? imageProcessing,
    TResult? Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult? Function(SplashUpdateFailed value)? splashUpdateFailed,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(BusinessFailure value)? business,
    TResult Function(StorageFailure value)? storage,
    TResult Function(UnknownFailure value)? unknown,
    TResult Function(ImageProcessingFailure value)? imageProcessing,
    TResult Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult Function(SplashUpdateFailed value)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownFailure implements Failure {
  const factory UnknownFailure({
    required final String message,
    final Object? error,
  }) = _$UnknownFailureImpl;

  @override
  String get message;
  Object? get error;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnknownFailureImplCopyWith<_$UnknownFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ImageProcessingFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ImageProcessingFailureImplCopyWith(
    _$ImageProcessingFailureImpl value,
    $Res Function(_$ImageProcessingFailureImpl) then,
  ) = __$$ImageProcessingFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ImageProcessingFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ImageProcessingFailureImpl>
    implements _$$ImageProcessingFailureImplCopyWith<$Res> {
  __$$ImageProcessingFailureImplCopyWithImpl(
    _$ImageProcessingFailureImpl _value,
    $Res Function(_$ImageProcessingFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ImageProcessingFailureImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ImageProcessingFailureImpl implements ImageProcessingFailure {
  const _$ImageProcessingFailureImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.imageProcessing(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageProcessingFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageProcessingFailureImplCopyWith<_$ImageProcessingFailureImpl>
  get copyWith =>
      __$$ImageProcessingFailureImplCopyWithImpl<_$ImageProcessingFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message) storage,
    required TResult Function(String message, Object? error) unknown,
    required TResult Function(String message) imageProcessing,
    required TResult Function(String message) iconSwitchFailed,
    required TResult Function(String message) splashUpdateFailed,
  }) {
    return imageProcessing(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message)? storage,
    TResult? Function(String message, Object? error)? unknown,
    TResult? Function(String message)? imageProcessing,
    TResult? Function(String message)? iconSwitchFailed,
    TResult? Function(String message)? splashUpdateFailed,
  }) {
    return imageProcessing?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message)? storage,
    TResult Function(String message, Object? error)? unknown,
    TResult Function(String message)? imageProcessing,
    TResult Function(String message)? iconSwitchFailed,
    TResult Function(String message)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (imageProcessing != null) {
      return imageProcessing(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(BusinessFailure value) business,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(UnknownFailure value) unknown,
    required TResult Function(ImageProcessingFailure value) imageProcessing,
    required TResult Function(IconSwitchFailed value) iconSwitchFailed,
    required TResult Function(SplashUpdateFailed value) splashUpdateFailed,
  }) {
    return imageProcessing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(BusinessFailure value)? business,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(UnknownFailure value)? unknown,
    TResult? Function(ImageProcessingFailure value)? imageProcessing,
    TResult? Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult? Function(SplashUpdateFailed value)? splashUpdateFailed,
  }) {
    return imageProcessing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(BusinessFailure value)? business,
    TResult Function(StorageFailure value)? storage,
    TResult Function(UnknownFailure value)? unknown,
    TResult Function(ImageProcessingFailure value)? imageProcessing,
    TResult Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult Function(SplashUpdateFailed value)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (imageProcessing != null) {
      return imageProcessing(this);
    }
    return orElse();
  }
}

abstract class ImageProcessingFailure implements Failure {
  const factory ImageProcessingFailure({required final String message}) =
      _$ImageProcessingFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageProcessingFailureImplCopyWith<_$ImageProcessingFailureImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IconSwitchFailedImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$IconSwitchFailedImplCopyWith(
    _$IconSwitchFailedImpl value,
    $Res Function(_$IconSwitchFailedImpl) then,
  ) = __$$IconSwitchFailedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$IconSwitchFailedImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$IconSwitchFailedImpl>
    implements _$$IconSwitchFailedImplCopyWith<$Res> {
  __$$IconSwitchFailedImplCopyWithImpl(
    _$IconSwitchFailedImpl _value,
    $Res Function(_$IconSwitchFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$IconSwitchFailedImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$IconSwitchFailedImpl implements IconSwitchFailed {
  const _$IconSwitchFailedImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.iconSwitchFailed(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IconSwitchFailedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IconSwitchFailedImplCopyWith<_$IconSwitchFailedImpl> get copyWith =>
      __$$IconSwitchFailedImplCopyWithImpl<_$IconSwitchFailedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message) storage,
    required TResult Function(String message, Object? error) unknown,
    required TResult Function(String message) imageProcessing,
    required TResult Function(String message) iconSwitchFailed,
    required TResult Function(String message) splashUpdateFailed,
  }) {
    return iconSwitchFailed(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message)? storage,
    TResult? Function(String message, Object? error)? unknown,
    TResult? Function(String message)? imageProcessing,
    TResult? Function(String message)? iconSwitchFailed,
    TResult? Function(String message)? splashUpdateFailed,
  }) {
    return iconSwitchFailed?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message)? storage,
    TResult Function(String message, Object? error)? unknown,
    TResult Function(String message)? imageProcessing,
    TResult Function(String message)? iconSwitchFailed,
    TResult Function(String message)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (iconSwitchFailed != null) {
      return iconSwitchFailed(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(BusinessFailure value) business,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(UnknownFailure value) unknown,
    required TResult Function(ImageProcessingFailure value) imageProcessing,
    required TResult Function(IconSwitchFailed value) iconSwitchFailed,
    required TResult Function(SplashUpdateFailed value) splashUpdateFailed,
  }) {
    return iconSwitchFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(BusinessFailure value)? business,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(UnknownFailure value)? unknown,
    TResult? Function(ImageProcessingFailure value)? imageProcessing,
    TResult? Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult? Function(SplashUpdateFailed value)? splashUpdateFailed,
  }) {
    return iconSwitchFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(BusinessFailure value)? business,
    TResult Function(StorageFailure value)? storage,
    TResult Function(UnknownFailure value)? unknown,
    TResult Function(ImageProcessingFailure value)? imageProcessing,
    TResult Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult Function(SplashUpdateFailed value)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (iconSwitchFailed != null) {
      return iconSwitchFailed(this);
    }
    return orElse();
  }
}

abstract class IconSwitchFailed implements Failure {
  const factory IconSwitchFailed({required final String message}) =
      _$IconSwitchFailedImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IconSwitchFailedImplCopyWith<_$IconSwitchFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SplashUpdateFailedImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$SplashUpdateFailedImplCopyWith(
    _$SplashUpdateFailedImpl value,
    $Res Function(_$SplashUpdateFailedImpl) then,
  ) = __$$SplashUpdateFailedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SplashUpdateFailedImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$SplashUpdateFailedImpl>
    implements _$$SplashUpdateFailedImplCopyWith<$Res> {
  __$$SplashUpdateFailedImplCopyWithImpl(
    _$SplashUpdateFailedImpl _value,
    $Res Function(_$SplashUpdateFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$SplashUpdateFailedImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$SplashUpdateFailedImpl implements SplashUpdateFailed {
  const _$SplashUpdateFailedImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.splashUpdateFailed(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplashUpdateFailedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SplashUpdateFailedImplCopyWith<_$SplashUpdateFailedImpl> get copyWith =>
      __$$SplashUpdateFailedImplCopyWithImpl<_$SplashUpdateFailedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode) network,
    required TResult Function(String message) auth,
    required TResult Function(String message, String? code) business,
    required TResult Function(String message) storage,
    required TResult Function(String message, Object? error) unknown,
    required TResult Function(String message) imageProcessing,
    required TResult Function(String message) iconSwitchFailed,
    required TResult Function(String message) splashUpdateFailed,
  }) {
    return splashUpdateFailed(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode)? network,
    TResult? Function(String message)? auth,
    TResult? Function(String message, String? code)? business,
    TResult? Function(String message)? storage,
    TResult? Function(String message, Object? error)? unknown,
    TResult? Function(String message)? imageProcessing,
    TResult? Function(String message)? iconSwitchFailed,
    TResult? Function(String message)? splashUpdateFailed,
  }) {
    return splashUpdateFailed?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode)? network,
    TResult Function(String message)? auth,
    TResult Function(String message, String? code)? business,
    TResult Function(String message)? storage,
    TResult Function(String message, Object? error)? unknown,
    TResult Function(String message)? imageProcessing,
    TResult Function(String message)? iconSwitchFailed,
    TResult Function(String message)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (splashUpdateFailed != null) {
      return splashUpdateFailed(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkFailure value) network,
    required TResult Function(AuthFailure value) auth,
    required TResult Function(BusinessFailure value) business,
    required TResult Function(StorageFailure value) storage,
    required TResult Function(UnknownFailure value) unknown,
    required TResult Function(ImageProcessingFailure value) imageProcessing,
    required TResult Function(IconSwitchFailed value) iconSwitchFailed,
    required TResult Function(SplashUpdateFailed value) splashUpdateFailed,
  }) {
    return splashUpdateFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkFailure value)? network,
    TResult? Function(AuthFailure value)? auth,
    TResult? Function(BusinessFailure value)? business,
    TResult? Function(StorageFailure value)? storage,
    TResult? Function(UnknownFailure value)? unknown,
    TResult? Function(ImageProcessingFailure value)? imageProcessing,
    TResult? Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult? Function(SplashUpdateFailed value)? splashUpdateFailed,
  }) {
    return splashUpdateFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkFailure value)? network,
    TResult Function(AuthFailure value)? auth,
    TResult Function(BusinessFailure value)? business,
    TResult Function(StorageFailure value)? storage,
    TResult Function(UnknownFailure value)? unknown,
    TResult Function(ImageProcessingFailure value)? imageProcessing,
    TResult Function(IconSwitchFailed value)? iconSwitchFailed,
    TResult Function(SplashUpdateFailed value)? splashUpdateFailed,
    required TResult orElse(),
  }) {
    if (splashUpdateFailed != null) {
      return splashUpdateFailed(this);
    }
    return orElse();
  }
}

abstract class SplashUpdateFailed implements Failure {
  const factory SplashUpdateFailed({required final String message}) =
      _$SplashUpdateFailedImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SplashUpdateFailedImplCopyWith<_$SplashUpdateFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

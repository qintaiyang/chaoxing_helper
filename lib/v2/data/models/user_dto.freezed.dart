// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  return _UserDto.fromJson(json);
}

/// @nodoc
mixin _$UserDto {
  String get uid => throw _privateConstructorUsedError;
  String get puid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get avatar => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get school => throw _privateConstructorUsedError;
  String get platform => throw _privateConstructorUsedError;
  ImAccountDto? get imAccount => throw _privateConstructorUsedError;
  bool get status => throw _privateConstructorUsedError;

  /// Serializes this UserDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDtoCopyWith<UserDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDtoCopyWith<$Res> {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) then) =
      _$UserDtoCopyWithImpl<$Res, UserDto>;
  @useResult
  $Res call({
    String uid,
    String puid,
    String name,
    String avatar,
    String phone,
    String school,
    String platform,
    ImAccountDto? imAccount,
    bool status,
  });

  $ImAccountDtoCopyWith<$Res>? get imAccount;
}

/// @nodoc
class _$UserDtoCopyWithImpl<$Res, $Val extends UserDto>
    implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? puid = null,
    Object? name = null,
    Object? avatar = null,
    Object? phone = null,
    Object? school = null,
    Object? platform = null,
    Object? imAccount = freezed,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            puid: null == puid
                ? _value.puid
                : puid // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            avatar: null == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            school: null == school
                ? _value.school
                : school // ignore: cast_nullable_to_non_nullable
                      as String,
            platform: null == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String,
            imAccount: freezed == imAccount
                ? _value.imAccount
                : imAccount // ignore: cast_nullable_to_non_nullable
                      as ImAccountDto?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ImAccountDtoCopyWith<$Res>? get imAccount {
    if (_value.imAccount == null) {
      return null;
    }

    return $ImAccountDtoCopyWith<$Res>(_value.imAccount!, (value) {
      return _then(_value.copyWith(imAccount: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserDtoImplCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$$UserDtoImplCopyWith(
    _$UserDtoImpl value,
    $Res Function(_$UserDtoImpl) then,
  ) = __$$UserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String puid,
    String name,
    String avatar,
    String phone,
    String school,
    String platform,
    ImAccountDto? imAccount,
    bool status,
  });

  @override
  $ImAccountDtoCopyWith<$Res>? get imAccount;
}

/// @nodoc
class __$$UserDtoImplCopyWithImpl<$Res>
    extends _$UserDtoCopyWithImpl<$Res, _$UserDtoImpl>
    implements _$$UserDtoImplCopyWith<$Res> {
  __$$UserDtoImplCopyWithImpl(
    _$UserDtoImpl _value,
    $Res Function(_$UserDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? puid = null,
    Object? name = null,
    Object? avatar = null,
    Object? phone = null,
    Object? school = null,
    Object? platform = null,
    Object? imAccount = freezed,
    Object? status = null,
  }) {
    return _then(
      _$UserDtoImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        puid: null == puid
            ? _value.puid
            : puid // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        avatar: null == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        school: null == school
            ? _value.school
            : school // ignore: cast_nullable_to_non_nullable
                  as String,
        platform: null == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String,
        imAccount: freezed == imAccount
            ? _value.imAccount
            : imAccount // ignore: cast_nullable_to_non_nullable
                  as ImAccountDto?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDtoImpl implements _UserDto {
  const _$UserDtoImpl({
    required this.uid,
    this.puid = '',
    this.name = '未知用户',
    this.avatar = '',
    this.phone = '',
    this.school = '未知学校',
    this.platform = 'chaoxing',
    this.imAccount,
    this.status = true,
  });

  factory _$UserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDtoImplFromJson(json);

  @override
  final String uid;
  @override
  @JsonKey()
  final String puid;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String avatar;
  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey()
  final String school;
  @override
  @JsonKey()
  final String platform;
  @override
  final ImAccountDto? imAccount;
  @override
  @JsonKey()
  final bool status;

  @override
  String toString() {
    return 'UserDto(uid: $uid, puid: $puid, name: $name, avatar: $avatar, phone: $phone, school: $school, platform: $platform, imAccount: $imAccount, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDtoImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.puid, puid) || other.puid == puid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.school, school) || other.school == school) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.imAccount, imAccount) ||
                other.imAccount == imAccount) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    puid,
    name,
    avatar,
    phone,
    school,
    platform,
    imAccount,
    status,
  );

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      __$$UserDtoImplCopyWithImpl<_$UserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDtoImplToJson(this);
  }
}

abstract class _UserDto implements UserDto {
  const factory _UserDto({
    required final String uid,
    final String puid,
    final String name,
    final String avatar,
    final String phone,
    final String school,
    final String platform,
    final ImAccountDto? imAccount,
    final bool status,
  }) = _$UserDtoImpl;

  factory _UserDto.fromJson(Map<String, dynamic> json) = _$UserDtoImpl.fromJson;

  @override
  String get uid;
  @override
  String get puid;
  @override
  String get name;
  @override
  String get avatar;
  @override
  String get phone;
  @override
  String get school;
  @override
  String get platform;
  @override
  ImAccountDto? get imAccount;
  @override
  bool get status;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDtoImplCopyWith<_$UserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ImAccountDto _$ImAccountDtoFromJson(Map<String, dynamic> json) {
  return _ImAccountDto.fromJson(json);
}

/// @nodoc
mixin _$ImAccountDto {
  String get userName => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  /// Serializes this ImAccountDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImAccountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImAccountDtoCopyWith<ImAccountDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImAccountDtoCopyWith<$Res> {
  factory $ImAccountDtoCopyWith(
    ImAccountDto value,
    $Res Function(ImAccountDto) then,
  ) = _$ImAccountDtoCopyWithImpl<$Res, ImAccountDto>;
  @useResult
  $Res call({String userName, String password});
}

/// @nodoc
class _$ImAccountDtoCopyWithImpl<$Res, $Val extends ImAccountDto>
    implements $ImAccountDtoCopyWith<$Res> {
  _$ImAccountDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImAccountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userName = null, Object? password = null}) {
    return _then(
      _value.copyWith(
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ImAccountDtoImplCopyWith<$Res>
    implements $ImAccountDtoCopyWith<$Res> {
  factory _$$ImAccountDtoImplCopyWith(
    _$ImAccountDtoImpl value,
    $Res Function(_$ImAccountDtoImpl) then,
  ) = __$$ImAccountDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userName, String password});
}

/// @nodoc
class __$$ImAccountDtoImplCopyWithImpl<$Res>
    extends _$ImAccountDtoCopyWithImpl<$Res, _$ImAccountDtoImpl>
    implements _$$ImAccountDtoImplCopyWith<$Res> {
  __$$ImAccountDtoImplCopyWithImpl(
    _$ImAccountDtoImpl _value,
    $Res Function(_$ImAccountDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImAccountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? userName = null, Object? password = null}) {
    return _then(
      _$ImAccountDtoImpl(
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ImAccountDtoImpl implements _ImAccountDto {
  const _$ImAccountDtoImpl({required this.userName, required this.password});

  factory _$ImAccountDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImAccountDtoImplFromJson(json);

  @override
  final String userName;
  @override
  final String password;

  @override
  String toString() {
    return 'ImAccountDto(userName: $userName, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImAccountDtoImpl &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userName, password);

  /// Create a copy of ImAccountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImAccountDtoImplCopyWith<_$ImAccountDtoImpl> get copyWith =>
      __$$ImAccountDtoImplCopyWithImpl<_$ImAccountDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImAccountDtoImplToJson(this);
  }
}

abstract class _ImAccountDto implements ImAccountDto {
  const factory _ImAccountDto({
    required final String userName,
    required final String password,
  }) = _$ImAccountDtoImpl;

  factory _ImAccountDto.fromJson(Map<String, dynamic> json) =
      _$ImAccountDtoImpl.fromJson;

  @override
  String get userName;
  @override
  String get password;

  /// Create a copy of ImAccountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImAccountDtoImplCopyWith<_$ImAccountDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

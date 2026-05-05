// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CourseDto _$CourseDtoFromJson(Map<String, dynamic> json) {
  return _CourseDto.fromJson(json);
}

/// @nodoc
mixin _$CourseDto {
  String get courseId => throw _privateConstructorUsedError;
  String get clazzId => throw _privateConstructorUsedError;
  String? get cpi => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get teacher => throw _privateConstructorUsedError;
  bool get state => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String? get schools => throw _privateConstructorUsedError;
  String? get beginDate => throw _privateConstructorUsedError;
  String? get endDate => throw _privateConstructorUsedError;
  String? get lessonId => throw _privateConstructorUsedError;
  CourseSettingsDto? get settings => throw _privateConstructorUsedError;

  /// Serializes this CourseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseDtoCopyWith<CourseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseDtoCopyWith<$Res> {
  factory $CourseDtoCopyWith(CourseDto value, $Res Function(CourseDto) then) =
      _$CourseDtoCopyWithImpl<$Res, CourseDto>;
  @useResult
  $Res call({
    String courseId,
    String clazzId,
    String? cpi,
    String image,
    String name,
    String teacher,
    bool state,
    String? note,
    String? schools,
    String? beginDate,
    String? endDate,
    String? lessonId,
    CourseSettingsDto? settings,
  });

  $CourseSettingsDtoCopyWith<$Res>? get settings;
}

/// @nodoc
class _$CourseDtoCopyWithImpl<$Res, $Val extends CourseDto>
    implements $CourseDtoCopyWith<$Res> {
  _$CourseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = null,
    Object? clazzId = null,
    Object? cpi = freezed,
    Object? image = null,
    Object? name = null,
    Object? teacher = null,
    Object? state = null,
    Object? note = freezed,
    Object? schools = freezed,
    Object? beginDate = freezed,
    Object? endDate = freezed,
    Object? lessonId = freezed,
    Object? settings = freezed,
  }) {
    return _then(
      _value.copyWith(
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            clazzId: null == clazzId
                ? _value.clazzId
                : clazzId // ignore: cast_nullable_to_non_nullable
                      as String,
            cpi: freezed == cpi
                ? _value.cpi
                : cpi // ignore: cast_nullable_to_non_nullable
                      as String?,
            image: null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            teacher: null == teacher
                ? _value.teacher
                : teacher // ignore: cast_nullable_to_non_nullable
                      as String,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as bool,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            schools: freezed == schools
                ? _value.schools
                : schools // ignore: cast_nullable_to_non_nullable
                      as String?,
            beginDate: freezed == beginDate
                ? _value.beginDate
                : beginDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            lessonId: freezed == lessonId
                ? _value.lessonId
                : lessonId // ignore: cast_nullable_to_non_nullable
                      as String?,
            settings: freezed == settings
                ? _value.settings
                : settings // ignore: cast_nullable_to_non_nullable
                      as CourseSettingsDto?,
          )
          as $Val,
    );
  }

  /// Create a copy of CourseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourseSettingsDtoCopyWith<$Res>? get settings {
    if (_value.settings == null) {
      return null;
    }

    return $CourseSettingsDtoCopyWith<$Res>(_value.settings!, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CourseDtoImplCopyWith<$Res>
    implements $CourseDtoCopyWith<$Res> {
  factory _$$CourseDtoImplCopyWith(
    _$CourseDtoImpl value,
    $Res Function(_$CourseDtoImpl) then,
  ) = __$$CourseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String courseId,
    String clazzId,
    String? cpi,
    String image,
    String name,
    String teacher,
    bool state,
    String? note,
    String? schools,
    String? beginDate,
    String? endDate,
    String? lessonId,
    CourseSettingsDto? settings,
  });

  @override
  $CourseSettingsDtoCopyWith<$Res>? get settings;
}

/// @nodoc
class __$$CourseDtoImplCopyWithImpl<$Res>
    extends _$CourseDtoCopyWithImpl<$Res, _$CourseDtoImpl>
    implements _$$CourseDtoImplCopyWith<$Res> {
  __$$CourseDtoImplCopyWithImpl(
    _$CourseDtoImpl _value,
    $Res Function(_$CourseDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = null,
    Object? clazzId = null,
    Object? cpi = freezed,
    Object? image = null,
    Object? name = null,
    Object? teacher = null,
    Object? state = null,
    Object? note = freezed,
    Object? schools = freezed,
    Object? beginDate = freezed,
    Object? endDate = freezed,
    Object? lessonId = freezed,
    Object? settings = freezed,
  }) {
    return _then(
      _$CourseDtoImpl(
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        clazzId: null == clazzId
            ? _value.clazzId
            : clazzId // ignore: cast_nullable_to_non_nullable
                  as String,
        cpi: freezed == cpi
            ? _value.cpi
            : cpi // ignore: cast_nullable_to_non_nullable
                  as String?,
        image: null == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        teacher: null == teacher
            ? _value.teacher
            : teacher // ignore: cast_nullable_to_non_nullable
                  as String,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as bool,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        schools: freezed == schools
            ? _value.schools
            : schools // ignore: cast_nullable_to_non_nullable
                  as String?,
        beginDate: freezed == beginDate
            ? _value.beginDate
            : beginDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        lessonId: freezed == lessonId
            ? _value.lessonId
            : lessonId // ignore: cast_nullable_to_non_nullable
                  as String?,
        settings: freezed == settings
            ? _value.settings
            : settings // ignore: cast_nullable_to_non_nullable
                  as CourseSettingsDto?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseDtoImpl implements _CourseDto {
  const _$CourseDtoImpl({
    this.courseId = '',
    this.clazzId = '',
    this.cpi = '',
    this.image = '',
    this.name = '',
    this.teacher = '',
    this.state = true,
    this.note = '',
    this.schools = '',
    this.beginDate = '',
    this.endDate = '',
    this.lessonId = '',
    this.settings,
  });

  factory _$CourseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseDtoImplFromJson(json);

  @override
  @JsonKey()
  final String courseId;
  @override
  @JsonKey()
  final String clazzId;
  @override
  @JsonKey()
  final String? cpi;
  @override
  @JsonKey()
  final String image;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String teacher;
  @override
  @JsonKey()
  final bool state;
  @override
  @JsonKey()
  final String? note;
  @override
  @JsonKey()
  final String? schools;
  @override
  @JsonKey()
  final String? beginDate;
  @override
  @JsonKey()
  final String? endDate;
  @override
  @JsonKey()
  final String? lessonId;
  @override
  final CourseSettingsDto? settings;

  @override
  String toString() {
    return 'CourseDto(courseId: $courseId, clazzId: $clazzId, cpi: $cpi, image: $image, name: $name, teacher: $teacher, state: $state, note: $note, schools: $schools, beginDate: $beginDate, endDate: $endDate, lessonId: $lessonId, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseDtoImpl &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.clazzId, clazzId) || other.clazzId == clazzId) &&
            (identical(other.cpi, cpi) || other.cpi == cpi) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.teacher, teacher) || other.teacher == teacher) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.schools, schools) || other.schools == schools) &&
            (identical(other.beginDate, beginDate) ||
                other.beginDate == beginDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.lessonId, lessonId) ||
                other.lessonId == lessonId) &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    courseId,
    clazzId,
    cpi,
    image,
    name,
    teacher,
    state,
    note,
    schools,
    beginDate,
    endDate,
    lessonId,
    settings,
  );

  /// Create a copy of CourseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseDtoImplCopyWith<_$CourseDtoImpl> get copyWith =>
      __$$CourseDtoImplCopyWithImpl<_$CourseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseDtoImplToJson(this);
  }
}

abstract class _CourseDto implements CourseDto {
  const factory _CourseDto({
    final String courseId,
    final String clazzId,
    final String? cpi,
    final String image,
    final String name,
    final String teacher,
    final bool state,
    final String? note,
    final String? schools,
    final String? beginDate,
    final String? endDate,
    final String? lessonId,
    final CourseSettingsDto? settings,
  }) = _$CourseDtoImpl;

  factory _CourseDto.fromJson(Map<String, dynamic> json) =
      _$CourseDtoImpl.fromJson;

  @override
  String get courseId;
  @override
  String get clazzId;
  @override
  String? get cpi;
  @override
  String get image;
  @override
  String get name;
  @override
  String get teacher;
  @override
  bool get state;
  @override
  String? get note;
  @override
  String? get schools;
  @override
  String? get beginDate;
  @override
  String? get endDate;
  @override
  String? get lessonId;
  @override
  CourseSettingsDto? get settings;

  /// Create a copy of CourseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseDtoImplCopyWith<_$CourseDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseSettingsDto _$CourseSettingsDtoFromJson(Map<String, dynamic> json) {
  return _CourseSettingsDto.fromJson(json);
}

/// @nodoc
mixin _$CourseSettingsDto {
  CourseLocationDto? get location => throw _privateConstructorUsedError;
  List<String> get imageObjectIds => throw _privateConstructorUsedError;

  /// Serializes this CourseSettingsDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseSettingsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseSettingsDtoCopyWith<CourseSettingsDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseSettingsDtoCopyWith<$Res> {
  factory $CourseSettingsDtoCopyWith(
    CourseSettingsDto value,
    $Res Function(CourseSettingsDto) then,
  ) = _$CourseSettingsDtoCopyWithImpl<$Res, CourseSettingsDto>;
  @useResult
  $Res call({CourseLocationDto? location, List<String> imageObjectIds});

  $CourseLocationDtoCopyWith<$Res>? get location;
}

/// @nodoc
class _$CourseSettingsDtoCopyWithImpl<$Res, $Val extends CourseSettingsDto>
    implements $CourseSettingsDtoCopyWith<$Res> {
  _$CourseSettingsDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseSettingsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? location = freezed, Object? imageObjectIds = null}) {
    return _then(
      _value.copyWith(
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as CourseLocationDto?,
            imageObjectIds: null == imageObjectIds
                ? _value.imageObjectIds
                : imageObjectIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }

  /// Create a copy of CourseSettingsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CourseLocationDtoCopyWith<$Res>? get location {
    if (_value.location == null) {
      return null;
    }

    return $CourseLocationDtoCopyWith<$Res>(_value.location!, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CourseSettingsDtoImplCopyWith<$Res>
    implements $CourseSettingsDtoCopyWith<$Res> {
  factory _$$CourseSettingsDtoImplCopyWith(
    _$CourseSettingsDtoImpl value,
    $Res Function(_$CourseSettingsDtoImpl) then,
  ) = __$$CourseSettingsDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CourseLocationDto? location, List<String> imageObjectIds});

  @override
  $CourseLocationDtoCopyWith<$Res>? get location;
}

/// @nodoc
class __$$CourseSettingsDtoImplCopyWithImpl<$Res>
    extends _$CourseSettingsDtoCopyWithImpl<$Res, _$CourseSettingsDtoImpl>
    implements _$$CourseSettingsDtoImplCopyWith<$Res> {
  __$$CourseSettingsDtoImplCopyWithImpl(
    _$CourseSettingsDtoImpl _value,
    $Res Function(_$CourseSettingsDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseSettingsDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? location = freezed, Object? imageObjectIds = null}) {
    return _then(
      _$CourseSettingsDtoImpl(
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as CourseLocationDto?,
        imageObjectIds: null == imageObjectIds
            ? _value._imageObjectIds
            : imageObjectIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseSettingsDtoImpl implements _CourseSettingsDto {
  const _$CourseSettingsDtoImpl({
    this.location,
    final List<String> imageObjectIds = const [],
  }) : _imageObjectIds = imageObjectIds;

  factory _$CourseSettingsDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseSettingsDtoImplFromJson(json);

  @override
  final CourseLocationDto? location;
  final List<String> _imageObjectIds;
  @override
  @JsonKey()
  List<String> get imageObjectIds {
    if (_imageObjectIds is EqualUnmodifiableListView) return _imageObjectIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageObjectIds);
  }

  @override
  String toString() {
    return 'CourseSettingsDto(location: $location, imageObjectIds: $imageObjectIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseSettingsDtoImpl &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality().equals(
              other._imageObjectIds,
              _imageObjectIds,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    location,
    const DeepCollectionEquality().hash(_imageObjectIds),
  );

  /// Create a copy of CourseSettingsDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseSettingsDtoImplCopyWith<_$CourseSettingsDtoImpl> get copyWith =>
      __$$CourseSettingsDtoImplCopyWithImpl<_$CourseSettingsDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseSettingsDtoImplToJson(this);
  }
}

abstract class _CourseSettingsDto implements CourseSettingsDto {
  const factory _CourseSettingsDto({
    final CourseLocationDto? location,
    final List<String> imageObjectIds,
  }) = _$CourseSettingsDtoImpl;

  factory _CourseSettingsDto.fromJson(Map<String, dynamic> json) =
      _$CourseSettingsDtoImpl.fromJson;

  @override
  CourseLocationDto? get location;
  @override
  List<String> get imageObjectIds;

  /// Create a copy of CourseSettingsDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseSettingsDtoImplCopyWith<_$CourseSettingsDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseLocationDto _$CourseLocationDtoFromJson(Map<String, dynamic> json) {
  return _CourseLocationDto.fromJson(json);
}

/// @nodoc
mixin _$CourseLocationDto {
  String? get classroom => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get latitude => throw _privateConstructorUsedError;
  String get longitude => throw _privateConstructorUsedError;

  /// Serializes this CourseLocationDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseLocationDtoCopyWith<CourseLocationDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseLocationDtoCopyWith<$Res> {
  factory $CourseLocationDtoCopyWith(
    CourseLocationDto value,
    $Res Function(CourseLocationDto) then,
  ) = _$CourseLocationDtoCopyWithImpl<$Res, CourseLocationDto>;
  @useResult
  $Res call({
    String? classroom,
    String address,
    String latitude,
    String longitude,
  });
}

/// @nodoc
class _$CourseLocationDtoCopyWithImpl<$Res, $Val extends CourseLocationDto>
    implements $CourseLocationDtoCopyWith<$Res> {
  _$CourseLocationDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? classroom = freezed,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(
      _value.copyWith(
            classroom: freezed == classroom
                ? _value.classroom
                : classroom // ignore: cast_nullable_to_non_nullable
                      as String?,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as String,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CourseLocationDtoImplCopyWith<$Res>
    implements $CourseLocationDtoCopyWith<$Res> {
  factory _$$CourseLocationDtoImplCopyWith(
    _$CourseLocationDtoImpl value,
    $Res Function(_$CourseLocationDtoImpl) then,
  ) = __$$CourseLocationDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? classroom,
    String address,
    String latitude,
    String longitude,
  });
}

/// @nodoc
class __$$CourseLocationDtoImplCopyWithImpl<$Res>
    extends _$CourseLocationDtoCopyWithImpl<$Res, _$CourseLocationDtoImpl>
    implements _$$CourseLocationDtoImplCopyWith<$Res> {
  __$$CourseLocationDtoImplCopyWithImpl(
    _$CourseLocationDtoImpl _value,
    $Res Function(_$CourseLocationDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? classroom = freezed,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(
      _$CourseLocationDtoImpl(
        classroom: freezed == classroom
            ? _value.classroom
            : classroom // ignore: cast_nullable_to_non_nullable
                  as String?,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as String,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CourseLocationDtoImpl implements _CourseLocationDto {
  const _$CourseLocationDtoImpl({
    this.classroom,
    this.address = '',
    this.latitude = '',
    this.longitude = '',
  });

  factory _$CourseLocationDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseLocationDtoImplFromJson(json);

  @override
  final String? classroom;
  @override
  @JsonKey()
  final String address;
  @override
  @JsonKey()
  final String latitude;
  @override
  @JsonKey()
  final String longitude;

  @override
  String toString() {
    return 'CourseLocationDto(classroom: $classroom, address: $address, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseLocationDtoImpl &&
            (identical(other.classroom, classroom) ||
                other.classroom == classroom) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, classroom, address, latitude, longitude);

  /// Create a copy of CourseLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseLocationDtoImplCopyWith<_$CourseLocationDtoImpl> get copyWith =>
      __$$CourseLocationDtoImplCopyWithImpl<_$CourseLocationDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseLocationDtoImplToJson(this);
  }
}

abstract class _CourseLocationDto implements CourseLocationDto {
  const factory _CourseLocationDto({
    final String? classroom,
    final String address,
    final String latitude,
    final String longitude,
  }) = _$CourseLocationDtoImpl;

  factory _CourseLocationDto.fromJson(Map<String, dynamic> json) =
      _$CourseLocationDtoImpl.fromJson;

  @override
  String? get classroom;
  @override
  String get address;
  @override
  String get latitude;
  @override
  String get longitude;

  /// Create a copy of CourseLocationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseLocationDtoImplCopyWith<_$CourseLocationDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

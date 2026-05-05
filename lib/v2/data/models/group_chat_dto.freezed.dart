// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_chat_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

GroupChatDto _$GroupChatDtoFromJson(Map<String, dynamic> json) {
  return _GroupChatDto.fromJson(json);
}

/// @nodoc
mixin _$GroupChatDto {
  String get chatId => throw _privateConstructorUsedError;
  String get chatName => throw _privateConstructorUsedError;
  String get chatIco => throw _privateConstructorUsedError;
  bool get isGroup => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  int get subFolder => throw _privateConstructorUsedError;
  bool get folder => throw _privateConstructorUsedError;
  int get createTime => throw _privateConstructorUsedError;
  int get updateTime => throw _privateConstructorUsedError;
  List<String> get picArray => throw _privateConstructorUsedError;

  /// Serializes this GroupChatDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupChatDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupChatDtoCopyWith<GroupChatDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupChatDtoCopyWith<$Res> {
  factory $GroupChatDtoCopyWith(
    GroupChatDto value,
    $Res Function(GroupChatDto) then,
  ) = _$GroupChatDtoCopyWithImpl<$Res, GroupChatDto>;
  @useResult
  $Res call({
    String chatId,
    String chatName,
    String chatIco,
    bool isGroup,
    bool isPrivate,
    int count,
    int level,
    int subFolder,
    bool folder,
    int createTime,
    int updateTime,
    List<String> picArray,
  });
}

/// @nodoc
class _$GroupChatDtoCopyWithImpl<$Res, $Val extends GroupChatDto>
    implements $GroupChatDtoCopyWith<$Res> {
  _$GroupChatDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupChatDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatId = null,
    Object? chatName = null,
    Object? chatIco = null,
    Object? isGroup = null,
    Object? isPrivate = null,
    Object? count = null,
    Object? level = null,
    Object? subFolder = null,
    Object? folder = null,
    Object? createTime = null,
    Object? updateTime = null,
    Object? picArray = null,
  }) {
    return _then(
      _value.copyWith(
            chatId: null == chatId
                ? _value.chatId
                : chatId // ignore: cast_nullable_to_non_nullable
                      as String,
            chatName: null == chatName
                ? _value.chatName
                : chatName // ignore: cast_nullable_to_non_nullable
                      as String,
            chatIco: null == chatIco
                ? _value.chatIco
                : chatIco // ignore: cast_nullable_to_non_nullable
                      as String,
            isGroup: null == isGroup
                ? _value.isGroup
                : isGroup // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPrivate: null == isPrivate
                ? _value.isPrivate
                : isPrivate // ignore: cast_nullable_to_non_nullable
                      as bool,
            count: null == count
                ? _value.count
                : count // ignore: cast_nullable_to_non_nullable
                      as int,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as int,
            subFolder: null == subFolder
                ? _value.subFolder
                : subFolder // ignore: cast_nullable_to_non_nullable
                      as int,
            folder: null == folder
                ? _value.folder
                : folder // ignore: cast_nullable_to_non_nullable
                      as bool,
            createTime: null == createTime
                ? _value.createTime
                : createTime // ignore: cast_nullable_to_non_nullable
                      as int,
            updateTime: null == updateTime
                ? _value.updateTime
                : updateTime // ignore: cast_nullable_to_non_nullable
                      as int,
            picArray: null == picArray
                ? _value.picArray
                : picArray // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GroupChatDtoImplCopyWith<$Res>
    implements $GroupChatDtoCopyWith<$Res> {
  factory _$$GroupChatDtoImplCopyWith(
    _$GroupChatDtoImpl value,
    $Res Function(_$GroupChatDtoImpl) then,
  ) = __$$GroupChatDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String chatId,
    String chatName,
    String chatIco,
    bool isGroup,
    bool isPrivate,
    int count,
    int level,
    int subFolder,
    bool folder,
    int createTime,
    int updateTime,
    List<String> picArray,
  });
}

/// @nodoc
class __$$GroupChatDtoImplCopyWithImpl<$Res>
    extends _$GroupChatDtoCopyWithImpl<$Res, _$GroupChatDtoImpl>
    implements _$$GroupChatDtoImplCopyWith<$Res> {
  __$$GroupChatDtoImplCopyWithImpl(
    _$GroupChatDtoImpl _value,
    $Res Function(_$GroupChatDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroupChatDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chatId = null,
    Object? chatName = null,
    Object? chatIco = null,
    Object? isGroup = null,
    Object? isPrivate = null,
    Object? count = null,
    Object? level = null,
    Object? subFolder = null,
    Object? folder = null,
    Object? createTime = null,
    Object? updateTime = null,
    Object? picArray = null,
  }) {
    return _then(
      _$GroupChatDtoImpl(
        chatId: null == chatId
            ? _value.chatId
            : chatId // ignore: cast_nullable_to_non_nullable
                  as String,
        chatName: null == chatName
            ? _value.chatName
            : chatName // ignore: cast_nullable_to_non_nullable
                  as String,
        chatIco: null == chatIco
            ? _value.chatIco
            : chatIco // ignore: cast_nullable_to_non_nullable
                  as String,
        isGroup: null == isGroup
            ? _value.isGroup
            : isGroup // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPrivate: null == isPrivate
            ? _value.isPrivate
            : isPrivate // ignore: cast_nullable_to_non_nullable
                  as bool,
        count: null == count
            ? _value.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as int,
        subFolder: null == subFolder
            ? _value.subFolder
            : subFolder // ignore: cast_nullable_to_non_nullable
                  as int,
        folder: null == folder
            ? _value.folder
            : folder // ignore: cast_nullable_to_non_nullable
                  as bool,
        createTime: null == createTime
            ? _value.createTime
            : createTime // ignore: cast_nullable_to_non_nullable
                  as int,
        updateTime: null == updateTime
            ? _value.updateTime
            : updateTime // ignore: cast_nullable_to_non_nullable
                  as int,
        picArray: null == picArray
            ? _value._picArray
            : picArray // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupChatDtoImpl implements _GroupChatDto {
  const _$GroupChatDtoImpl({
    this.chatId = '',
    this.chatName = '',
    this.chatIco = '',
    this.isGroup = false,
    this.isPrivate = false,
    this.count = 0,
    this.level = 0,
    this.subFolder = 0,
    this.folder = false,
    this.createTime = 0,
    this.updateTime = 0,
    final List<String> picArray = const [],
  }) : _picArray = picArray;

  factory _$GroupChatDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupChatDtoImplFromJson(json);

  @override
  @JsonKey()
  final String chatId;
  @override
  @JsonKey()
  final String chatName;
  @override
  @JsonKey()
  final String chatIco;
  @override
  @JsonKey()
  final bool isGroup;
  @override
  @JsonKey()
  final bool isPrivate;
  @override
  @JsonKey()
  final int count;
  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey()
  final int subFolder;
  @override
  @JsonKey()
  final bool folder;
  @override
  @JsonKey()
  final int createTime;
  @override
  @JsonKey()
  final int updateTime;
  final List<String> _picArray;
  @override
  @JsonKey()
  List<String> get picArray {
    if (_picArray is EqualUnmodifiableListView) return _picArray;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_picArray);
  }

  @override
  String toString() {
    return 'GroupChatDto(chatId: $chatId, chatName: $chatName, chatIco: $chatIco, isGroup: $isGroup, isPrivate: $isPrivate, count: $count, level: $level, subFolder: $subFolder, folder: $folder, createTime: $createTime, updateTime: $updateTime, picArray: $picArray)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupChatDtoImpl &&
            (identical(other.chatId, chatId) || other.chatId == chatId) &&
            (identical(other.chatName, chatName) ||
                other.chatName == chatName) &&
            (identical(other.chatIco, chatIco) || other.chatIco == chatIco) &&
            (identical(other.isGroup, isGroup) || other.isGroup == isGroup) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.subFolder, subFolder) ||
                other.subFolder == subFolder) &&
            (identical(other.folder, folder) || other.folder == folder) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.updateTime, updateTime) ||
                other.updateTime == updateTime) &&
            const DeepCollectionEquality().equals(other._picArray, _picArray));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    chatId,
    chatName,
    chatIco,
    isGroup,
    isPrivate,
    count,
    level,
    subFolder,
    folder,
    createTime,
    updateTime,
    const DeepCollectionEquality().hash(_picArray),
  );

  /// Create a copy of GroupChatDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupChatDtoImplCopyWith<_$GroupChatDtoImpl> get copyWith =>
      __$$GroupChatDtoImplCopyWithImpl<_$GroupChatDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupChatDtoImplToJson(this);
  }
}

abstract class _GroupChatDto implements GroupChatDto {
  const factory _GroupChatDto({
    final String chatId,
    final String chatName,
    final String chatIco,
    final bool isGroup,
    final bool isPrivate,
    final int count,
    final int level,
    final int subFolder,
    final bool folder,
    final int createTime,
    final int updateTime,
    final List<String> picArray,
  }) = _$GroupChatDtoImpl;

  factory _GroupChatDto.fromJson(Map<String, dynamic> json) =
      _$GroupChatDtoImpl.fromJson;

  @override
  String get chatId;
  @override
  String get chatName;
  @override
  String get chatIco;
  @override
  bool get isGroup;
  @override
  bool get isPrivate;
  @override
  int get count;
  @override
  int get level;
  @override
  int get subFolder;
  @override
  bool get folder;
  @override
  int get createTime;
  @override
  int get updateTime;
  @override
  List<String> get picArray;

  /// Create a copy of GroupChatDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupChatDtoImplCopyWith<_$GroupChatDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupMessageDto _$GroupMessageDtoFromJson(Map<String, dynamic> json) {
  return _GroupMessageDto.fromJson(json);
}

/// @nodoc
mixin _$GroupMessageDto {
  String get msgId => throw _privateConstructorUsedError;
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get msgType => throw _privateConstructorUsedError;
  int get timestamp => throw _privateConstructorUsedError;
  Map<String, dynamic> get extras => throw _privateConstructorUsedError;

  /// Serializes this GroupMessageDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupMessageDtoCopyWith<GroupMessageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupMessageDtoCopyWith<$Res> {
  factory $GroupMessageDtoCopyWith(
    GroupMessageDto value,
    $Res Function(GroupMessageDto) then,
  ) = _$GroupMessageDtoCopyWithImpl<$Res, GroupMessageDto>;
  @useResult
  $Res call({
    String msgId,
    String from,
    String to,
    String content,
    String msgType,
    int timestamp,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class _$GroupMessageDtoCopyWithImpl<$Res, $Val extends GroupMessageDto>
    implements $GroupMessageDtoCopyWith<$Res> {
  _$GroupMessageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? msgId = null,
    Object? from = null,
    Object? to = null,
    Object? content = null,
    Object? msgType = null,
    Object? timestamp = null,
    Object? extras = null,
  }) {
    return _then(
      _value.copyWith(
            msgId: null == msgId
                ? _value.msgId
                : msgId // ignore: cast_nullable_to_non_nullable
                      as String,
            from: null == from
                ? _value.from
                : from // ignore: cast_nullable_to_non_nullable
                      as String,
            to: null == to
                ? _value.to
                : to // ignore: cast_nullable_to_non_nullable
                      as String,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            msgType: null == msgType
                ? _value.msgType
                : msgType // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
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
abstract class _$$GroupMessageDtoImplCopyWith<$Res>
    implements $GroupMessageDtoCopyWith<$Res> {
  factory _$$GroupMessageDtoImplCopyWith(
    _$GroupMessageDtoImpl value,
    $Res Function(_$GroupMessageDtoImpl) then,
  ) = __$$GroupMessageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String msgId,
    String from,
    String to,
    String content,
    String msgType,
    int timestamp,
    Map<String, dynamic> extras,
  });
}

/// @nodoc
class __$$GroupMessageDtoImplCopyWithImpl<$Res>
    extends _$GroupMessageDtoCopyWithImpl<$Res, _$GroupMessageDtoImpl>
    implements _$$GroupMessageDtoImplCopyWith<$Res> {
  __$$GroupMessageDtoImplCopyWithImpl(
    _$GroupMessageDtoImpl _value,
    $Res Function(_$GroupMessageDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroupMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? msgId = null,
    Object? from = null,
    Object? to = null,
    Object? content = null,
    Object? msgType = null,
    Object? timestamp = null,
    Object? extras = null,
  }) {
    return _then(
      _$GroupMessageDtoImpl(
        msgId: null == msgId
            ? _value.msgId
            : msgId // ignore: cast_nullable_to_non_nullable
                  as String,
        from: null == from
            ? _value.from
            : from // ignore: cast_nullable_to_non_nullable
                  as String,
        to: null == to
            ? _value.to
            : to // ignore: cast_nullable_to_non_nullable
                  as String,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        msgType: null == msgType
            ? _value.msgType
            : msgType // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
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
class _$GroupMessageDtoImpl implements _GroupMessageDto {
  const _$GroupMessageDtoImpl({
    this.msgId = '',
    this.from = '',
    this.to = '',
    this.content = '',
    this.msgType = 'text',
    this.timestamp = 0,
    final Map<String, dynamic> extras = const {},
  }) : _extras = extras;

  factory _$GroupMessageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupMessageDtoImplFromJson(json);

  @override
  @JsonKey()
  final String msgId;
  @override
  @JsonKey()
  final String from;
  @override
  @JsonKey()
  final String to;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String msgType;
  @override
  @JsonKey()
  final int timestamp;
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
    return 'GroupMessageDto(msgId: $msgId, from: $from, to: $to, content: $content, msgType: $msgType, timestamp: $timestamp, extras: $extras)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupMessageDtoImpl &&
            (identical(other.msgId, msgId) || other.msgId == msgId) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.msgType, msgType) || other.msgType == msgType) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality().equals(other._extras, _extras));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    msgId,
    from,
    to,
    content,
    msgType,
    timestamp,
    const DeepCollectionEquality().hash(_extras),
  );

  /// Create a copy of GroupMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupMessageDtoImplCopyWith<_$GroupMessageDtoImpl> get copyWith =>
      __$$GroupMessageDtoImplCopyWithImpl<_$GroupMessageDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupMessageDtoImplToJson(this);
  }
}

abstract class _GroupMessageDto implements GroupMessageDto {
  const factory _GroupMessageDto({
    final String msgId,
    final String from,
    final String to,
    final String content,
    final String msgType,
    final int timestamp,
    final Map<String, dynamic> extras,
  }) = _$GroupMessageDtoImpl;

  factory _GroupMessageDto.fromJson(Map<String, dynamic> json) =
      _$GroupMessageDtoImpl.fromJson;

  @override
  String get msgId;
  @override
  String get from;
  @override
  String get to;
  @override
  String get content;
  @override
  String get msgType;
  @override
  int get timestamp;
  @override
  Map<String, dynamic> get extras;

  /// Create a copy of GroupMessageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupMessageDtoImplCopyWith<_$GroupMessageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupMemberDto _$GroupMemberDtoFromJson(Map<String, dynamic> json) {
  return _GroupMemberDto.fromJson(json);
}

/// @nodoc
mixin _$GroupMemberDto {
  String get tuid => throw _privateConstructorUsedError;
  String get puid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get picUrl => throw _privateConstructorUsedError;

  /// Serializes this GroupMemberDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupMemberDtoCopyWith<GroupMemberDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupMemberDtoCopyWith<$Res> {
  factory $GroupMemberDtoCopyWith(
    GroupMemberDto value,
    $Res Function(GroupMemberDto) then,
  ) = _$GroupMemberDtoCopyWithImpl<$Res, GroupMemberDto>;
  @useResult
  $Res call({String tuid, String puid, String name, String picUrl});
}

/// @nodoc
class _$GroupMemberDtoCopyWithImpl<$Res, $Val extends GroupMemberDto>
    implements $GroupMemberDtoCopyWith<$Res> {
  _$GroupMemberDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tuid = null,
    Object? puid = null,
    Object? name = null,
    Object? picUrl = null,
  }) {
    return _then(
      _value.copyWith(
            tuid: null == tuid
                ? _value.tuid
                : tuid // ignore: cast_nullable_to_non_nullable
                      as String,
            puid: null == puid
                ? _value.puid
                : puid // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            picUrl: null == picUrl
                ? _value.picUrl
                : picUrl // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GroupMemberDtoImplCopyWith<$Res>
    implements $GroupMemberDtoCopyWith<$Res> {
  factory _$$GroupMemberDtoImplCopyWith(
    _$GroupMemberDtoImpl value,
    $Res Function(_$GroupMemberDtoImpl) then,
  ) = __$$GroupMemberDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tuid, String puid, String name, String picUrl});
}

/// @nodoc
class __$$GroupMemberDtoImplCopyWithImpl<$Res>
    extends _$GroupMemberDtoCopyWithImpl<$Res, _$GroupMemberDtoImpl>
    implements _$$GroupMemberDtoImplCopyWith<$Res> {
  __$$GroupMemberDtoImplCopyWithImpl(
    _$GroupMemberDtoImpl _value,
    $Res Function(_$GroupMemberDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroupMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tuid = null,
    Object? puid = null,
    Object? name = null,
    Object? picUrl = null,
  }) {
    return _then(
      _$GroupMemberDtoImpl(
        tuid: null == tuid
            ? _value.tuid
            : tuid // ignore: cast_nullable_to_non_nullable
                  as String,
        puid: null == puid
            ? _value.puid
            : puid // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        picUrl: null == picUrl
            ? _value.picUrl
            : picUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupMemberDtoImpl implements _GroupMemberDto {
  const _$GroupMemberDtoImpl({
    this.tuid = '',
    this.puid = '',
    this.name = '',
    this.picUrl = '',
  });

  factory _$GroupMemberDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupMemberDtoImplFromJson(json);

  @override
  @JsonKey()
  final String tuid;
  @override
  @JsonKey()
  final String puid;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String picUrl;

  @override
  String toString() {
    return 'GroupMemberDto(tuid: $tuid, puid: $puid, name: $name, picUrl: $picUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupMemberDtoImpl &&
            (identical(other.tuid, tuid) || other.tuid == tuid) &&
            (identical(other.puid, puid) || other.puid == puid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.picUrl, picUrl) || other.picUrl == picUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tuid, puid, name, picUrl);

  /// Create a copy of GroupMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupMemberDtoImplCopyWith<_$GroupMemberDtoImpl> get copyWith =>
      __$$GroupMemberDtoImplCopyWithImpl<_$GroupMemberDtoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupMemberDtoImplToJson(this);
  }
}

abstract class _GroupMemberDto implements GroupMemberDto {
  const factory _GroupMemberDto({
    final String tuid,
    final String puid,
    final String name,
    final String picUrl,
  }) = _$GroupMemberDtoImpl;

  factory _GroupMemberDto.fromJson(Map<String, dynamic> json) =
      _$GroupMemberDtoImpl.fromJson;

  @override
  String get tuid;
  @override
  String get puid;
  @override
  String get name;
  @override
  String get picUrl;

  /// Create a copy of GroupMemberDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupMemberDtoImplCopyWith<_$GroupMemberDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

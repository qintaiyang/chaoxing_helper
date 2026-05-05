import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../app_dependencies.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/push_notification.dart';
import '../../domain/entities/user.dart';
import '../../infra/services/dnd_service.dart';
import '../../infra/services/member_name_cache.dart';
import 'location_select_page.dart';

enum _MsgType {
  text,
  image,
  file,
  voice,
  video,
  location,
  courseActivity,
  homework,
  groupSignIn,
  system,
}

class GroupChatPage extends StatefulWidget {
  final String chatId;
  final String? title;
  final bool isGroup;
  final String? groupIcon;

  const GroupChatPage({
    super.key,
    required this.chatId,
    this.title,
    this.isGroup = true,
    this.groupIcon,
  });

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  late final _msgCtrl = TextEditingController();
  late final _scrollCtrl = ScrollController();
  final _messages = <_ChatMessage>[];
  final _picker = ImagePicker();
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  final Map<String, _GroupMemberInfo> _memberCache = {};

  String? _myChatPuid;
  String? _myDisplayName;
  String? _myAvatarUrl;
  String? _myEasemobId;
  String _displayName = '';
  int _displayMemberCount = 0;

  static const int _maxCacheMessages = 50;
  bool _isLoadingNetwork = false;
  bool _showAttachmentPanel = false;
  bool _isRecording = false;
  DateTime? _recordingStartTime;
  String? _playingMsgId;
  int _playProgress = 0;
  bool _isSending = false;
  bool _isDnd = false;
  Timer? _saveTimer;

  bool get _isGroup => widget.isGroup;
  EMConversationType get _convType =>
      _isGroup ? EMConversationType.GroupChat : EMConversationType.Chat;
  ChatType get _chatType => _isGroup ? ChatType.GroupChat : ChatType.Chat;
  String get _cacheKey => _isGroup
      ? 'chat_msgs_${widget.chatId}'
      : 'private_chat_msgs_${widget.chatId}';

  StreamSubscription<EMMessage>? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _myEasemobId = EMClient.getInstance.currentUserId;
    _myChatPuid = _getChatPuid();
    _displayName = widget.title ?? widget.chatId;
    _isDnd = DndService().isDnd(widget.chatId);
    _AvatarCache.clearFailedUrls();
    _loadMyProfile();
    if (_isGroup) {
      _loadGroupInfo();
      _loadGroupMembersWithAttributes();
    }
    _markConversationAsRead();
    _phase1LoadFromCache();
    _setupAudioPlayer();
    _listenToImServiceStream();
  }

  void _listenToImServiceStream() {
    _messageSubscription = AppDependencies.instance.imService.onNewMessage
        .listen((message) {
          if (!mounted) return;
          final convId = message.conversationId ?? message.to;
          if (convId != widget.chatId) return;
          if (message.chatType != _chatType) return;

          final senderName = _getDisplayName(message);
          final senderAvatar = _getAvatarUrl(message);
          final parsed = _parseMessage(message, senderName, senderAvatar);
          if (parsed != null) {
            setState(() => _messages.add(parsed));
            _scrollToBottom();
            _debouncedSaveToCache();
            unawaited(_markConversationAsRead());
          }
        });
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _playingMsgId = null;
          _playProgress = 0;
        });
      }
    });
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted && _playingMsgId != null) {
        setState(() {
          _playProgress = position.inMilliseconds;
        });
      }
    });
  }

  String? _getChatPuid() {
    try {
      final sessionIdResult = AppDependencies.instance.accountRepo
          .getCurrentSessionId();
      final sessionId = sessionIdResult.fold((_) => null, (id) => id);
      if (sessionId != null) {
        final userResult = AppDependencies.instance.accountRepo.getAccountById(
          sessionId,
        );
        return userResult.fold(
          (_) => null,
          (user) => user?.imAccount?.userName,
        );
      }
    } catch (_) {}
    return null;
  }

  Future<void> _loadMyProfile() async {
    try {
      final sessionIdResult = AppDependencies.instance.accountRepo
          .getCurrentSessionId();
      final sessionId = sessionIdResult.fold((_) => null, (id) => id);
      if (sessionId != null) {
        final userResult = AppDependencies.instance.accountRepo.getAccountById(
          sessionId,
        );
        userResult.fold(
          (failure) => debugPrint('加载用户信息失败: ${failure.message}'),
          (user) {
            if (user != null) {
              _myDisplayName = user.name;
              String avatar = user.avatar;
              if (avatar.isNotEmpty) {
                final imgPattern = RegExp(r'<img[^>]+src="([^"]+)"');
                final match = imgPattern.firstMatch(avatar);
                if (match != null) {
                  avatar = match.group(1)!;
                }
                if (avatar.startsWith('//')) {
                  avatar = 'https:$avatar';
                }
              }
              _myAvatarUrl = avatar;
              final puid = _myChatPuid ?? '';
              if (_myDisplayName != null && _myDisplayName!.isNotEmpty) {
                MemberNameCache().set(
                  puid,
                  _myDisplayName!,
                  avatar: _myAvatarUrl,
                );
              } else if (_myAvatarUrl != null && _myAvatarUrl!.isNotEmpty) {
                MemberNameCache().setAvatar(puid, _myAvatarUrl!);
              }
              if (mounted) setState(() {});
              _setMyMemberAttributes();
            }
          },
        );
      }
    } catch (e) {
      debugPrint('加载用户信息失败: $e');
    }

    try {
      final userResult = await AppDependencies.instance.storage.getString(
        'user',
      );
      userResult.fold((_) {}, (userJson) {
        if (userJson != null && userJson.isNotEmpty) {
          try {
            final userData = jsonDecode(userJson) as Map<String, dynamic>;
            final storedPuid = userData['puid']?.toString() ?? '';
            if (storedPuid.isNotEmpty) {
              if (_myChatPuid != null && _myChatPuid != storedPuid) {
                MemberNameCache().setWithAliases(
                  _myChatPuid!,
                  storedPuid,
                  _myDisplayName ?? '',
                  avatar: _myAvatarUrl,
                );
              }
              _myChatPuid = storedPuid;
            }
          } catch (_) {}
        }
      });
    } catch (_) {}
  }

  Future<void> _setMyMemberAttributes() async {
    if (!_isGroup) return;
    try {
      final im = AppDependencies.instance.imService;
      if (!im.isLoggedIn || _myChatPuid == null) return;
      await EMClient.getInstance.groupManager.setMemberAttributes(
        groupId: widget.chatId,
        attributes: {
          'displayName': _myDisplayName ?? '',
          'avatarUrl': _myAvatarUrl ?? '',
        },
        userId: _myChatPuid,
      );
    } catch (e) {
      debugPrint('设置群成员属性失败: $e');
    }
  }

  Future<void> _markConversationAsRead() async {
    try {
      final chat = await EMClient.getInstance.chatManager.getConversation(
        widget.chatId,
        type: _convType,
        createIfNeed: false,
      );
      if (chat != null) {
        await chat.markAllMessagesAsRead();
      }
    } catch (_) {}
  }

  void _phase1LoadFromCache() {
    try {
      final cached = AppDependencies.instance.storage.getStringSync(_cacheKey);
      if (cached != null && cached.isNotEmpty) {
        final List<dynamic> list = jsonDecode(cached);
        for (var item in list) {
          _messages.add(_ChatMessage.fromJson(item));
        }
        debugPrint('[ChatCache] Phase1 缓存加载: ${_messages.length} 条消息');
        if (mounted) setState(() {});
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    } catch (e) {
      debugPrint('[ChatCache] 加载缓存失败: $e');
    }
    _phase2LoadFromLocalDb();
  }

  Future<void> _phase2LoadFromLocalDb() async {
    try {
      final chat = await EMClient.getInstance.chatManager.getConversation(
        widget.chatId,
        type: _convType,
        createIfNeed: false,
      );
      if (chat == null) return;

      final localMessages = await chat.loadMessages(
        loadCount: _maxCacheMessages,
        direction: EMSearchDirection.Up,
      );
      if (localMessages.isEmpty) return;

      final existingIds = _messages.map((m) => m.msgId).toSet();
      int newCount = 0;

      for (var msg in localMessages.reversed) {
        if (existingIds.contains(msg.msgId)) continue;
        final senderName = _getDisplayName(msg);
        final senderAvatar = _getAvatarUrl(msg);
        final parsed = _parseMessage(msg, senderName, senderAvatar);
        if (parsed != null) {
          _messages.add(parsed);
          existingIds.add(parsed.msgId);
          newCount++;
        }
      }

      if (newCount > 0) {
        _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        debugPrint(
          '[ChatCache] Phase2 本地DB加载: +$newCount 条, 总计 ${_messages.length} 条',
        );
        if (mounted) setState(() {});
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    } catch (e) {
      debugPrint('[ChatCache] Phase2 本地DB加载失败: $e');
    }

    if (_messages.length < _maxCacheMessages) {
      _phase3FetchFromServer();
    } else {
      _phase4ResolveSenderInfo();
    }
  }

  Future<void> _phase3FetchFromServer() async {
    if (_isLoadingNetwork) return;
    _isLoadingNetwork = true;
    try {
      final result = await EMClient.getInstance.chatManager
          .fetchHistoryMessagesByOption(widget.chatId, _convType, pageSize: 50);
      if (result.data.isEmpty) {
        debugPrint('[ChatCache] Phase3 服务器: 无历史消息');
        return;
      }

      final existingIds = _messages.map((m) => m.msgId).toSet();
      int newCount = 0;

      for (var msg in result.data) {
        if (existingIds.contains(msg.msgId)) continue;
        final senderName = _getDisplayName(msg);
        final senderAvatar = _getAvatarUrl(msg);
        final parsed = _parseMessage(msg, senderName, senderAvatar);
        if (parsed != null) {
          _messages.add(parsed);
          existingIds.add(parsed.msgId);
          newCount++;
        }
      }

      if (newCount > 0) {
        _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        debugPrint(
          '[ChatCache] Phase3 服务器加载: +$newCount 条, 总计 ${_messages.length} 条',
        );
        if (mounted) setState(() {});
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    } catch (e) {
      debugPrint('[ChatCache] Phase3 服务器加载失败: $e');
    } finally {
      _isLoadingNetwork = false;
      _phase4ResolveSenderInfo();
    }
  }

  Future<void> _phase4ResolveSenderInfo() async {
    final senderIds = <String>{};
    final myEasemobId = _myEasemobId ?? '';
    for (var msg in _messages) {
      if (msg.senderId.isNotEmpty &&
          msg.senderId != 'system' &&
          msg.senderId != myEasemobId &&
          !_memberCache.containsKey(msg.senderId)) {
        senderIds.add(msg.senderId);
      }
    }
    if (senderIds.isNotEmpty) {
      debugPrint('[ChatCache] Phase4 获取 ${senderIds.length} 个发送者信息');
      await _loadSenderAvatarsFromWebIM(allMemberIds: senderIds.toList());
      _updateMessageAvatars();
      if (mounted) setState(() {});
    }

    if (_messages.isEmpty || _messages.first.msgId != 'system_welcome') {
      _messages.insert(
        0,
        _ChatMessage(
          msgId: 'system_welcome',
          senderId: 'system',
          senderName: '系统',
          senderAvatar: '',
          content: '欢迎进入群聊 $_displayName',
          type: _MsgType.system,
          timestamp: DateTime.now(),
        ),
      );
      if (mounted) setState(() {});
    }
    _saveToCache();
  }

  Future<void> _saveToCache() async {
    try {
      final messages = _messages
          .where((m) => m.type != _MsgType.system)
          .take(_maxCacheMessages)
          .map((m) => jsonEncode(m.toJson()))
          .toList();
      await AppDependencies.instance.storage.setString(
        _cacheKey,
        jsonEncode(messages),
      );
    } catch (e) {
      debugPrint('[ChatCache] 保存缓存失败: $e');
    }
  }

  void _debouncedSaveToCache() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 500), _saveToCache);
  }

  Future<void> _loadGroupInfo() async {
    if (!_isGroup) return;
    try {
      final group = await EMClient.getInstance.groupManager
          .fetchGroupInfoFromServer(widget.chatId);
      if (mounted) {
        var name = group.groupName ?? widget.chatId;
        final ext = group.extension ?? group.desc;
        if (ext != null && ext.isNotEmpty) {
          try {
            final map = jsonDecode(ext) as Map<String, dynamic>;
            final cn = map['courseInfo']?['coursename']?.toString();
            if (cn != null && cn.isNotEmpty) name = cn;
          } catch (_) {}
        }
        setState(() {
          _displayName = name;
          _displayMemberCount = group.memberCount ?? 0;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadGroupMembersWithAttributes() async {
    if (!_isGroup) return;
    try {
      final im = AppDependencies.instance.imService;
      if (!im.isLoggedIn) return;

      final result = await EMClient.getInstance.groupManager
          .fetchMemberListFromServer(widget.chatId, pageSize: 100);

      if (result.data.isNotEmpty) {
        final memberIds = result.data;
        debugPrint('环信SDK获取到 ${memberIds.length} 个群组成员ID');

        for (var memberId in memberIds) {
          if (!_memberCache.containsKey(memberId)) {
            _memberCache[memberId] = _GroupMemberInfo(
              uid: memberId,
              name: '用户$memberId',
              avatar: '',
            );
          }
        }

        if (memberIds.isNotEmpty) {
          await _loadMembersFromEasemobAttributes(memberIds);
        }

        final uncachedIds = <String>{};
        for (var mid in memberIds) {
          if (!_memberCache.containsKey(mid) ||
              _memberCache[mid]!.avatar.isEmpty) {
            uncachedIds.add(mid);
          }
        }
        if (uncachedIds.isNotEmpty) {
          await _loadSenderAvatarsFromWebIM(allMemberIds: uncachedIds.toList());
        }

        _updateMessageAvatars();
        if (mounted) setState(() {});
      }
    } on EMError catch (e) {
      debugPrint('加载群组成员失败(EMError): code=${e.code}, desc=${e.description}');
    } catch (e) {
      debugPrint('加载群组成员失败: $e');
    }
  }

  Future<void> _loadMembersFromEasemobAttributes(List<String> memberIds) async {
    try {
      for (var i = 0; i < memberIds.length; i += 10) {
        final batch = memberIds.skip(i).take(10).toList();
        final attrs = await EMClient.getInstance.groupManager
            .fetchMembersAttributes(
              groupId: widget.chatId,
              userIds: batch,
              keys: ['displayName', 'avatarUrl'],
            );

        attrs.forEach((userId, attrMap) {
          final name = attrMap['displayName'] ?? '';
          final avatar = attrMap['avatarUrl'] ?? '';
          final existing = _memberCache[userId];
          _memberCache[userId] = _GroupMemberInfo(
            uid: userId,
            name: (name.isNotEmpty && name != '用户$userId')
                ? name
                : (existing?.name ?? ''),
            avatar: (avatar.isNotEmpty) ? avatar : (existing?.avatar ?? ''),
          );
          if (name.isNotEmpty && name != '用户$userId') {
            MemberNameCache().set(userId, name, avatar: avatar);
          } else if (avatar.isNotEmpty) {
            MemberNameCache().setAvatar(userId, avatar);
          }
        });
      }
      MemberNameCache().saveToStorage();
    } catch (e) {
      debugPrint('[GroupChat] 获取成员属性失败: $e');
    }
  }

  Future<void> _loadSenderAvatarsFromWebIM({List<String>? allMemberIds}) async {
    try {
      final Set<String> memberIds = allMemberIds?.toSet() ?? <String>{};

      if (allMemberIds == null || allMemberIds.isEmpty) {
        for (var msg in _messages) {
          if (msg.senderId.isNotEmpty && msg.senderId != 'system') {
            if (!_memberCache.containsKey(msg.senderId) ||
                _memberCache[msg.senderId]!.avatar.isEmpty) {
              memberIds.add(msg.senderId);
            }
          }
        }
      }

      if (memberIds.isEmpty) return;

      final memberList = memberIds.toList();
      final Map<String, String> tuidToPuid = {};

      if (_isGroup) {
        final futures = <Future<List<dynamic>>>[];
        for (var i = 0; i < memberList.length; i += 20) {
          final batch = memberList.skip(i).take(20).toList();
          futures.add(
            AppDependencies.instance.cxGroupImApi
                .getUserInfoByTuid2(tuids: batch, chatId: widget.chatId)
                .then((list) => list.toList()),
          );
        }

        final results = await Future.wait(futures);

        for (var members in results) {
          for (var member in members) {
            final tuid = member.tuid;
            final puid = member.puid;
            final name = member.name;
            final avatar = member.picUrl.isNotEmpty ? member.picUrl : '';
            _memberCache[tuid] = _GroupMemberInfo(
              uid: tuid,
              name: name,
              avatar: avatar.isNotEmpty
                  ? avatar
                  : (_memberCache[tuid]?.avatar ?? ''),
            );
            if (puid.isNotEmpty) {
              tuidToPuid[tuid] = puid;
            }
          }
        }
      } else {
        final groupIcon = widget.groupIcon ?? '';
        if (_isValidAvatarUrl(groupIcon)) {
          for (var tuid in memberList) {
            _memberCache[tuid] = _GroupMemberInfo(
              uid: tuid,
              name: MemberNameCache().get(tuid) ?? '用户$tuid',
              avatar: groupIcon,
            );
            if (MemberNameCache().get(tuid) == null) {
              MemberNameCache().set(tuid, '用户$tuid', avatar: groupIcon);
            } else {
              MemberNameCache().setAvatar(tuid, groupIcon);
            }
          }
        } else if (memberList.isNotEmpty) {
          final sessionIdResult = AppDependencies.instance.accountRepo
              .getCurrentSessionId();
          final puid = sessionIdResult.fold((_) => '', (id) => id ?? '');
          final userInfo = await AppDependencies.instance.cxGroupImApi
              .getUserInfoByTuid(tuid: memberList.first, puid: puid, token: '');
          if (userInfo != null && userInfo.picUrl.isNotEmpty) {
            _memberCache[memberList.first] = _GroupMemberInfo(
              uid: memberList.first,
              name: userInfo.name,
              avatar: userInfo.picUrl,
            );
            MemberNameCache().set(
              memberList.first,
              userInfo.name,
              avatar: userInfo.picUrl,
            );
          }
        }
      }

      if (tuidToPuid.isNotEmpty) {
        for (final entry in tuidToPuid.entries) {
          final tuid = entry.key;
          final puid = entry.value;

          String? bestName;
          if (_memberCache.containsKey(puid)) {
            final courseName = _memberCache[puid]!.name;
            if (courseName.isNotEmpty && !courseName.startsWith('用户')) {
              bestName = courseName;
            }
          }
          if (bestName == null && _memberCache.containsKey(tuid)) {
            final webName = _memberCache[tuid]!.name;
            if (webName.isNotEmpty && !webName.startsWith('用户')) {
              bestName = webName;
            }
          }

          if (bestName != null) {
            _memberCache[tuid] = _GroupMemberInfo(
              uid: tuid,
              name: bestName,
              avatar: _memberCache[tuid]?.avatar ?? '',
            );
            MemberNameCache().set(tuid, bestName);
          }
        }
        MemberNameCache().saveToStorage();
      }
    } catch (e) {
      debugPrint('[GroupChat] Web IM API 获取用户信息失败: $e');
    }
  }

  void _updateMessageAvatars() {
    var updated = false;
    for (int i = 0; i < _messages.length; i++) {
      final msg = _messages[i];
      final senderId = msg.senderId;
      if (senderId.isEmpty || senderId == 'system') continue;

      final myEasemobId = _myEasemobId ?? '';
      final isMe = senderId == myEasemobId;
      if (isMe) continue;

      String? newAvatar;

      final cachedMember = _memberCache[senderId];
      if (cachedMember != null) {
        if (cachedMember.avatar.isNotEmpty) newAvatar = cachedMember.avatar;
      }

      if (newAvatar == null || newAvatar.isEmpty) {
        final memberAvatar = MemberNameCache().getAvatar(senderId);
        if (memberAvatar != null && memberAvatar.isNotEmpty) {
          newAvatar = memberAvatar;
        }
      }

      if ((newAvatar == null || newAvatar.isEmpty) && !_isGroup) {
        final groupIcon = widget.groupIcon ?? '';
        if (_isValidAvatarUrl(groupIcon)) newAvatar = groupIcon;
      }

      if (newAvatar == null || newAvatar.isEmpty) {
        newAvatar = msg.senderAvatar;
      }

      if (newAvatar != msg.senderAvatar) {
        msg.senderAvatar = newAvatar;
        updated = true;
      }
    }
    if (updated && mounted) setState(() {});
  }

  String _getDisplayName(EMMessage msg) {
    final senderId = msg.from ?? '';
    final myEasemobId = _myEasemobId ?? '';
    if (senderId == myEasemobId) return _myDisplayName ?? '我';
    if (_memberCache.containsKey(senderId)) {
      final member = _memberCache[senderId]!;
      if (member.name.isNotEmpty && member.name != senderId) {
        return member.name;
      }
    }
    if (!_isGroup) {
      final cachedName = MemberNameCache().get(senderId);
      if (cachedName != null &&
          cachedName.isNotEmpty &&
          cachedName != senderId) {
        return cachedName;
      }
      final cachedByPuid = MemberNameCache().get(widget.chatId);
      if (cachedByPuid != null &&
          cachedByPuid.isNotEmpty &&
          cachedByPuid != widget.chatId) {
        return cachedByPuid;
      }
      return _displayName;
    }
    return '用户$senderId';
  }

  String _getAvatarUrl(EMMessage msg) {
    final senderId = msg.from ?? '';
    final myEasemobId = _myEasemobId ?? '';
    if (senderId == myEasemobId &&
        _myAvatarUrl != null &&
        _myAvatarUrl!.isNotEmpty) {
      return _myAvatarUrl!;
    }
    if (_memberCache.containsKey(senderId)) {
      String avatar = _memberCache[senderId]!.avatar;
      if (avatar.isNotEmpty) {
        if (avatar.startsWith('//')) avatar = 'https:$avatar';
        return avatar;
      }
    }
    if (!_isGroup && senderId == widget.chatId) {
      final groupIcon = widget.groupIcon ?? '';
      if (_isValidAvatarUrl(groupIcon)) return groupIcon;
    }
    return '';
  }

  _ChatMessage? _parseMessage(
    EMMessage msg,
    String senderName,
    String senderAvatar,
  ) {
    final timestamp = DateTime.fromMillisecondsSinceEpoch(msg.serverTime);
    final senderId = msg.from ?? '';

    if (msg.attributes != null) {
      final attachment = _extractAttachment(msg);
      if (attachment != null) {
        if (attachment.containsKey('att_clouddisk')) {
          final cloudInfo = attachment['att_clouddisk'];
          final name = cloudInfo['name'] ?? '文件';
          final size = cloudInfo['fileSize'] ?? '';
          return _ChatMessage(
            msgId: msg.msgId,
            senderId: senderId,
            senderName: senderName,
            senderAvatar: senderAvatar,
            content: '$name ($size)',
            type: _MsgType.file,
            timestamp: timestamp,
            rawData: {
              'localPath': '',
              'remotePath': '',
              'displayName': name,
              'fileSize': cloudInfo['size'] ?? 0,
              'fileId': cloudInfo['fileId'] ?? '',
              'objectId': cloudInfo['objectId'] ?? '',
              'crc': cloudInfo['crc'] ?? '',
              'suffix': cloudInfo['suffix'] ?? '',
              'resid': cloudInfo['resid'] ?? '',
              'puid': cloudInfo['puid'] ?? '',
              'preview': cloudInfo['preview'] ?? '',
              'thumbnail': cloudInfo['thumbnail'] ?? '',
            },
          );
        }
        if (attachment.containsKey('att_chat_course')) {
          final info = attachment['att_chat_course'];
          final title = info['title'] ?? info['typeTitle'] ?? '课程活动';
          final typeName = info['atypeName'] ?? info['typeTitle'] ?? '活动';
          final courseInfo = info['courseInfo'];
          final Map<String, dynamic> courseData = courseInfo is Map
              ? Map<String, dynamic>.from(courseInfo)
              : <String, dynamic>{};
          final rawData = <String, dynamic>{
            'title': title,
            'typeTitle': typeName,
            'atypeName': typeName,
            'type': info['type'],
            'activeType': info['activeType'],
            'status': info['status'],
            'url': info['url'],
            'aid': info['aid'],
            'id': info['id'],
            'logo': info['logo'],
            'courseId': courseData['courseid'] ?? courseData['courseId'] ?? '',
            'classId': courseData['classid'] ?? courseData['classId'] ?? '',
            'cpi': courseData['cpi'] ?? '',
            'courseName':
                courseData['coursename'] ?? courseData['courseName'] ?? '',
          };
          return _ChatMessage(
            msgId: msg.msgId,
            senderId: senderId,
            senderName: senderName,
            senderAvatar: senderAvatar,
            content: '[$typeName] $title',
            type: _MsgType.courseActivity,
            timestamp: timestamp,
            rawData: rawData,
          );
        }
        if (attachment.containsKey('att_homework')) {
          final info = attachment['att_homework'];
          final title = info['title'] ?? '新作业';
          final courseName = info['courseName'] ?? '';
          return _ChatMessage(
            msgId: msg.msgId,
            senderId: senderId,
            senderName: senderName,
            senderAvatar: senderAvatar,
            content: courseName.isNotEmpty
                ? '「$courseName」新作业：$title'
                : '新作业：$title',
            type: _MsgType.homework,
            timestamp: timestamp,
            rawData: Map<String, dynamic>.from(info),
          );
        }
        if (attachment.containsKey('att_group_sign')) {
          final info = attachment['att_group_sign'];
          final title = info['title'] ?? '群聊签到';
          return _ChatMessage(
            msgId: msg.msgId,
            senderId: senderId,
            senderName: senderName,
            senderAvatar: senderAvatar,
            content: '群聊签到：$title',
            type: _MsgType.groupSignIn,
            timestamp: timestamp,
            rawData: Map<String, dynamic>.from(info),
          );
        }
        if (attachment.containsKey('att_voice') ||
            attachment.containsKey('att_audio')) {
          final voiceKey = attachment.containsKey('att_voice')
              ? 'att_voice'
              : 'att_audio';
          final info = attachment[voiceKey];
          final remotePath =
              info['remotePath']?.toString() ?? info['url']?.toString() ?? '';
          final localPath = info['localPath']?.toString() ?? '';
          final duration = info['duration'] as int? ?? 0;
          final durationSec = duration > 0 ? (duration / 1000).round() : 5;
          return _ChatMessage(
            msgId: msg.msgId,
            senderId: senderId,
            senderName: senderName,
            senderAvatar: senderAvatar,
            content: '语音消息 (${durationSec}s)',
            type: _MsgType.voice,
            timestamp: timestamp,
            rawData: {
              'remotePath': remotePath,
              'localPath': localPath,
              'duration': duration,
            },
          );
        }
        if (attachment.containsKey('text')) {
          return _ChatMessage(
            msgId: msg.msgId,
            senderId: senderId,
            senderName: senderName,
            senderAvatar: senderAvatar,
            content: attachment['text']?.toString() ?? '',
            type: _MsgType.text,
            timestamp: timestamp,
          );
        }
      }

      final location = msg.attributes?['location'];
      if (location != null && location is Map) {
        final lat = location['latitude']?.toString() ?? '';
        final lng = location['longitude']?.toString() ?? '';
        final addr = location['address']?.toString() ?? '';
        final name = location['name']?.toString() ?? '位置';
        return _ChatMessage(
          msgId: msg.msgId,
          senderId: senderId,
          senderName: senderName,
          senderAvatar: senderAvatar,
          content: addr.isNotEmpty ? addr : '$lat, $lng',
          type: _MsgType.location,
          timestamp: timestamp,
          rawData: {
            'latitude': lat,
            'longitude': lng,
            'address': addr,
            'name': name,
          },
        );
      }
    }

    final body = msg.body;
    if (body is EMTextMessageBody) {
      return _ChatMessage(
        msgId: msg.msgId,
        senderId: senderId,
        senderName: senderName,
        senderAvatar: senderAvatar,
        content: body.content,
        type: _MsgType.text,
        timestamp: timestamp,
      );
    }
    if (body is EMImageMessageBody) {
      return _ChatMessage(
        msgId: msg.msgId,
        senderId: senderId,
        senderName: senderName,
        senderAvatar: senderAvatar,
        content: body.displayName ?? '图片',
        type: _MsgType.image,
        timestamp: timestamp,
        rawData: {
          'remotePath': body.remotePath,
          'localPath': body.localPath,
          'displayName': body.displayName ?? '图片',
          'fileSize': body.fileSize ?? 0,
        },
      );
    }
    if (body is EMVoiceMessageBody) {
      final duration = body.duration;
      final durationSec = duration > 0 ? (duration / 1000).round() : 0;
      return _ChatMessage(
        msgId: msg.msgId,
        senderId: senderId,
        senderName: senderName,
        senderAvatar: senderAvatar,
        content: '语音消息 (${durationSec}s)',
        type: _MsgType.voice,
        timestamp: timestamp,
        rawData: {
          'remotePath': body.remotePath,
          'localPath': body.localPath,
          'duration': duration,
        },
      );
    }
    if (body is EMVideoMessageBody) {
      final duration = body.duration ?? 0;
      final durationSec = duration > 0 ? (duration / 1000).round() : 0;
      return _ChatMessage(
        msgId: msg.msgId,
        senderId: senderId,
        senderName: senderName,
        senderAvatar: senderAvatar,
        content: '${body.displayName ?? "视频"} (${durationSec}s)',
        type: _MsgType.video,
        timestamp: timestamp,
        rawData: {
          'remotePath': body.remotePath,
          'localPath': body.localPath,
          'displayName': body.displayName ?? '视频',
          'fileSize': body.fileSize ?? 0,
          'duration': body.duration ?? 0,
          'thumbLocalPath': body.thumbnailLocalPath,
          'thumbRemotePath': body.thumbnailRemotePath,
        },
      );
    }
    if (body is EMFileMessageBody) {
      final displayName = body.displayName ?? '文件';
      final ext = displayName.contains('.')
          ? displayName.split('.').last.toLowerCase()
          : '';
      final voiceExts = {
        'amr',
        'mp3',
        'wav',
        'ogg',
        'm4a',
        'aac',
        'silk',
        'pcm',
      };
      if (voiceExts.contains(ext)) {
        final fileSize = body.fileSize ?? 0;
        final durationSec = fileSize > 0 ? (fileSize ~/ 1000).clamp(1, 60) : 5;
        return _ChatMessage(
          msgId: msg.msgId,
          senderId: senderId,
          senderName: senderName,
          senderAvatar: senderAvatar,
          content: '语音消息 (${durationSec}s)',
          type: _MsgType.voice,
          timestamp: timestamp,
          rawData: {
            'remotePath': body.remotePath,
            'localPath': body.localPath,
            'displayName': displayName,
            'duration': durationSec * 1000,
          },
        );
      }
      final sizeStr = _formatFileSize(body.fileSize ?? 0);
      return _ChatMessage(
        msgId: msg.msgId,
        senderId: senderId,
        senderName: senderName,
        senderAvatar: senderAvatar,
        content: '$displayName ($sizeStr)',
        type: _MsgType.file,
        timestamp: timestamp,
        rawData: {
          'remotePath': body.remotePath,
          'localPath': body.localPath,
          'displayName': displayName,
          'fileSize': body.fileSize ?? 0,
        },
      );
    }
    if (body is EMLocationMessageBody) {
      final address = (body.address != null && body.address!.isNotEmpty)
          ? body.address!
          : '位置';
      return _ChatMessage(
        msgId: msg.msgId,
        senderId: senderId,
        senderName: senderName,
        senderAvatar: senderAvatar,
        content: address,
        type: _MsgType.location,
        timestamp: timestamp,
        rawData: {
          'latitude': body.latitude,
          'longitude': body.longitude,
          'address': body.address,
        },
      );
    }
    if (body is EMCustomMessageBody) {
      return _ChatMessage(
        msgId: msg.msgId,
        senderId: senderId,
        senderName: senderName,
        senderAvatar: senderAvatar,
        content: body.event,
        type: _MsgType.system,
        timestamp: timestamp,
        rawData: {'event': body.event, 'params': body.params},
      );
    }
    return null;
  }

  Map<String, dynamic>? _extractAttachment(EMMessage msg) {
    if (msg.attributes == null) return null;
    final attachmentRaw = msg.attributes!['attachment'];
    if (attachmentRaw is String) {
      try {
        return jsonDecode(attachmentRaw) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    if (attachmentRaw is Map) {
      return Map<String, dynamic>.from(attachmentRaw);
    }
    return null;
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _saveTimer?.cancel();
    _audioPlayer.dispose();
    _audioRecorder.dispose();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  bool _isValidAvatarUrl(String url) {
    return url.isNotEmpty &&
        !url.contains('course_logo.png') &&
        !url.contains('star3/origin/');
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _resolveSenderName(_ChatMessage msg, bool isMe) {
    if (isMe) return _myDisplayName ?? '我';
    final cachedMember = _memberCache[msg.senderId];
    if (cachedMember?.name.isNotEmpty == true &&
        cachedMember!.name != msg.senderId) {
      return cachedMember.name;
    }
    if (!_isGroup) {
      final cachedName = MemberNameCache().get(msg.senderId);
      if (cachedName != null &&
          cachedName.isNotEmpty &&
          cachedName != msg.senderId) {
        return cachedName;
      }
    }
    return msg.senderName;
  }

  Widget _buildAvatar(String avatarUrl) {
    String finalUrl = avatarUrl;

    if (!_isValidAvatarUrl(finalUrl)) {
      if (!_isGroup) {
        final otherTuid = widget.chatId;
        final cachedAvatar = MemberNameCache().getAvatar(otherTuid);
        if (cachedAvatar != null && cachedAvatar.isNotEmpty) {
          finalUrl = cachedAvatar;
        } else {
          final groupIcon = widget.groupIcon ?? '';
          if (_isValidAvatarUrl(groupIcon)) {
            finalUrl = groupIcon;
          } else {
            finalUrl = 'https://im.chaoxing.com/res/images/course_logo.png';
          }
        }
      } else {
        finalUrl = 'https://im.chaoxing.com/res/images/course_logo.png';
      }
    }

    if (finalUrl.isEmpty) {
      return SizedBox(
        width: 32,
        height: 32,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: Colors.grey[200],
            child: const Icon(Icons.person, size: 20, color: Colors.grey),
          ),
        ),
      );
    }

    if (finalUrl.startsWith('http://')) {
      finalUrl = finalUrl.replaceFirst('http://', 'https://');
    }

    return _ChatAvatar(
      imageUrl: finalUrl,
      size: 32,
      borderRadius: 16,
      iconSize: 20,
    );
  }

  Widget _buildBaseRow(_ChatMessage msg, bool isMe, Widget content) {
    String displayAvatar;

    if (isMe) {
      displayAvatar = _myAvatarUrl ?? '';
    } else if (_isGroup) {
      final cachedMember = _memberCache[msg.senderId];
      displayAvatar = cachedMember?.avatar.isNotEmpty == true
          ? cachedMember!.avatar
          : msg.senderAvatar;
    } else {
      final cachedAvatar = MemberNameCache().getAvatar(msg.senderId);
      if (cachedAvatar != null && cachedAvatar.isNotEmpty) {
        displayAvatar = cachedAvatar;
      } else if (_isValidAvatarUrl(widget.groupIcon ?? '')) {
        displayAvatar = widget.groupIcon!;
      } else {
        displayAvatar = msg.senderAvatar;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[_buildAvatar(displayAvatar), const SizedBox(width: 8)],
          Flexible(child: content),
          if (isMe) ...[
            const SizedBox(width: 8),
            _buildAvatar(_myAvatarUrl ?? ''),
          ],
        ],
      ),
    );
  }

  Widget _bubble(_ChatMessage msg) {
    if (msg.type == _MsgType.system) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            msg.content,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      );
    }

    if (msg.type == _MsgType.courseActivity ||
        msg.type == _MsgType.homework ||
        msg.type == _MsgType.groupSignIn) {
      return _buildActivityBubble(msg);
    }

    final myEasemobId = _myEasemobId;
    final isMe = msg.senderId == myEasemobId;

    switch (msg.type) {
      case _MsgType.image:
        return _buildImageBubble(msg, isMe);
      case _MsgType.voice:
        return _buildVoiceBubble(msg, isMe);
      case _MsgType.file:
        return _buildFileBubble(msg, isMe);
      case _MsgType.video:
        return _buildVideoBubble(msg, isMe);
      case _MsgType.location:
        return _buildLocationBubble(msg, isMe);
      case _MsgType.text:
      default:
        return _buildTextBubble(msg, isMe);
    }
  }

  Widget _buildTextBubble(_ChatMessage msg, bool isMe) {
    final senderName = _resolveSenderName(msg, isMe);
    final theme = Theme.of(context);

    final content = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isGroup) ...[
            Text(
              senderName,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            msg.content,
            style: TextStyle(
              color: isMe
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
    return _buildBaseRow(msg, isMe, content);
  }

  Widget _buildImageBubble(_ChatMessage msg, bool isMe) {
    final remoteUrl = msg.rawData?['remotePath']?.toString() ?? '';
    final localPath = msg.rawData?['localPath']?.toString() ?? '';
    final theme = Theme.of(context);

    Widget imageWidget;
    if (localPath.isNotEmpty) {
      final file = File(localPath);
      if (file.existsSync()) {
        imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            file,
            width: 180,
            height: 180,
            fit: BoxFit.cover,
            errorBuilder: (context, url, error) => _imagePlaceholder(msg),
          ),
        );
      } else {
        imageWidget = _buildRemoteImage(remoteUrl, msg);
      }
    } else if (remoteUrl.isNotEmpty) {
      imageWidget = _buildRemoteImage(remoteUrl, msg);
    } else {
      imageWidget = _imagePlaceholder(msg);
    }

    final content = Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _resolveSenderName(msg, isMe),
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          imageWidget,
        ],
      ),
    );
    return _buildBaseRow(msg, isMe, content);
  }

  Widget _buildRemoteImage(String remotePath, _ChatMessage msg) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: remotePath,
        width: 180,
        height: 180,
        fit: BoxFit.cover,
        httpHeaders: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
          'Referer': 'https://im.chaoxing.com/',
        },
        placeholder: (context, url) => Container(
          width: 180,
          height: 180,
          color: Colors.grey.withValues(alpha: 0.1),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => _imagePlaceholder(msg),
      ),
    );
  }

  Widget _imagePlaceholder(_ChatMessage msg) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              msg.content,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceBubble(_ChatMessage msg, bool isMe) {
    final durationSec = msg.rawData != null
        ? (msg.rawData!['duration'] as int? ?? 0) ~/ 1000
        : 0;
    final isPlaying = _playingMsgId == msg.msgId;
    final progressSec = _playingMsgId == msg.msgId ? _playProgress ~/ 1000 : 0;
    final progressPercent = durationSec > 0
        ? (progressSec / durationSec).clamp(0.0, 1.0)
        : 0.0;
    final theme = Theme.of(context);

    final content = InkWell(
      onTap: () => _playVoice(msg),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _resolveSenderName(msg, isMe),
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            if (isPlaying)
              Icon(Icons.pause_circle_filled, color: theme.colorScheme.primary)
            else
              Icon(Icons.play_circle_outline, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            if (isPlaying)
              SizedBox(
                width: 80,
                child: LinearProgressIndicator(
                  value: progressPercent,
                  minHeight: 3,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
            else
              Text('${durationSec}s', style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Icon(Icons.mic, size: 20, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
    return _buildBaseRow(msg, isMe, content);
  }

  Future<void> _playVoice(_ChatMessage msg) async {
    if (msg.rawData == null) {
      _snack('语音文件信息丢失，请重启应用后重试');
      return;
    }
    final localPath = msg.rawData!['localPath'] as String?;
    final remotePath = msg.rawData!['remotePath'] as String?;

    String? audioSource;
    if (localPath != null && localPath.isNotEmpty) {
      audioSource = localPath;
    } else if (remotePath != null && remotePath.isNotEmpty) {
      audioSource = remotePath;
    }

    if (audioSource == null || audioSource.isEmpty) {
      _snack('语音文件不可用，可能尚未下载');
      return;
    }

    try {
      if (_playingMsgId == msg.msgId) {
        await _audioPlayer.pause();
        setState(() {
          _playingMsgId = null;
          _playProgress = 0;
        });
        return;
      }

      await _audioPlayer.stop();
      setState(() {
        _playingMsgId = msg.msgId;
        _playProgress = 0;
      });

      if (audioSource.startsWith('http://') ||
          audioSource.startsWith('https://')) {
        await _audioPlayer.play(UrlSource(audioSource));
      } else {
        await _audioPlayer.play(DeviceFileSource(audioSource));
      }
    } catch (e) {
      _snack('播放失败: $e');
      setState(() {
        _playingMsgId = null;
        _playProgress = 0;
      });
    }
  }

  Widget _buildFileBubble(_ChatMessage msg, bool isMe) {
    final theme = Theme.of(context);
    final content = InkWell(
      onTap: msg.rawData != null ? () => _downloadFile(msg) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.insert_drive_file,
                color: Colors.blue[400],
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _resolveSenderName(msg, isMe),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    msg.content,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.download, size: 20, color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
    return _buildBaseRow(msg, isMe, content);
  }

  Future<void> _downloadFile(_ChatMessage msg) async {
    if (msg.rawData == null) {
      _snack('文件信息丢失');
      return;
    }
    final remotePath = msg.rawData!['remotePath'] as String?;
    if (remotePath == null || remotePath.isEmpty) {
      _snack('文件路径为空');
      return;
    }
    final displayName = msg.rawData?['displayName']?.toString() ?? '未知文件';

    _snack('正在下载: $displayName');
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        _snack('无法获取存储目录');
        return;
      }
      final savePath = '${dir.path}/$displayName';
      final response = await AppDependencies.instance.dioClient.sendRequest(
        remotePath,
        responseType: ResponseType.bytes,
      );
      if (response.data != null) {
        final file = File(savePath);
        await file.writeAsBytes(
          response.data is List<int> ? response.data as List<int> : [],
        );
        if (mounted) _snack('下载完成: $savePath');
      } else {
        if (mounted) _snack('下载失败: 响应为空');
      }
    } catch (e) {
      if (mounted) _snack('下载失败: $e');
    }
  }

  Widget _buildVideoBubble(_ChatMessage msg, bool isMe) {
    final thumbLocal = msg.rawData?['thumbLocalPath']?.toString() ?? '';
    final thumbRemote = msg.rawData?['thumbRemotePath']?.toString() ?? '';

    Widget thumbWidget;
    if (thumbLocal.isNotEmpty && File(thumbLocal).existsSync()) {
      thumbWidget = Image.file(
        File(thumbLocal),
        width: 180,
        height: 120,
        fit: BoxFit.cover,
      );
    } else if (thumbRemote.isNotEmpty) {
      thumbWidget = Image.network(
        thumbRemote,
        width: 180,
        height: 120,
        fit: BoxFit.cover,
        headers: {
          'Referer': 'https://www.chaoxing.com/',
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 14; Pixel 9 Pro Build/AP1A.240505.005)',
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: 180,
          height: 120,
          color: Colors.grey[300],
          child: const Icon(Icons.videocam, size: 40, color: Colors.grey),
        ),
      );
    } else {
      thumbWidget = Container(
        width: 180,
        height: 120,
        color: Colors.grey[800],
        child: Icon(
          Icons.videocam,
          size: 40,
          color: Colors.white.withValues(alpha: 0.6),
        ),
      );
    }

    final content = InkWell(
      onTap: () => _snack('视频播放功能开发中...'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _resolveSenderName(msg, isMe),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: thumbWidget,
                ),
                Icon(
                  Icons.play_circle_filled,
                  size: 48,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return _buildBaseRow(msg, isMe, content);
  }

  Widget _buildLocationBubble(_ChatMessage msg, bool isMe) {
    final theme = Theme.of(context);
    final content = InkWell(
      onTap: msg.rawData != null
          ? () {
              final lat = msg.rawData?['latitude']?.toString() ?? '';
              final lng = msg.rawData?['longitude']?.toString() ?? '';
              if (lat.isNotEmpty && lng.isNotEmpty) {
                _snack('位置: ${msg.content}\n坐标: $lat, $lng');
              } else {
                _snack(msg.content);
              }
            }
          : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _resolveSenderName(msg, isMe),
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.location_on,
                color: Colors.green[400],
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                msg.content,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
    return _buildBaseRow(msg, isMe, content);
  }

  Widget _buildActivityBubble(_ChatMessage msg) {
    final theme = Theme.of(context);
    final myEasemobId = _myEasemobId ?? '';
    final isMe = msg.senderId == myEasemobId;

    IconData iconData;
    Color iconColor;
    switch (msg.type) {
      case _MsgType.homework:
        iconData = Icons.assignment_outlined;
        iconColor = Colors.orange;
        break;
      case _MsgType.groupSignIn:
        iconData = Icons.event_available_outlined;
        iconColor = Colors.green;
        break;
      case _MsgType.courseActivity:
        iconData = Icons.notifications_outlined;
        iconColor = theme.colorScheme.primary;
        break;
      default:
        iconData = Icons.info_outlined;
        iconColor = Colors.grey;
    }

    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isMe
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _resolveSenderName(msg, isMe),
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  msg.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final wrappedContent = msg.rawData != null
        ? InkWell(
            onTap: () => _handleActivityTap(msg),
            borderRadius: BorderRadius.circular(12),
            child: content,
          )
        : content;

    return _buildBaseRow(msg, isMe, wrappedContent);
  }

  int _resolveActiveType(Map<String, dynamic> data) {
    final activeTypeValue = data['activeType'] is int
        ? data['activeType']
        : int.tryParse(data['activeType']?.toString() ?? '0') ?? 0;
    return activeTypeValue;
  }

  Future<void> _handleActivityTap(_ChatMessage msg) async {
    final data = msg.rawData;
    if (data == null) {
      _snack('无法打开活动');
      return;
    }

    final activeType = _resolveActiveType(data);
    final courseId =
        data['courseId']?.toString() ?? data['courseid']?.toString() ?? '';
    final classId =
        data['classId']?.toString() ?? data['classid']?.toString() ?? '';
    final cpi = data['cpi']?.toString() ?? '';
    final activeId =
        data['activeId']?.toString() ?? data['id']?.toString() ?? '';
    final activeUrl = data['url']?.toString() ?? '';
    final courseName =
        data['courseName']?.toString() ?? data['coursename']?.toString() ?? '';
    final activeName = msg.content;

    if (courseId.isEmpty || classId.isEmpty) {
      _snack('缺少课程信息');
      return;
    }

    final resolvedCpi = cpi.isNotEmpty
        ? cpi
        : await _resolveCpiFromCourses(courseId, classId);
    final resolvedCourseName = courseName.isNotEmpty
        ? courseName
        : await _resolveCourseName(courseId, classId);

    if (resolvedCpi.isEmpty) {
      if (!mounted) return;
      _snack('无法获取课程信息');
      return;
    }

    if (!mounted) return;

    if (PushCategory.isHomework(activeType)) {
      context.push(
        '/course/$courseId/homework?classId=$classId&cpi=$resolvedCpi',
      );
    } else if (activeType == 2 || activeType == 54 || activeType == 75) {
      if (activeId.isNotEmpty) {
        final encParam = data['enc']?.toString();
        context.push(
          '/signin/$activeId?courseId=$courseId&classId=$classId&cpi=$resolvedCpi${encParam != null ? '&enc=$encParam' : ''}',
        );
      } else {
        _snack('缺少活动ID');
      }
    } else if (activeType == 42 ||
        activeType == 43 ||
        activeType == 14 ||
        activeType == 5 ||
        activeType == 23 ||
        activeType == 68) {
      if (activeUrl.isNotEmpty) {
        final encodedUrl = Uri.encodeComponent(activeUrl);
        context.push(
          '/activity/$activeId?url=$encodedUrl&name=${Uri.encodeComponent(activeName)}&courseId=$courseId&classId=$classId',
        );
      } else if (activeId.isNotEmpty) {
        context.push('/quiz/$activeId?classId=$classId&courseId=$courseId');
      } else {
        _snack('缺少活动ID');
      }
    } else {
      context.push(
        '/course/$courseId?classId=$classId&cpi=$resolvedCpi&name=${Uri.encodeComponent(resolvedCourseName)}',
      );
    }
  }

  Future<String> _resolveCpiFromCourses(String courseId, String classId) async {
    try {
      final coursesResult = await AppDependencies.instance.courseRepo
          .getCourses();
      final courses = coursesResult.fold((l) => <Course>[], (r) => r);
      for (final course in courses) {
        if (course.courseId == courseId && course.classId == classId) {
          return course.cpi ?? '';
        }
      }
    } catch (e) {
      debugPrint('获取课程列表查找 cpi 失败: $e');
    }
    return '';
  }

  Future<String> _resolveCourseName(String courseId, String classId) async {
    try {
      final coursesResult = await AppDependencies.instance.courseRepo
          .getCourses();
      final courses = coursesResult.fold((l) => <Course>[], (r) => r);
      for (final course in courses) {
        if (course.courseId == courseId && course.classId == classId) {
          return course.name;
        }
      }
    } catch (e) {
      debugPrint('获取课程列表查找课程名称失败: $e');
    }
    return '';
  }

  Future<void> _ensureImLoggedIn() async {
    final im = AppDependencies.instance.imService;
    if (im.isLoggedIn) return;

    try {
      final sessionIdResult = AppDependencies.instance.accountRepo
          .getCurrentSessionId();
      final sessionId = sessionIdResult.fold((_) => null, (id) => id);
      if (sessionId != null) {
        final accountResult = AppDependencies.instance.accountRepo
            .getAccountById(sessionId);
        User? currentUser;
        accountResult.fold((_) {}, (user) => currentUser = user);
        if (currentUser != null && currentUser!.imAccount != null) {
          await im.loginCurrentUser(
            sessionId: sessionId,
            userName: currentUser!.imAccount!.userName,
            password: currentUser!.imAccount!.password,
          );
        }
      }
    } catch (e) {
      debugPrint('IM登录失败: $e');
    }
  }

  Future<void> _sendText() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _msgCtrl.clear();
    _closeAttachmentPanel();

    try {
      await _ensureImLoggedIn();
      if (!AppDependencies.instance.imService.isLoggedIn) {
        throw Exception('环信IM登录失败，无法发送消息');
      }

      final message = EMMessage.createTxtSendMessage(
        targetId: widget.chatId,
        content: text,
        chatType: _chatType,
      );

      if (_myDisplayName != null) {
        message.attributes = {
          'senderName': _myDisplayName,
          'senderAvatar': _myAvatarUrl ?? '',
        };
      }

      await EMClient.getInstance.chatManager.sendMessage(message);

      final localMsg = _ChatMessage(
        msgId: message.msgId,
        senderId: _myChatPuid ?? 'me',
        senderName: _myDisplayName ?? '我',
        senderAvatar: _myAvatarUrl ?? '',
        content: text,
        type: _MsgType.text,
        timestamp: DateTime.fromMillisecondsSinceEpoch(message.localTime),
      );

      if (mounted) {
        setState(() => _messages.add(localMsg));
        _scrollToBottom();
        _debouncedSaveToCache();
      }
    } on EMError catch (e) {
      debugPrint('发送消息失败(EMError): code=${e.code}, desc=${e.description}');
      if (mounted) {
        if (e.code == 8 || e.code == 9) {
          _snack('您不是该群组成员，无法发送消息');
        } else {
          _snack('发送失败: ${e.description}');
        }
      }
    } catch (e) {
      if (mounted) _snack('发送失败: $e');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _sendImageMessage(String imagePath) async {
    if (_isSending) return;
    setState(() => _isSending = true);
    _closeAttachmentPanel();

    try {
      await _ensureImLoggedIn();
      if (!AppDependencies.instance.imService.isLoggedIn) {
        throw Exception('环信IM登录失败');
      }

      final message = EMMessage.createImageSendMessage(
        targetId: widget.chatId,
        filePath: imagePath,
        chatType: _chatType,
      );
      if (_myDisplayName != null) {
        message.attributes = {
          'senderName': _myDisplayName,
          'senderAvatar': _myAvatarUrl ?? '',
        };
      }
      await EMClient.getInstance.chatManager.sendMessage(message);
      final body = message.body as EMImageMessageBody;
      final localMsg = _ChatMessage(
        msgId: message.msgId,
        senderId: _myChatPuid ?? 'me',
        senderName: _myDisplayName ?? '我',
        senderAvatar: _myAvatarUrl ?? '',
        content: '图片',
        type: _MsgType.image,
        timestamp: DateTime.fromMillisecondsSinceEpoch(message.localTime),
        rawData: {
          'localPath': imagePath,
          'remotePath': body.remotePath,
          'displayName': '图片',
          'fileSize': 0,
        },
      );
      if (mounted) {
        setState(() => _messages.add(localMsg));
        _scrollToBottom();
        _debouncedSaveToCache();
      }
    } catch (e) {
      if (mounted) _snack('发送图片失败: $e');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _sendImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null || !mounted) return;
    await _sendImageMessage(picked.path);
  }

  Future<void> _takePhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked == null || !mounted) return;
    await _sendImageMessage(picked.path);
  }

  Future<void> _sendFile() async {
    _closeAttachmentPanel();
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result == null || result.files.isEmpty || !mounted) return;
      final file = result.files.first;
      final path = file.path;
      if (path == null) return;

      await _sendFileMessage(path);
    } catch (e) {
      if (mounted) _snack('选择文件失败: $e');
    }
  }

  Future<void> _sendFileMessage(String filePath) async {
    if (_isSending) return;
    setState(() => _isSending = true);

    try {
      final file = File(filePath);
      final fileSize = await file.length();
      final fileName = filePath.split(Platform.pathSeparator).last;
      final fileSuffix = fileName.contains('.')
          ? fileName.split('.').last.toLowerCase()
          : '';
      final puid = _myChatPuid ?? '';

      final uploadToken = await AppDependencies.instance.cxPanApi
          .getUploadToken();
      if (uploadToken == null) {
        throw Exception('获取云盘上传token失败');
      }

      final crc = await AppDependencies.instance.cxPanApi.computeFileCrc(file);

      final exists = await AppDependencies.instance.cxPanApi.checkCrcExists(
        crc,
        uploadToken,
      );

      Map<String, dynamic>? uploadResult;
      if (exists) {
        uploadResult = {
          'result': true,
          'data': {
            'crc': crc,
            'name': fileName,
            'size': fileSize,
            'suffix': fileSuffix,
            'puid': puid,
            'uploadDate': DateTime.now().millisecondsSinceEpoch,
          },
        };
      } else {
        uploadResult = await AppDependencies.instance.cxPanApi
            .uploadFileForChat(file, uploadToken, (progress) {
              debugPrint(
                '[GroupChat] 云盘上传进度: ${(progress * 100).toStringAsFixed(1)}%',
              );
            });
      }

      if (uploadResult == null || uploadResult['result'] != true) {
        throw Exception('云盘上传失败: ${uploadResult?['msg'] ?? '未知错误'}');
      }

      final data =
          uploadResult['data'] as Map<String, dynamic>? ?? uploadResult;
      final objectId = data['objectId']?.toString() ?? '';
      final resid = data['resid'];
      final residStr = resid?.toString() ?? '';
      final respCrc = data['crc']?.toString() ?? crc;
      final size = data['size']?.toString() ?? fileSize.toString();
      final preview = data['preview']?.toString() ?? '';
      final thumbnail = data['thumbnail']?.toString() ?? '';
      final uploadDateStr =
          data['uploadDate']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
      final name = data['name']?.toString() ?? fileName;

      if (objectId.isEmpty) {
        throw Exception('云盘上传成功但objectId为空');
      }

      await _ensureImLoggedIn();
      if (!AppDependencies.instance.imService.isLoggedIn) {
        throw Exception('环信IM登录失败');
      }

      final fileId = objectId;

      final infoJson = {
        'audit': false,
        'cloudType': 0,
        'crc': respCrc,
        'creator': puid,
        'duration': 0,
        'extinfo': '',
        'filepath': '',
        'filetype': '',
        'forbidDownload': 0,
        'height': 0,
        'isMirror': 0,
        'isempty': false,
        'isfile': true,
        'name': name,
        'objectId': objectId,
        'parentPath': jsonEncode({'objectId': objectId}),
        'preview': preview,
        'puid': puid,
        'resid': residStr,
        'restype': 'RES_TYPE_NORMAL',
        'size': size,
        'sort': 0,
        'suffix': fileSuffix,
        'thumbnail': thumbnail,
        'topsort': 0,
        'uploadDate': uploadDateStr,
        'width': 0,
      };

      final attClouddisk = {
        'crc': respCrc,
        'duration': 0,
        'extinfo': '',
        'fileId': fileId,
        'fileSize': _formatFileSize(fileSize),
        'forbidDownload': 0,
        'infoJsonStr': jsonEncode(infoJson),
        'isMirror': 0,
        'isfile': true,
        'modtime': uploadDateStr,
        'name': name,
        'objectId': objectId,
        'parentPath': jsonEncode({'objectId': objectId}),
        'preview': preview,
        'puid': puid,
        'resid': residStr,
        'size': size,
        'suffix': fileSuffix,
        'thumbnail': thumbnail,
      };

      final attachmentObj = {
        'att_clouddisk': attClouddisk,
        'attachmentType': 18,
      };

      final attachmentJson = jsonEncode(attachmentObj);

      final message = EMMessage.createTxtSendMessage(
        targetId: widget.chatId,
        content: '[文件]',
        chatType: _chatType,
      );
      message.attributes = {
        'fromPuid': puid,
        'attachment': attachmentJson,
        'em_apns_ext': {
          'em_huawei_push_badge_class':
              'com.chaoxing.mobile.activity.SplashActivity',
        },
        'senderName': _myDisplayName ?? '',
        'senderAvatar': _myAvatarUrl ?? '',
      };

      await EMClient.getInstance.chatManager.sendMessage(message);

      final parsed = _ChatMessage(
        msgId: message.msgId,
        senderId: _myChatPuid ?? 'me',
        senderName: _myDisplayName ?? '我',
        senderAvatar: _myAvatarUrl ?? '',
        content: '$fileName (${_formatFileSize(fileSize)})',
        type: _MsgType.file,
        timestamp: DateTime.fromMillisecondsSinceEpoch(message.localTime),
        rawData: {
          'localPath': filePath,
          'remotePath': preview,
          'displayName': fileName,
          'fileSize': fileSize,
          'fileId': fileId,
          'objectId': objectId,
          'resid': residStr,
        },
      );
      if (mounted) {
        setState(() {
          _messages.add(parsed);
          _showAttachmentPanel = false;
        });
        _scrollToBottom();
        _debouncedSaveToCache();
      }
    } catch (e) {
      debugPrint('[GroupChat] 发送文件失败: $e');
      if (mounted) _snack('发送文件失败: $e');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _startRecording() async {
    try {
      if (!await _audioRecorder.hasPermission()) {
        _snack('需要麦克风权限');
        return;
      }
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 16000,
        ),
        path: path,
      );
      setState(() {
        _isRecording = true;
        _recordingStartTime = DateTime.now();
      });
    } catch (e) {
      _snack('录音失败: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      if (path == null || !mounted) {
        setState(() {
          _isRecording = false;
          _recordingStartTime = null;
        });
        return;
      }
      final file = File(path);
      if (!file.existsSync()) {
        setState(() {
          _isRecording = false;
          _recordingStartTime = null;
        });
        return;
      }
      final fileSize = await file.length();
      if (fileSize < 100) {
        await file.delete();
        setState(() {
          _isRecording = false;
          _recordingStartTime = null;
        });
        return;
      }

      int actualDuration = 0;
      try {
        final player = AudioPlayer();
        await player.setSourceDeviceFile(path);
        final duration = await player.getDuration();
        if (duration != null) {
          actualDuration = duration.inMilliseconds;
        }
        await player.dispose();
      } catch (e) {
        debugPrint('获取语音时长失败: $e, 使用录制时间差');
        actualDuration = DateTime.now()
            .difference(_recordingStartTime ?? DateTime.now())
            .inMilliseconds;
      }

      if (actualDuration < 500) {
        await file.delete();
        _snack('录音时间太短');
        setState(() {
          _isRecording = false;
          _recordingStartTime = null;
        });
        return;
      }
      await _sendVoiceMessage(path, actualDuration);
    } catch (e) {
      _snack('停止录音失败: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isRecording = false;
          _recordingStartTime = null;
        });
      }
    }
  }

  Future<void> _sendVoiceMessage(String audioPath, int duration) async {
    if (_isSending) return;
    setState(() => _isSending = true);
    _closeAttachmentPanel();

    try {
      await _ensureImLoggedIn();
      if (!AppDependencies.instance.imService.isLoggedIn) {
        throw Exception('环信IM登录失败');
      }

      final message = EMMessage.createVoiceSendMessage(
        targetId: widget.chatId,
        filePath: audioPath,
        duration: duration,
        chatType: _chatType,
      );
      if (_myDisplayName != null) {
        message.attributes = {
          'senderName': _myDisplayName,
          'senderAvatar': _myAvatarUrl ?? '',
        };
      }
      await EMClient.getInstance.chatManager.sendMessage(message);
      final durationSec = (duration / 1000).round();
      final body = message.body as EMVoiceMessageBody;
      final localMsg = _ChatMessage(
        msgId: message.msgId,
        senderId: _myChatPuid ?? 'me',
        senderName: _myDisplayName ?? '我',
        senderAvatar: _myAvatarUrl ?? '',
        content: '语音消息 (${durationSec}s)',
        type: _MsgType.voice,
        timestamp: DateTime.fromMillisecondsSinceEpoch(message.localTime),
        rawData: {
          'localPath': audioPath,
          'remotePath': body.remotePath,
          'duration': duration,
        },
      );
      if (mounted) {
        setState(() => _messages.add(localMsg));
        _scrollToBottom();
        _debouncedSaveToCache();
      }
    } catch (e) {
      _snack('发送语音失败: $e');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _sendLocation() async {
    _closeAttachmentPanel();

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const LocationSelectPage()),
    );

    if (result == null || !mounted) return;

    final latitude = result['latitude'] as String? ?? '';
    final longitude = result['longitude'] as String? ?? '';
    final address = result['address'] as String? ?? '';
    final name = result['name'] as String? ?? '';

    if (latitude.isEmpty || longitude.isEmpty) {
      _snack('位置信息不完整');
      return;
    }

    await _sendLocationMessage(
      latitude: latitude,
      longitude: longitude,
      address: address,
      name: name,
    );
  }

  Future<void> _sendLocationMessage({
    required String latitude,
    required String longitude,
    required String address,
    required String name,
  }) async {
    setState(() => _isSending = true);

    try {
      final userResult = await AppDependencies.instance.storage.getString(
        'user',
      );
      String? userJson;
      userResult.fold((_) => null, (json) => userJson = json);

      if (userJson == null || userJson!.isEmpty) {
        _snack('未获取到用户信息');
        return;
      }

      final userData = jsonDecode(userJson!) as Map<String, dynamic>;
      final sendId = userData['puid']?.toString() ?? '';
      final receiveId = widget.chatId;
      final chatName = _displayName;
      final chatIco = _myAvatarUrl ?? '';

      if (sendId.isEmpty) {
        _snack('未获取到用户ID');
        return;
      }

      final response = await AppDependencies.instance.cxChatApi
          .sendLocationMessage(
            sendId: sendId,
            receiveId: receiveId,
            chatName: chatName,
            chatIco: chatIco,
            latitude: latitude,
            longitude: longitude,
            address: address,
            name: name,
          );

      if (response['result'] == true) {
        await _ensureImLoggedIn();

        final msg = EMMessage.createTxtSendMessage(
          targetId: widget.chatId,
          content: '[位置] $name',
          chatType: _chatType,
        );
        msg.attributes = {
          'location': {
            'latitude': latitude,
            'longitude': longitude,
            'address': address,
            'name': name,
          },
          'senderName': _myDisplayName ?? '',
          'senderAvatar': _myAvatarUrl ?? '',
        };
        await EMClient.getInstance.chatManager.sendMessage(msg);

        final parsed = _ChatMessage(
          msgId: msg.msgId,
          senderId: _myChatPuid ?? 'me',
          senderName: _myDisplayName ?? '我',
          senderAvatar: _myAvatarUrl ?? '',
          content: address.isNotEmpty ? address : '$latitude, $longitude',
          type: _MsgType.location,
          timestamp: DateTime.fromMillisecondsSinceEpoch(msg.localTime),
          rawData: {
            'latitude': latitude,
            'longitude': longitude,
            'address': address,
            'name': name,
          },
        );
        if (mounted) {
          setState(() => _messages.add(parsed));
          _scrollToBottom();
          _debouncedSaveToCache();
        }
      } else {
        _snack('发送位置失败: ${response['msg']}');
      }
    } catch (e) {
      if (mounted) _snack('发送位置失败: $e');
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _closeAttachmentPanel() {
    if (_showAttachmentPanel) {
      setState(() => _showAttachmentPanel = false);
    }
  }

  void _snack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), duration: const Duration(seconds: 3)),
      );
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  Widget _buildAttachmentPanel() {
    if (!_showAttachmentPanel) {
      return const SizedBox.shrink();
    }
    final items = [
      {'icon': Icons.image, 'label': '相册', 'action': _sendImage},
      {'icon': Icons.camera_alt, 'label': '拍摄', 'action': _takePhoto},
      {'icon': Icons.insert_drive_file, 'label': '文件', 'action': _sendFile},
      {'icon': Icons.mic, 'label': '语音', 'action': _startRecording},
      {'icon': Icons.location_on, 'label': '位置', 'action': _sendLocation},
    ];
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 16,
        children: items.map((item) {
          return GestureDetector(
            onTap: () => (item['action'] as Function())(),
            onLongPress: item['label'] == '语音' ? _startRecording : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item['label'] as String,
                  style: const TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecordingOverlay() {
    if (!_isRecording) return const SizedBox.shrink();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_isRecording) _stopRecording();
      },
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mic, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  '正在录音...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  '点击此处或松开手指停止录音',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_isRecording) _stopRecording();
                  },
                  icon: const Icon(Icons.stop),
                  label: const Text('停止录音'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () async {
                    if (_isRecording) {
                      final path = await _audioRecorder.stop();
                      if (path != null) {
                        final file = File(path);
                        if (file.existsSync()) {
                          await file.delete();
                        }
                      }
                      if (mounted) {
                        setState(() {
                          _isRecording = false;
                          _recordingStartTime = null;
                        });
                      }
                    }
                  },
                  child: const Text('取消录音'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_displayName),
            Text(
              _isGroup ? '$_displayMemberCount人' : '私聊',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDnd ? Icons.notifications_off : Icons.notifications,
              color: _isDnd
                  ? Colors.white.withValues(alpha: 0.5)
                  : Colors.white,
            ),
            tooltip: _isDnd ? '开启通知' : '免打扰',
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await DndService().toggleDnd(widget.chatId);
              if (!mounted) return;
              setState(() => _isDnd = !_isDnd);
              messenger.showSnackBar(
                SnackBar(
                  content: Text(_isDnd ? '已开启免打扰' : '已关闭免打扰'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text('暂无消息'))
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _bubble(_messages[i]),
                  ),
          ),
          _buildAttachmentPanel(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(
                      () => _showAttachmentPanel = !_showAttachmentPanel,
                    );
                  },
                  icon: Icon(
                    Icons.add_circle,
                    size: 32,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    enabled: !_isRecording,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: '输入消息...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    maxLines: null,
                    onSubmitted: (_) => _sendText(),
                  ),
                ),
                const SizedBox(width: 8),
                _isSending
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : GestureDetector(
                        onLongPress: () {
                          if (!_isRecording) _startRecording();
                        },
                        onLongPressUp: () {
                          if (_isRecording) _stopRecording();
                        },
                        child: IconButton(
                          onPressed: _msgCtrl.text.isNotEmpty
                              ? _sendText
                              : null,
                          icon: _isRecording
                              ? const Icon(Icons.stop)
                              : const Icon(Icons.send),
                          color: _isRecording
                              ? Colors.red
                              : theme.colorScheme.primary,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildRecordingOverlay(),
    );
  }
}

class _GroupMemberInfo {
  final String uid;
  final String name;
  final String avatar;
  const _GroupMemberInfo({required this.uid, this.name = '', this.avatar = ''});
}

class _ChatMessage {
  final String msgId;
  final String senderId;
  final String senderName;
  String senderAvatar;
  final String content;
  final _MsgType type;
  final DateTime timestamp;
  final Map<String, dynamic>? rawData;

  _ChatMessage({
    required this.msgId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.type,
    required this.timestamp,
    this.rawData,
  });

  Map<String, dynamic> toJson() => {
    'msgId': msgId,
    'senderId': senderId,
    'senderName': senderName,
    'senderAvatar': senderAvatar,
    'content': content,
    'type': type.index,
    'timestamp': timestamp.millisecondsSinceEpoch,
    if (rawData != null) 'rawData': rawData,
  };

  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _ChatMessage(
    msgId: json['msgId'] ?? '',
    senderId: json['senderId'] ?? '',
    senderName: json['senderName'] ?? '',
    senderAvatar: json['senderAvatar'] ?? '',
    content: json['content'] ?? '',
    type: _MsgType.values[json['type'] ?? 0],
    timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] ?? 0),
    rawData: json['rawData'] != null
        ? Map<String, dynamic>.from(json['rawData'])
        : null,
  );
}

class _AvatarCache {
  static final Map<String, Future<Uint8List?>> _cache = {};
  static final Set<String> _loadingUrls = {};
  static final Set<String> _failedUrls = {};

  static void clearFailedUrls() {
    _failedUrls.clear();
  }

  static Future<Uint8List?> getImage(String url) async {
    if (_cache.containsKey(url)) return _cache[url]!;
    if (_loadingUrls.contains(url)) {
      await Future.delayed(const Duration(milliseconds: 50));
      return getImage(url);
    }
    if (_failedUrls.contains(url)) return null;

    _loadingUrls.add(url);
    final future = _fetchImage(url).whenComplete(() {
      _loadingUrls.remove(url);
    });
    _cache[url] = future;
    return future;
  }

  static Future<Uint8List?> _fetchImage(String url) async {
    try {
      final client = AppDependencies.instance.dioClient;
      final response = await client.sendRequest(
        url,
        responseType: ResponseType.bytes,
        headers: {
          'Referer': url.contains('im.chaoxing.com')
              ? 'https://im.chaoxing.com/'
              : url.contains('ananas.chaoxing.com')
              ? 'https://mooc1.chaoxing.com/'
              : 'https://www.chaoxing.com/',
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 14; Pixel 9 Pro Build/AP1A.240505.005)',
        },
      );

      if (response.data != null && response.data is List<int>) {
        final bytes = response.data is Uint8List
            ? response.data as Uint8List
            : Uint8List.fromList(response.data as List<int>);
        if (bytes.length < 4) {
          _failedUrls.add(url);
          return null;
        }
        final isPng = bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E;
        final isJpg = bytes[0] == 0xFF && bytes[1] == 0xD8;
        final isGif = bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46;
        if (!isPng && !isJpg && !isGif) {
          _failedUrls.add(url);
          return null;
        }
        return bytes;
      }
      _failedUrls.add(url);
      return null;
    } catch (e) {
      _failedUrls.add(url);
      return null;
    }
  }
}

class _ChatAvatar extends StatefulWidget {
  final String imageUrl;
  final double size;
  final double borderRadius;
  final double iconSize;

  const _ChatAvatar({
    required this.imageUrl,
    this.size = 32,
    this.borderRadius = 16,
    this.iconSize = 20,
  });

  @override
  State<_ChatAvatar> createState() => _ChatAvatarState();
}

class _ChatAvatarState extends State<_ChatAvatar> {
  Uint8List? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _ChatAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _data = null;
      _loading = true;
      _load();
    }
  }

  Future<void> _load() async {
    if (widget.imageUrl.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    final cached = await _AvatarCache.getImage(widget.imageUrl);
    if (mounted) {
      setState(() {
        _data = cached;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        width: widget.size,
        height: widget.size,
        color: Colors.grey[200],
        child: _loading
            ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
            : _data != null
            ? Image.memory(_data!, fit: BoxFit.cover)
            : Icon(Icons.person, size: widget.iconSize, color: Colors.grey),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import '../../app_dependencies.dart';
import '../../data/datasources/remote/chaoxing/cx_friend_contact_api.dart';
import '../../infra/services/dnd_service.dart';
import '../../infra/services/member_name_cache.dart';
import '../providers/providers.dart';
import '../widgets/network_image.dart';
import '../widgets/staggered_animation.dart';
import 'scan_page.dart';
import 'group_chat_page.dart';
import 'notice_inbox_page.dart';
import 'search_add_friend_page.dart';

final _dndService = DndService();

String _getCacheKey() {
  final sessionId = AppDependencies.instance.accountRepo
      .getCurrentSessionId()
      .fold((_) => 'default', (id) => id);
  return 'group_list_cache_$sessionId';
}

class GroupListPage extends ConsumerStatefulWidget {
  const GroupListPage({super.key});
  @override
  ConsumerState<GroupListPage> createState() => GroupListPageState();
}

class GroupListPageState extends ConsumerState<GroupListPage>
    with SingleTickerProviderStateMixin {
  final List<_ConvInfo> _conversations = [];
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(true);
  bool _hasLoadedOnce = false;
  bool _isLoadingConv = false;
  String? _error;
  late TabController _tabCtrl;
  StreamSubscription<EMMessage>? _msgSub;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _loadFromCache();
    _loadConversations();
    _subscribeMessages();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _isLoadingNotifier.dispose();
    _msgSub?.cancel();
    super.dispose();
  }

  void _subscribeMessages() {
    try {
      _msgSub = AppDependencies.instance.imService.onNewMessage.listen((msg) {
        if (mounted) {
          _onNewMessageReceived(msg);
        }
      });
    } catch (_) {}
  }

  void onVisibilityChanged() {
    if (mounted) {
      _loadConversations();
    }
  }

  void _onNewMessageReceived(EMMessage message) {
    if (_conversations.isEmpty && !_hasLoadedOnce) {
      _loadConversations();
      return;
    }

    final chatId = message.conversationId ?? message.to;
    if (chatId == null) return;

    final isGroup = message.chatType == ChatType.GroupChat;
    final index = _conversations.indexWhere((c) => c.id == chatId);

    String lastMessageText = '';
    if (message.body is EMTextMessageBody) {
      lastMessageText = (message.body as EMTextMessageBody).content;
    } else if (message.body is EMImageMessageBody) {
      lastMessageText = '[图片]';
    } else if (message.body is EMFileMessageBody) {
      lastMessageText =
          '[文件: ${(message.body as EMFileMessageBody).displayName ?? "文件"}]';
    } else if (message.body is EMVoiceMessageBody) {
      lastMessageText = '[语音]';
    } else if (message.body is EMVideoMessageBody) {
      lastMessageText = '[视频]';
    } else if (message.body is EMLocationMessageBody) {
      lastMessageText = '[位置]';
    } else if (message.body is EMCustomMessageBody) {
      lastMessageText = '[${(message.body as EMCustomMessageBody).event}]';
    } else {
      return;
    }

    if (lastMessageText.isEmpty) return;

    if (isGroup) {
      final sender = message.from;
      if (sender != null && sender.isNotEmpty) {
        final userName = _resolveSenderNameFromMessage(message, sender);
        if (userName.isNotEmpty && userName != sender) {
          lastMessageText = '$userName: $lastMessageText';
        }
      }
    }

    if (lastMessageText.length > 30) {
      lastMessageText = '${lastMessageText.substring(0, 30)}...';
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    if (index == -1) {
      unawaited(
        _buildConvInfoFromMessage(message, chatId, isGroup).then((convInfo) {
          if (convInfo != null && mounted) {
            setState(() {
              _conversations.insert(0, convInfo);
            });
            _saveToCache();
          }
        }),
      );
      return;
    }

    final existing = _conversations[index];
    final updated = _ConvInfo(
      id: existing.id,
      name: existing.name,
      icon: existing.icon,
      isGroup: existing.isGroup,
      unread: existing.unread + 1,
      lastMsg: lastMessageText,
      time: now,
      memberCount: existing.memberCount,
      courseId: existing.courseId,
    );

    setState(() {
      _conversations.removeAt(index);
      _conversations.insert(0, updated);
    });
    _saveToCache();
  }

  Future<_ConvInfo?> _buildConvInfoFromMessage(
    EMMessage message,
    String chatId,
    bool isGroup,
  ) async {
    String name = chatId;
    String icon = '';
    int memberCount = 0;
    String? courseId;

    try {
      if (isGroup) {
        final groupInfo = await _loadGroupInfo(chatId);
        name = groupInfo['displayName'] as String? ?? chatId;
        icon = groupInfo['displayIcon'] as String? ?? '';
        memberCount = groupInfo['memberCount'] as int? ?? 0;
        courseId = groupInfo['courseId'] as String?;
      } else {
        final privateInfo = await _loadPrivateInfo(chatId);
        name = privateInfo['displayName'] as String? ?? chatId;
        icon = privateInfo['displayIcon'] as String? ?? '';
      }
    } catch (_) {}

    return _ConvInfo(
      id: chatId,
      name: name,
      icon: icon,
      isGroup: isGroup,
      unread: 1,
      lastMsg: message.body is EMTextMessageBody
          ? (message.body as EMTextMessageBody).content
          : '[新消息]',
      time: message.serverTime > 0
          ? message.serverTime
          : DateTime.now().millisecondsSinceEpoch,
      memberCount: memberCount,
      courseId: courseId,
    );
  }

  Future<void> _loadFromCache() async {
    try {
      final cacheKey = _getCacheKey();
      final result = await AppDependencies.instance.storage.getString(cacheKey);
      result.fold(
        (failure) {
          debugPrint('加载群组缓存失败: $failure');
        },
        (cached) {
          if (cached != null && cached.isNotEmpty) {
            final list = jsonDecode(cached) as List<dynamic>;
            final convs = list
                .map((e) => _ConvInfo.fromJson(e as Map<String, dynamic>))
                .toList();
            if (mounted && convs.isNotEmpty) {
              setState(() {
                _conversations.clear();
                _conversations.addAll(convs);
                _isLoadingNotifier.value = false;
              });
              debugPrint('从缓存加载了 ${convs.length} 个会话');
            }
          }
        },
      );
    } catch (e) {
      debugPrint('加载群组缓存失败: $e');
    }
  }

  Future<void> _saveToCache() async {
    try {
      final data = jsonEncode(_conversations.map((c) => c.toJson()).toList());
      final cacheKey = _getCacheKey();
      await AppDependencies.instance.storage.setString(cacheKey, data);
      debugPrint('群组缓存已保存 (${_conversations.length} 个)');
    } catch (e) {
      debugPrint('保存群组缓存失败: $e');
    }
  }

  Future<void> _loadConversations() async {
    if (!mounted) return;
    if (_isLoadingConv) return;
    _isLoadingConv = true;

    final isFirstLoad = !_hasLoadedOnce;
    if (isFirstLoad && _conversations.isEmpty) {
      setState(() => _isLoadingNotifier.value = true);
    }
    setState(() => _error = null);

    try {
      await _ensureIMLoggedIn();

      if (!AppDependencies.instance.imService.isLoggedIn) {
        debugPrint('IM未登录，无法加载群组列表');
        if (mounted) {
          setState(() {
            _isLoadingNotifier.value = false;
            _conversations.clear();
          });
        }
        return;
      }

      // ignore: deprecated_member_use_from_same_package
      final conversations = await EMClient.getInstance.chatManager
          .getConversationsFromServer();
      debugPrint('获取到 ${conversations.length} 个会话');

      final results = await Future.wait(
        conversations.map((conv) => _buildConvInfo(conv)),
      );

      final validConvs = results
          .where((r) => r != null)
          .cast<_ConvInfo>()
          .toList();
      validConvs.sort((a, b) => b.time.compareTo(a.time));

      if (mounted) {
        setState(() {
          _conversations.clear();
          _conversations.addAll(validConvs);
          _hasLoadedOnce = true;
          _isLoadingNotifier.value = false;
        });
      }

      _saveToCache();
    } catch (e, stack) {
      debugPrint('加载会话列表失败: $e');
      debugPrint('错误堆栈: $stack');
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingConv = false;
          _isLoadingNotifier.value = false;
        });
      }
    }
  }

  Future<void> _ensureIMLoggedIn() async {
    try {
      final im = AppDependencies.instance.imService;
      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      if (session == null) return;

      final user = AppDependencies.instance.accountRepo
          .getAccountById(session)
          .fold((_) => null, (u) => u);
      if (user == null || user.imAccount == null) return;

      if (!im.isLoggedIn) {
        await im.login(user.imAccount!.userName, user.imAccount!.password);
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (e) {
      debugPrint('IM登录异常: $e');
    }
  }

  Future<_ConvInfo?> _buildConvInfo(EMConversation conv) async {
    final isGroup = conv.type == EMConversationType.GroupChat;

    String name = conv.id;
    String icon = '';
    int unread = 0;
    String lastMsg = '';
    int lastTime = 0;
    int memberCount = 0;
    String? courseId;

    try {
      if (isGroup) {
        final groupInfo = await _loadGroupInfo(conv.id);
        name = groupInfo['displayName'] as String? ?? conv.id;
        icon = groupInfo['displayIcon'] as String? ?? '';
        memberCount = groupInfo['memberCount'] as int? ?? 0;
        courseId = groupInfo['courseId'] as String?;
      } else {
        final privateInfo = await _loadPrivateInfo(conv.id);
        name = privateInfo['displayName'] as String? ?? conv.id;
        icon = privateInfo['displayIcon'] as String? ?? '';
      }

      final lastResult = await _loadLastMessage(conv, isGroup);
      lastMsg = lastResult['lastMessage'] as String? ?? '';
      lastTime = lastResult['lastMsgTime'] as int? ?? 0;

      unread = await conv.unreadCount();
    } catch (e) {
      debugPrint('构建会话信息失败: $e');
    }

    final updateTime = lastTime > 0
        ? DateTime.fromMillisecondsSinceEpoch(lastTime)
        : DateTime.now();

    return _ConvInfo(
      id: conv.id,
      name: name,
      icon: icon,
      isGroup: isGroup,
      unread: unread,
      lastMsg: lastMsg,
      time: updateTime.millisecondsSinceEpoch,
      memberCount: memberCount,
      courseId: courseId,
    );
  }

  Future<Map<String, dynamic>> _loadGroupInfo(String convId) async {
    String displayName = convId;
    String displayIcon = '';
    int memberCount = 0;
    String? courseId;

    try {
      final groupInfo = await EMClient.getInstance.groupManager
          .fetchGroupInfoFromServer(convId);

      String groupName = (groupInfo.groupName?.isNotEmpty == true)
          ? groupInfo.groupName!
          : convId;
      String groupIcon = groupInfo.avatarUrl ?? '';
      memberCount = groupInfo.memberCount ?? 0;

      final String? extJson = groupInfo.desc?.isNotEmpty == true
          ? groupInfo.desc
          : (groupInfo.extension?.isNotEmpty == true
                ? groupInfo.extension
                : null);

      if (extJson != null && extJson.isNotEmpty) {
        try {
          final ext = jsonDecode(extJson) as Map<String, dynamic>;
          final courseInfo = ext['courseInfo'];
          if (courseInfo != null) {
            final coursename = courseInfo['coursename'];
            if (coursename != null && coursename.toString().isNotEmpty) {
              groupName = coursename.toString();
            }
            courseId = courseInfo['courseid']?.toString();
            final imageUrl = courseInfo['imageUrl'];
            if (imageUrl != null && imageUrl.toString().isNotEmpty) {
              groupIcon = imageUrl.toString();
            }
          }
          if (groupIcon.isEmpty) {
            groupIcon = ext['groupIcon']?.toString() ?? '';
          }
        } catch (e) {
          debugPrint('解析群组ext失败: $e');
        }
      }

      if (groupIcon.isEmpty) {
        groupIcon = 'https://im.chaoxing.com/res/images/course_logo.png';
      }

      displayName = groupName;
      displayIcon = groupIcon;
    } catch (e) {
      debugPrint('获取群组 $convId 详情失败: $e');
    }

    return {
      'displayName': displayName,
      'displayIcon': displayIcon,
      'memberCount': memberCount,
      'courseId': courseId,
    };
  }

  Future<Map<String, dynamic>> _loadPrivateInfo(String convId) async {
    String? cachedName = MemberNameCache().get(convId);
    String displayName =
        (cachedName != null && cachedName.isNotEmpty && cachedName != convId)
        ? cachedName
        : '用户$convId';
    String displayIcon = '';

    try {
      final cachedAvatar = MemberNameCache().getAvatar(convId);
      if (cachedAvatar != null && cachedAvatar.isNotEmpty) {
        displayIcon = cachedAvatar;
      }

      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      final puid = session ?? '';
      final userInfo = await AppDependencies.instance.cxGroupImApi
          .getUserInfoByTuid(tuid: convId, puid: puid, token: '');
      if (userInfo != null) {
        if (userInfo.name.isNotEmpty &&
            userInfo.name != convId &&
            (displayName == '用户$convId' || displayName.isEmpty)) {
          displayName = userInfo.name;
          MemberNameCache().set(convId, userInfo.name);
          debugPrint('私聊 $convId 获取到昵称: $displayName');
        }
        if (userInfo.picUrl.isNotEmpty) {
          final avatarUrl = userInfo.picUrl.startsWith('http://')
              ? userInfo.picUrl.replaceFirst('http://', 'https://')
              : userInfo.picUrl;
          displayIcon = avatarUrl;
          MemberNameCache().setAvatar(convId, avatarUrl);
        } else if (displayIcon.isEmpty) {
          displayIcon = 'https://im.chaoxing.com/res/images/course_logo.png';
        }
      } else if (displayIcon.isEmpty) {
        displayIcon = 'https://im.chaoxing.com/res/images/course_logo.png';
      }
    } catch (e) {
      debugPrint('处理个人会话 $convId 失败: $e');
      if (displayIcon.isEmpty) {
        displayIcon = 'https://im.chaoxing.com/res/images/course_logo.png';
      }
    }

    return {'displayName': displayName, 'displayIcon': displayIcon};
  }

  String _resolveSenderNameFromMessage(EMMessage message, String senderId) {
    String userName = '';
    if (message.attributes != null && message.attributes is Map) {
      final attrMap = message.attributes as Map;
      final displayNameAttr = attrMap['displayName'];
      if (displayNameAttr != null && displayNameAttr.toString().isNotEmpty) {
        userName = displayNameAttr.toString();
        MemberNameCache().set(senderId, userName);
        unawaited(MemberNameCache().saveToStorage());
        debugPrint('群列表从消息属性解析到昵称 $senderId: $userName');
      }
    }
    if (userName.isEmpty) {
      userName = MemberNameCache().getOr(senderId);
    }
    return userName;
  }

  Future<Map<String, dynamic>> _loadLastMessage(
    EMConversation conv,
    bool isGroup,
  ) async {
    String lastMessageText = '';
    int lastMsgTime = 0;

    try {
      final msgs = await conv.loadMessages(loadCount: 5);

      if (msgs.isNotEmpty) {
        for (final msg in msgs) {
          if (msg.direction == MessageDirection.SEND) continue;

          lastMsgTime = msg.serverTime;

          if (msg.body is EMTextMessageBody) {
            lastMessageText = (msg.body as EMTextMessageBody).content;
            if (lastMessageText.length > 30) {
              lastMessageText = '${lastMessageText.substring(0, 30)}...';
            }
          } else if (msg.body is EMImageMessageBody) {
            lastMessageText = '[图片]';
          } else if (msg.body is EMFileMessageBody) {
            final body = msg.body as EMFileMessageBody;
            final displayName = body.displayName?.isNotEmpty == true
                ? body.displayName
                : '文件';
            lastMessageText = '[文件: $displayName]';
          } else if (msg.body is EMVoiceMessageBody) {
            lastMessageText = '[语音]';
          } else if (msg.body is EMVideoMessageBody) {
            lastMessageText = '[视频]';
          } else if (msg.body is EMLocationMessageBody) {
            lastMessageText = '[位置]';
          } else if (msg.body is EMCustomMessageBody) {
            lastMessageText = '[${(msg.body as EMCustomMessageBody).event}]';
          }

          if (isGroup) {
            final sender = msg.from;
            if (sender != null && sender.isNotEmpty) {
              final userName = _resolveSenderNameFromMessage(msg, sender);
              if (userName.isNotEmpty && userName != sender) {
                lastMessageText = '$userName: $lastMessageText';
              }
            }
          }

          if (lastMessageText.isNotEmpty) break;
        }
      }
    } catch (e) {
      debugPrint('获取最后一条消息失败: $e');
    }

    return {'lastMessage': lastMessageText, 'lastMsgTime': lastMsgTime};
  }

  Future<void> _refreshUnreadCount(String groupId) async {
    try {
      final index = _conversations.indexWhere((c) => c.id == groupId);
      if (index == -1) return;

      final isGroup = _conversations[index].isGroup;
      final conv = await EMClient.getInstance.chatManager.getConversation(
        groupId,
        type: isGroup ? EMConversationType.GroupChat : EMConversationType.Chat,
        createIfNeed: false,
      );
      if (conv == null) return;

      int unRead = 0;
      try {
        unRead = await conv.unreadCount();
      } catch (e) {
        debugPrint('获取未读计数失败: $e');
      }

      if (mounted && _conversations[index].unread != unRead) {
        final old = _conversations[index];
        setState(() {
          _conversations[index] = _ConvInfo(
            id: old.id,
            name: old.name,
            icon: old.icon,
            isGroup: old.isGroup,
            unread: unRead,
            lastMsg: old.lastMsg,
            time: old.time,
            memberCount: old.memberCount,
            courseId: old.courseId,
          );
        });
      }
    } catch (e) {
      debugPrint('刷新未读计数失败: $e');
    }
  }

  void _openChat(_ConvInfo conv) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupChatPage(
          chatId: conv.id,
          title: conv.name,
          isGroup: conv.isGroup,
          groupIcon: conv.icon,
        ),
      ),
    ).then((_) => _refreshUnreadCount(conv.id));
  }

  void _showInbox() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UserNoticeInboxPage()),
    );
  }

  void _showFaceToFaceGroup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FaceToFaceGroupPage()),
    );
  }

  void _showJoinGroup() {
    final codeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('加入群组'),
        content: TextField(
          controller: codeCtrl,
          decoration: const InputDecoration(
            labelText: '邀请码/群号',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              final code = codeCtrl.text.trim();
              Navigator.pop(ctx);
              if (code.isNotEmpty) _joinGroup(code);
            },
            child: const Text('加入'),
          ),
        ],
      ),
    );
  }

  Future<void> _joinGroup(String code) async {
    try {
      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      if (session == null) {
        _showSnackBar('请先登录');
        return;
      }
      final user = AppDependencies.instance.accountRepo
          .getAccountById(session)
          .fold((_) => null, (u) => u);
      final puid = user?.puid ?? user?.uid ?? '';
      final result = await AppDependencies.instance.cxGroupImApi.addChatList(
        tuid: puid,
        puid: puid,
        token: '',
        chatId: code,
        chatName: '加入的群组',
        chatIco: '',
        isGroup: true,
        count: 1,
      );
      _showSnackBar(result ? '加入成功' : '加入失败');
      if (result) _loadConversations();
    } catch (e) {
      _showSnackBar('加入失败: $e');
    }
  }

  void _showScan() {
    Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ScanPage()),
    ).then((code) {
      if (code == null || !mounted) return;

      try {
        final uri = Uri.parse(code);
        final baseUrl = uri.origin + uri.path;

        if (baseUrl == 'https://mobilelearn.chaoxing.com/widget/sign/e') {
          final activeId = uri.queryParameters['id'];
          final enc = uri.queryParameters['enc'];
          if (activeId == null || activeId.isEmpty) {
            _showSnackBar('二维码缺少活动ID');
            return;
          }
          if (enc == null || enc.isEmpty) {
            _showSnackBar('二维码缺少加密参数');
            return;
          }
          _executeQrCodeSignIn(activeId, enc);
        } else {
          _handleOtherQRCode(code);
        }
      } catch (e) {
        _handleOtherQRCode(code);
      }
    });
  }

  Future<void> _executeQrCodeSignIn(String activeId, String enc) async {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final deps = AppDependencies.instance;

      final signDetailResult = await deps.getSignDetailUseCase.execute(
        activeId,
      );
      final signCode = signDetailResult.fold(
        (_) => null,
        (detail) => detail['signCode'] as String?,
      );

      final uri = Uri.parse(
        'https://mobilelearn.chaoxing.com/widget/sign/e?id=$activeId&enc=$enc',
      );
      final c = uri.queryParameters['c'];

      if (signCode != null && signCode.isNotEmpty && c != signCode) {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        _showSnackBar('二维码已过期');
        return;
      }

      final session = deps.accountRepo.getCurrentSessionId().fold(
        (_) => null,
        (id) => id,
      );
      final user = session != null
          ? deps.accountRepo.getAccountById(session).fold((_) => null, (u) => u)
          : null;

      if (user == null) {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        _showSnackBar('未获取到用户信息');
        return;
      }

      final result = await deps.qrCodeSignInUseCase.execute(
        courseId: '',
        activeId: activeId,
        enc: enc,
        uid: user.uid,
        name: user.name,
      );

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      result.fold(
        (f) => _showSnackBar(f.message),
        (_) => _showSnackBar('二维码签到成功'),
      );
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        _showSnackBar('签到失败: $e');
      }
    }
  }

  Future<void> _handleOtherQRCode(String code) async {
    if (!mounted) return;
    try {
      final uri = Uri.parse(code);
      final queryParams = uri.queryParameters;
      final uuid = queryParams['uuid'];
      final enc = queryParams['enc'];

      if (uuid != null && enc != null) {
        _handleWebLoginQRCode(uuid, enc);
      } else {
        _handleJoinGroupQRCode(code);
      }
    } catch (e) {
      _handleJoinGroupQRCode(code);
    }
  }

  Future<void> _handleWebLoginQRCode(String uuid, String enc) async {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final deps = AppDependencies.instance;
      final authResult = await deps.cxAuthApi.authorizeWebQR(uuid, enc);

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      if (authResult != null && authResult['status'] == true) {
        _showSnackBar('网页登录授权成功');
      } else {
        _showSnackBar('网页登录授权失败: ${authResult?['mes'] ?? '未知错误'}');
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        _showSnackBar('网页登录授权异常: $e');
      }
    }
  }

  Future<void> _handleJoinGroupQRCode(String code) async {
    if (!mounted) return;
    try {
      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      if (session == null) {
        _showSnackBar('请先登录');
        return;
      }
      final user = AppDependencies.instance.accountRepo
          .getAccountById(session)
          .fold((_) => null, (u) => u);
      final puid = user?.puid ?? user?.uid ?? '';
      final result = await AppDependencies.instance.cxGroupImApi.addChatList(
        tuid: puid,
        puid: puid,
        token: '',
        chatId: code,
        chatName: '加入的群组',
        chatIco: '',
        isGroup: true,
        count: 1,
      );
      _showSnackBar(result ? '加入成功' : '加入失败');
      if (result) _loadConversations();
    } catch (e) {
      _showSnackBar('加入失败: $e');
    }
  }

  void _showSnackBar(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  String _formatTime(int millisecondsSinceEpoch) {
    final time = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return '刚刚';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}分钟前';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}小时前';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}天前';
    } else {
      return '${time.month}/${time.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(sessionVersionProvider, (prev, next) {
      if (prev != next) {
        debugPrint('群组页面检测到账号变更，刷新群组列表');
        _isLoadingConv = false;
        _hasLoadedOnce = false;
        _conversations.clear();
        _dndService.clearForAccountChange();
        _loadFromCache();
        _loadConversations();
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('群组'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchAddFriendPage(),
                ),
              );
            },
            tooltip: '加好友',
          ),
          IconButton(
            icon: const Icon(Icons.contacts),
            onPressed: () {
              _tabCtrl.animateTo(1);
            },
            tooltip: '通讯录',
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: '扫码加入',
            onPressed: _showScan,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'face',
                child: ListTile(
                  leading: Icon(Icons.face),
                  title: Text('面对面建群'),
                ),
              ),
              PopupMenuItem(
                value: 'join',
                child: ListTile(
                  leading: Icon(Icons.group_add),
                  title: Text('加入群组'),
                ),
              ),
            ],
            onSelected: (v) {
              if (v == 'face') _showFaceToFaceGroup();
              if (v == 'join') _showJoinGroup();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(text: '会话'),
            Tab(text: '通讯录'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top:
                kToolbarHeight +
                kTextTabBarHeight +
                MediaQuery.of(context).padding.top,
          ),
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              _buildChatList(),
              ContactsSearchTab(
                onChatOpen: (id, name) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GroupChatPage(
                        chatId: id,
                        title: name,
                        isGroup: false,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoadingNotifier,
      builder: (context, isLoading, _) {
        if (isLoading && _conversations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_error != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(_error!),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: _loadConversations,
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }
        if (_conversations.isEmpty) {
          return RefreshIndicator(
            onRefresh: _loadConversations,
            child: ListView(
              children: [
                SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无会话',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: _loadConversations,
          child: Column(
            children: [
              _buildInboxCard(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _conversations.length,
                  itemBuilder: (context, index) {
                    return StaggeredItemAnimation(
                      index: index,
                      child: _buildConvTile(_conversations[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInboxCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showInbox,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.mail_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '通知收件箱',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '查看系统通知和作业提醒',
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConvTile(_ConvInfo conv) {
    final isDnd = _dndService.isDnd(conv.id);
    final isCourseGroup = conv.isGroup && conv.courseId != null;
    final groupTypeLabel = conv.isGroup ? (isCourseGroup ? '课程' : '自定义') : '个人';
    final groupTypeColor = conv.isGroup
        ? (isCourseGroup
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondary)
        : Theme.of(context).colorScheme.tertiary;
    final groupTypeBgColor = conv.isGroup
        ? (isCourseGroup
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1))
        : Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1);
    final avatarIcon = conv.isGroup
        ? (isCourseGroup ? Icons.class_ : Icons.group)
        : Icons.person;
    final avatarContainerColor = conv.isGroup
        ? (isCourseGroup
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.secondaryContainer)
        : Theme.of(context).colorScheme.tertiaryContainer;
    final avatarIconColor = conv.isGroup
        ? (isCourseGroup
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSecondaryContainer)
        : Theme.of(context).colorScheme.onTertiaryContainer;

    return RepaintBoundary(
      child: ListTile(
        leading: Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(conv.isGroup ? 8 : 24),
                color: avatarContainerColor,
              ),
              child: conv.icon.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(
                        conv.isGroup ? 8 : 24,
                      ),
                      child: ChaoxingNetworkImage(
                        url: conv.icon,
                        width: 48,
                        height: 48,
                      ),
                    )
                  : Icon(avatarIcon, color: avatarIconColor),
            ),
            if (conv.unread > 0 && !isDnd)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    conv.unread > 99 ? '99+' : '${conv.unread}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if (isDnd)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.notifications_off,
                    size: 14,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                conv.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isDnd)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Icon(
                  Icons.notifications_off,
                  size: 14,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (conv.lastMsg.isNotEmpty)
              Text(
                conv.lastMsg,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: groupTypeBgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    groupTypeLabel,
                    style: TextStyle(fontSize: 10, color: groupTypeColor),
                  ),
                ),
                const SizedBox(width: 8),
                if (conv.isGroup)
                  Text(
                    '${conv.memberCount}人',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Text(
          _formatTime(conv.time),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        onTap: () => _openChat(conv),
        onLongPress: () => _showContextMenu(context, conv),
      ),
    );
  }

  void _showContextMenu(BuildContext context, _ConvInfo conv) {
    final isDnd = _dndService.isDnd(conv.id);

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                conv.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              leading: Icon(
                isDnd ? Icons.notifications : Icons.notifications_off,
                color: isDnd ? Colors.green : Colors.grey,
              ),
              title: Text(isDnd ? '开启通知' : '免打扰'),
              subtitle: Text(isDnd ? '接收该群聊的消息通知' : '静音该群聊的消息通知'),
              onTap: () {
                final navigator = Navigator.of(
                  sheetContext,
                  rootNavigator: false,
                );
                _dndService.setDnd(conv.id, !isDnd).then((_) {
                  navigator.pop();
                  if (context.mounted) {
                    setState(() {});
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text('进入聊天'),
              onTap: () {
                Navigator.of(sheetContext, rootNavigator: false).pop();
                _openChat(conv);
              },
            ),
            if (conv.unread > 0)
              ListTile(
                leading: const Icon(Icons.mark_email_read, color: Colors.blue),
                title: const Text('清除未读'),
                subtitle: Text('清除 ${conv.unread} 条未读消息'),
                onTap: () {
                  Navigator.of(sheetContext, rootNavigator: false).pop();
                  _clearUnread(conv);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _clearUnread(_ConvInfo conv) async {
    try {
      final index = _conversations.indexWhere((c) => c.id == conv.id);
      if (index == -1 || conv.unread == 0) return;

      final isGroup = conv.isGroup;
      final emConv = await EMClient.getInstance.chatManager.getConversation(
        conv.id,
        type: isGroup ? EMConversationType.GroupChat : EMConversationType.Chat,
        createIfNeed: false,
      );
      if (emConv != null) {
        try {
          await emConv.markAllMessagesAsRead();
        } catch (_) {}
      }

      if (mounted) {
        final old = _conversations[index];
        setState(() {
          _conversations[index] = _ConvInfo(
            id: old.id,
            name: old.name,
            icon: old.icon,
            isGroup: old.isGroup,
            unread: 0,
            lastMsg: old.lastMsg,
            time: old.time,
            memberCount: old.memberCount,
            courseId: old.courseId,
          );
        });
        _saveToCache();
      }
    } catch (e) {
      debugPrint('清除未读失败: $e');
    }
  }
}

class _ConvInfo {
  final String id, name, lastMsg, icon;
  final bool isGroup;
  final int unread, time;
  final int memberCount;
  final String? courseId;

  const _ConvInfo({
    required this.id,
    required this.name,
    this.icon = '',
    this.isGroup = false,
    this.unread = 0,
    this.lastMsg = '',
    this.time = 0,
    this.memberCount = 0,
    this.courseId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'isGroup': isGroup,
    'unread': unread,
    'lastMsg': lastMsg,
    'time': time,
    'memberCount': memberCount,
    'courseId': courseId,
  };

  factory _ConvInfo.fromJson(Map<String, dynamic> json) => _ConvInfo(
    id: json['id'] as String,
    name: json['name'] as String,
    icon: json['icon'] as String? ?? '',
    isGroup: json['isGroup'] as bool? ?? false,
    unread: json['unread'] as int? ?? 0,
    lastMsg: json['lastMsg'] as String? ?? '',
    time: json['time'] as int? ?? 0,
    memberCount: json['memberCount'] as int? ?? 0,
    courseId: json['courseId'] as String?,
  );
}

class ContactsSearchTab extends StatefulWidget {
  final Function(String id, String name) onChatOpen;
  const ContactsSearchTab({super.key, required this.onChatOpen});
  @override
  State<ContactsSearchTab> createState() => _ContactsSearchTabState();
}

class _ContactsSearchTabState extends State<ContactsSearchTab> {
  final _ctrl = TextEditingController();
  List<FollowerInfo> _followers = [];
  List<FollowerInfo> _filteredFollowers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFollowers();
  }

  Future<void> _loadFollowers() async {
    setState(() => _loading = true);
    try {
      final followers = await AppDependencies.instance.cxFriendContactApi
          .getFollowers();
      if (!mounted) return;
      setState(() {
        _followers = followers;
        _filteredFollowers = followers;
        _loading = false;
      });
    } catch (e) {
      debugPrint('加载通讯录失败: $e');
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _filter(String keyword) {
    final kw = keyword.trim().toLowerCase();
    if (kw.isEmpty) {
      setState(() => _filteredFollowers = _followers);
      return;
    }
    setState(() {
      _filteredFollowers = _followers.where((f) {
        return f.name.toLowerCase().contains(kw) ||
            f.fullPinyin.toLowerCase().contains(kw) ||
            f.simplePinyin.toLowerCase().contains(kw);
      }).toList();
    });
  }

  Future<void> _startChat(FollowerInfo f) async {
    String imUserName = '';

    for (final candidate in [f.uid.toString(), f.puid.toString()]) {
      try {
        final userInfo = await AppDependencies.instance.cxGroupImApi
            .getUserInfoByTuid(tuid: candidate, puid: '', token: '');
        if (userInfo != null && userInfo.name.isNotEmpty) {
          imUserName = userInfo.tuid;
          MemberNameCache().set(
            imUserName,
            f.alias.isNotEmpty ? f.alias : f.name,
          );
          if (userInfo.picUrl.isNotEmpty) {
            MemberNameCache().setAvatar(imUserName, userInfo.picUrl);
          }
          break;
        }
      } catch (_) {}
    }

    if (imUserName.isEmpty) {
      imUserName = f.uid.toString();
    }

    if (!mounted) return;
    widget.onChatOpen(imUserName, f.alias.isNotEmpty ? f.alias : f.name);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: TextField(
            controller: _ctrl,
            decoration: InputDecoration(
              hintText: '搜索好友...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              prefixIcon: Icon(Icons.search, color: theme.colorScheme.outline),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              isDense: true,
            ),
            onChanged: _filter,
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _filteredFollowers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.contacts_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _followers.isEmpty ? '暂无好友' : '未找到匹配的好友',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFollowers,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _filteredFollowers.length,
                    itemBuilder: (_, i) {
                      final f = _filteredFollowers[i];
                      final displayName = f.alias.isNotEmpty
                          ? '${f.name}（${f.alias}）'
                          : f.name;
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: f.pic.isNotEmpty
                              ? ChaoxingNetworkImage(
                                  url: f.pic.startsWith('http://')
                                      ? f.pic.replaceFirst(
                                          'http://',
                                          'https://',
                                        )
                                      : f.pic,
                                  width: 40,
                                  height: 40,
                                ).image
                              : null,
                          child: f.pic.isEmpty
                              ? const Icon(Icons.person, size: 20)
                              : null,
                        ),
                        title: Row(
                          children: [
                            Flexible(
                              child: Text(
                                displayName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (f.eachother == 1) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '互关',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: f.schoolName.isNotEmpty
                            ? Text(f.schoolName)
                            : null,
                        trailing: TextButton(
                          onPressed: () => _startChat(f),
                          child: const Text('发消息'),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class FaceToFaceGroupPage extends StatefulWidget {
  const FaceToFaceGroupPage({super.key});
  @override
  State<FaceToFaceGroupPage> createState() => _FaceToFaceGroupPageState();
}

class _FaceToFaceGroupPageState extends State<FaceToFaceGroupPage> {
  final List<TextEditingController> _ctrls = List.generate(
    4,
    (_) => TextEditingController(),
  );
  bool _creating = false;
  String _msg = '';

  String get _code => _ctrls.map((c) => c.text.trim()).join();
  bool get _complete =>
      _code.length == 4 &&
      _code.split('').every((c) => c.isNotEmpty && int.tryParse(c) != null);

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _create() async {
    if (!_complete) return;
    setState(() {
      _creating = true;
      _msg = '';
    });
    try {
      final session = AppDependencies.instance.accountRepo
          .getCurrentSessionId()
          .fold((_) => null, (id) => id);
      if (session == null) {
        setState(() {
          _msg = '未获取到用户信息';
          _creating = false;
        });
        return;
      }
      final user = AppDependencies.instance.accountRepo
          .getAccountById(session)
          .fold((_) => null, (u) => u);
      final puid = user?.puid ?? user?.uid ?? '';
      setState(() {
        _msg = '正在创建群组...';
      });
      final result = await AppDependencies.instance.cxFriendContactApi
          .createContactCode(puid: puid, code: _code);
      if (result != null && result['result'] == 1) {
        final data = result['data'];
        final enc = data != null && data is Map
            ? data['enc']?.toString() ?? ''
            : '';
        if (enc.isNotEmpty) {
          final joinResult = await AppDependencies.instance.cxFriendContactApi
              .faceToFaceJoinGroup(puid: puid, code: _code, enc: enc);
          if (joinResult != null && joinResult['result'] == 1) {
            setState(() {
              _msg = '群组创建成功！';
              _creating = false;
            });
            if (mounted) Navigator.pop(context);
            return;
          }
        }
        setState(() {
          _msg = data is Map
              ? (data['userCount']?.toString() ?? '创建中...')
              : '创建中...';
        });
      } else {
        setState(() {
          _msg = '创建群组失败，请检查网络后重试';
          _creating = false;
        });
      }
    } catch (e) {
      setState(() {
        _msg = '创建失败: $e';
        _creating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('面对面建群')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('输入4位数字作为房间密码', style: theme.textTheme.titleMedium),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      width: 60,
                      child: TextField(
                        controller: _ctrls[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: const InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) {
                          if (_code.length == 4) _create();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_msg.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _msg,
                    style: TextStyle(
                      color: _msg.contains('失败')
                          ? Colors.red
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
              SizedBox(
                width: 200,
                child: FilledButton(
                  onPressed: _complete && !_creating ? _create : null,
                  child: _creating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('创建群组'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

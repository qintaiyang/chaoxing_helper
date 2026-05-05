import 'package:flutter/material.dart';
import '../../infra/services/member_name_cache.dart';
import '../../app_dependencies.dart';

class SearchAddFriendPage extends StatefulWidget {
  const SearchAddFriendPage({super.key});

  @override
  State<SearchAddFriendPage> createState() => _SearchAddFriendPageState();
}

class _SearchAddFriendPageState extends State<SearchAddFriendPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<_UserInfo> _searchResults = [];
  String _errorMessage = '';

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) return;

    setState(() {
      _isSearching = true;
      _errorMessage = '';
      _searchResults = [];
    });

    try {
      final results = await AppDependencies.instance.cxGroupImApi
          .getUserInfoByTuid2(tuids: [keyword], chatId: keyword);

      if (mounted) {
        setState(() {
          _searchResults = results
              .map((dto) => _UserInfo(
                    tuid: dto.tuid,
                    name: dto.name,
                    picUrl: dto.picUrl,
                  ))
              .toList();
          _isSearching = false;
          if (_searchResults.isEmpty) {
            _errorMessage = '未找到该用户';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _errorMessage = '搜索失败: $e';
        });
      }
    }
  }

  void _addFriend(_UserInfo user) {
    MemberNameCache().set(user.tuid, user.name);
    if (user.picUrl.isNotEmpty) {
      MemberNameCache().setAvatar(user.tuid, user.picUrl);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已添加 ${user.name} 到通讯录'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('搜索添加好友'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: '输入用户ID搜索',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                            _errorMessage = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              onSubmitted: (_) => _performSearch(),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSearching ? null : _performSearch,
                icon: const Icon(Icons.search),
                label: const Text('搜索'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_isSearching)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_errorMessage.isNotEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_off,
                      size: 64,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_searchResults.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  return _buildUserCard(user, colorScheme);
                },
              ),
            )
          else
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search,
                      size: 64,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '输入用户ID开始搜索',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserCard(_UserInfo user, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: user.picUrl.isNotEmpty
              ? NetworkImage(user.picUrl)
              : null,
          child: user.picUrl.isEmpty
              ? Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 20),
                )
              : null,
        ),
        title: Text(
          user.name.isNotEmpty ? user.name : user.tuid,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'ID: ${user.tuid}',
          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: FilledButton.tonal(
          onPressed: () => _addFriend(user),
          child: const Text('添加'),
        ),
      ),
    );
  }
}

class _UserInfo {
  final String tuid;
  final String name;
  final String picUrl;

  const _UserInfo({
    required this.tuid,
    required this.name,
    required this.picUrl,
  });
}

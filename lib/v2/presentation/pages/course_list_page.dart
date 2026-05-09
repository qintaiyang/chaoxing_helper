import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/course_controller.dart';
import '../providers/providers.dart';
import '../widgets/error_view.dart';
import '../widgets/network_image.dart';
import '../../domain/entities/course.dart';
import '../widgets/staggered_animation.dart';
import 'homework_page.dart';

class CourseListPage extends ConsumerStatefulWidget {
  const CourseListPage({super.key});

  @override
  ConsumerState<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends ConsumerState<CourseListPage> {
  final List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterCourses(String keyword) {
    if (keyword.trim().isEmpty) {
      setState(() {
        _filteredCourses = List.from(_courses);
        _isSearching = false;
      });
      return;
    }
    final lower = keyword.toLowerCase();
    setState(() {
      _filteredCourses = _courses
          .where(
            (c) =>
                c.name.toLowerCase().contains(lower) ||
                c.teacher.toLowerCase().contains(lower) ||
                (c.note?.toLowerCase().contains(lower) ?? false) ||
                (c.schools?.toLowerCase().contains(lower) ?? false),
          )
          .toList();
      _isSearching = true;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _filteredCourses = List.from(_courses);
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(courseListControllerProvider);
    final theme = Theme.of(context);

    // 监听 session 变化，刷新课程列表
    ref.listen<int>(sessionVersionProvider, (previous, next) {
      ref.invalidate(courseListControllerProvider);
      if (mounted) {
        _searchController.clear();
        setState(() {
          _isSearching = false;
          _filteredCourses = [];
        });
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '搜索课程...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
                onSubmitted: _filterCourses,
              )
            : const Text('课程'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear_all, color: Colors.white),
              onPressed: _clearSearch,
              tooltip: '退出搜索',
            )
          else
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() => _isSearching = true);
                Future.delayed(const Duration(milliseconds: 100), () {
                  _searchFocusNode.requestFocus();
                });
              },
              tooltip: '搜索',
            ),
          IconButton(
            icon: const Icon(Icons.assignment, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomeworkPage()),
              );
            },
            tooltip: '作业',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.3),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: coursesAsync.when(
          loading: () => Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: kToolbarHeight + MediaQuery.of(context).padding.top,
              ),
              child: const CircularProgressIndicator(),
            ),
          ),
          error: (e, _) => Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: kToolbarHeight + MediaQuery.of(context).padding.top,
              ),
              child: ErrorView(
                failure: e as dynamic,
                onRetry: () => ref.invalidate(courseListControllerProvider),
              ),
            ),
          ),
          data: (courses) {
            if (courses.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(
                  top: kToolbarHeight + MediaQuery.of(context).padding.top,
                ),
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(courseListControllerProvider);
                  },
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '暂无课程数据',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final displayCourses = _isSearching ? _filteredCourses : courses;
            if (displayCourses.isEmpty && _isSearching) {
              return Padding(
                padding: EdgeInsets.only(
                  top: kToolbarHeight + MediaQuery.of(context).padding.top,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      const Text(
                        '未找到匹配的课程',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(courseListControllerProvider);
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: kToolbarHeight + MediaQuery.of(context).padding.top,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: displayCourses.length,
                  itemBuilder: (context, index) {
                    return StaggeredItemAnimation(
                      index: index,
                      child: _buildCourseTile(displayCourses[index]),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCourseTile(Course course) {
    final theme = Theme.of(context);

    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(
              '/course/${course.courseId}?classId=${course.classId}&cpi=${course.cpi ?? ''}&name=${Uri.encodeComponent(course.name)}',
            ),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.95,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (course.image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ChaoxingNetworkImage(
                        url: course.image,
                        width: 56,
                        height: 56,
                      ),
                    )
                  else
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.school,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 28,
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.teacher,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (course.note != null && course.note!.isNotEmpty)
                          Text(
                            course.note!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        if (course.schools != null &&
                            course.schools!.isNotEmpty)
                          Text(
                            course.schools!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: theme.colorScheme.outline),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

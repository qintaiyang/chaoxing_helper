import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app.dart';
import '../pages/login_page.dart';
import '../pages/main_page.dart';
import '../pages/course_detail_page.dart';
import '../pages/homework_list_page.dart';
import '../pages/homework_webview_page.dart';
import '../pages/exam_list_page.dart';
import '../pages/exam_webview_page.dart';
import '../pages/sign_in_page.dart';
import '../pages/notice_list_page.dart';
import '../pages/group_chat_page.dart';
import '../pages/quiz_page.dart';
import '../pages/vote_page.dart';
import '../pages/questionnaire_page.dart';
import '../pages/activity_webview_page.dart';
import '../pages/settings_page.dart';
import '../pages/change_password_page.dart';
import '../pages/location_select_page.dart';
import '../pages/materials_list_page.dart';
import '../pages/theme_settings_page.dart';
import '../pages/custom_icon_splash_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    navigatorKey: v2NavigatorKey,
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: V2MainPage()),
          ),
          GoRoute(
            path: '/course/:courseId',
            builder: (context, state) {
              final courseId = state.pathParameters['courseId']!;
              final classId = state.uri.queryParameters['classId'] ?? '';
              final cpi = state.uri.queryParameters['cpi'] ?? '';
              final name = state.uri.queryParameters['name'] ?? '';
              return CourseDetailPage(
                courseId: courseId,
                classId: classId,
                cpi: cpi,
                courseName: name,
              );
            },
          ),
          GoRoute(
            path: '/course/:courseId/homework',
            builder: (context, state) {
              final courseId = state.pathParameters['courseId']!;
              final classId = state.uri.queryParameters['classId'] ?? '';
              final cpi = state.uri.queryParameters['cpi'] ?? '';
              return HomeworkListPage(
                courseId: courseId,
                classId: classId,
                cpi: cpi,
              );
            },
          ),
          GoRoute(
            path: '/course/:courseId/homework/:workId',
            builder: (context, state) {
              final courseId = state.pathParameters['courseId']!;
              final workId = state.pathParameters['workId']!;
              final classId = state.uri.queryParameters['classId'] ?? '';
              final cpi = state.uri.queryParameters['cpi'] ?? '';
              final enc = state.uri.queryParameters['enc'] ?? '';
              final answerId = state.uri.queryParameters['answerId'] ?? '';
              final taskUrl = state.uri.queryParameters['taskUrl'] ?? '';
              return HomeworkWebViewPage(
                workId: workId,
                courseId: courseId,
                classId: classId,
                cpi: cpi,
                enc: enc,
                answerId: answerId,
                taskUrl: taskUrl,
              );
            },
          ),
          GoRoute(
            path: '/course/:courseId/exams',
            builder: (context, state) {
              final courseId = state.pathParameters['courseId']!;
              final classId = state.uri.queryParameters['classId'] ?? '';
              final cpi = state.uri.queryParameters['cpi'] ?? '';
              return ExamListPage(
                courseId: courseId,
                classId: classId,
                cpi: cpi,
              );
            },
          ),
          GoRoute(
            path: '/course/:courseId/exam/:examId',
            builder: (context, state) {
              final courseId = state.pathParameters['courseId']!;
              final examId = state.pathParameters['examId']!;
              final classId = state.uri.queryParameters['classId'] ?? '';
              final cpi = state.uri.queryParameters['cpi'] ?? '';
              final title = state.uri.queryParameters['title'] ?? '';
              return ExamWebViewPage(
                courseId: courseId,
                classId: classId,
                cpi: cpi,
                examId: examId,
                examTitle: title,
              );
            },
          ),
          GoRoute(
            path: '/course/:courseId/notices',
            builder: (context, state) {
              final courseId = state.pathParameters['courseId']!;
              return NoticeListPage(courseId: courseId);
            },
          ),
          GoRoute(
            path: '/course/:courseId/materials',
            builder: (context, state) {
              final courseId = state.pathParameters['courseId']!;
              final classId = state.uri.queryParameters['classId'] ?? '';
              final cpi = state.uri.queryParameters['cpi'] ?? '';
              final puid =
                  int.tryParse(state.uri.queryParameters['puid'] ?? '0') ?? 0;
              return MaterialsListPage(
                courseId: courseId,
                classId: classId,
                cpi: cpi,
                puid: puid,
              );
            },
          ),
          GoRoute(
            path: '/signin/:activeId',
            builder: (context, state) {
              final activeId = state.pathParameters['activeId']!;
              final courseId = state.uri.queryParameters['courseId'] ?? '';
              final classId = state.uri.queryParameters['classId'] ?? '';
              final cpi = state.uri.queryParameters['cpi'] ?? '';
              final enc = state.uri.queryParameters['enc'];
              return SignInPage(
                courseId: courseId,
                classId: classId,
                cpi: cpi,
                activeId: activeId,
                enc: enc,
              );
            },
          ),
          GoRoute(
            path: '/group-chat/:chatId',
            builder: (context, state) {
              final chatId = state.pathParameters['chatId']!;
              final title = state.uri.queryParameters['title'];
              final isGroup = state.uri.queryParameters['isGroup'] == 'true';
              final groupIcon = state.uri.queryParameters['groupIcon'];
              return GroupChatPage(
                chatId: chatId,
                title: title,
                isGroup: isGroup,
                groupIcon: groupIcon,
              );
            },
          ),
          GoRoute(
            path: '/quiz/:activeId',
            builder: (context, state) {
              final activeId = state.pathParameters['activeId']!;
              final classId = state.uri.queryParameters['classId'] ?? '';
              final courseId = state.uri.queryParameters['courseId'] ?? '';
              return QuizPage(
                activeId: activeId,
                classId: classId,
                courseId: courseId,
              );
            },
          ),
          GoRoute(
            path: '/vote/:activeId',
            builder: (context, state) {
              final activeId = state.pathParameters['activeId']!;
              final classId = state.uri.queryParameters['classId'] ?? '';
              final courseId = state.uri.queryParameters['courseId'] ?? '';
              return VotePage(
                activeId: activeId,
                classId: classId,
                courseId: courseId,
              );
            },
          ),
          GoRoute(
            path: '/questionnaire/:activeId',
            builder: (context, state) {
              final activeId = state.pathParameters['activeId']!;
              final classId = state.uri.queryParameters['classId'] ?? '';
              final courseId = state.uri.queryParameters['courseId'] ?? '';
              return QuestionnairePage(
                activeId: activeId,
                classId: classId,
                courseId: courseId,
              );
            },
          ),
          GoRoute(
            path: '/activity/:activeId',
            builder: (context, state) {
              final activeUrl = state.uri.queryParameters['url'] ?? '';
              final activeName = state.uri.queryParameters['name'] ?? '';
              final classId = state.uri.queryParameters['classId'] ?? '';
              final courseId = state.uri.queryParameters['courseId'] ?? '';
              return ActivityWebViewPage(
                activeUrl: activeUrl,
                activeName: activeName,
                courseId: courseId,
                classId: classId,
              );
            },
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
          GoRoute(
            path: '/change-password',
            builder: (context, state) => const ChangePasswordPage(),
          ),
          GoRoute(
            path: '/location_select',
            builder: (context, state) => const LocationSelectPage(),
          ),
          GoRoute(
            path: '/theme-settings',
            builder: (context, state) => const ThemeSettingsPage(),
          ),
          GoRoute(
            path: '/custom-icon-splash',
            builder: (context, state) => const CustomIconAndSplashPage(),
          ),
        ],
      ),
    ],
  );
});

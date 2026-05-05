import 'package:flutter/material.dart';

enum PushChannel {
  imCourseActivity('att_chat_course', '课程活动推送'),
  imHomework('att_homework', '作业推送'),
  imGroupSign('att_group_sign', '群聊签到推送'),
  apiNotice('notice_api', '通知API推送');

  final String key;
  final String label;
  const PushChannel(this.key, this.label);
}

enum PushCategory {
  homework(19, Icons.assignment, '作业'),
  exam(19, Icons.menu_book, '考试'),
  signIn(2, Icons.check_circle, '签到'),
  scheduledSignIn(54, Icons.timer, '定时签到'),
  groupSignIn(75, Icons.group_work, '群聊签到'),
  answer(4, Icons.back_hand, '抢答'),
  pick(11, Icons.people, '选人'),
  questionnaire(14, Icons.question_answer, '问卷'),
  vote(43, Icons.poll, '投票'),
  topicDiscuss(5, Icons.comment, '主题讨论'),
  quiz(42, Icons.edit_note, '随堂练习'),
  evaluation(23, Icons.star, '评分'),
  groupTask(35, Icons.group, '分组任务'),
  live(17, Icons.live_tv, '直播'),
  cxMeeting(56, Icons.video_camera_front, '超星课堂'),
  tencentMeeting(64, Icons.meeting_room, '腾讯会议'),
  pptClass(40, Icons.slideshow, 'PPT课堂'),
  notice(45, Icons.notifications, '通知'),
  feedback(46, Icons.feedback, '学生反馈'),
  interactivePractice(68, Icons.play_lesson, '互动练习'),
  aiEvaluate(77, Icons.smart_toy, 'AI实践'),
  punch(61, Icons.access_time, '打卡'),
  timer(47, Icons.timer, '计时器'),
  whiteboard(49, Icons.draw, '白板'),
  syncCourse(51, Icons.sync, '同步课堂'),
  signOut(74, Icons.logout, '签退'),
  draw(59, Icons.casino, '抽签'),
  system(0, Icons.info, '系统通知'),
  courseNotice(1000, Icons.school, '课程通知');

  final int activeType;
  final IconData icon;
  final String label;
  const PushCategory(this.activeType, this.icon, this.label);

  static PushCategory fromActiveType(int type) {
    for (final category in values) {
      if (category.activeType == type) return category;
    }
    return system;
  }

  static bool isHomework(int type) => type == 19;
  static bool isExam(int type) => type == 19;
  static bool isSignIn(int type) => type == 2 || type == 54 || type == 75;
}

class PushNotification {
  final PushChannel channel;
  final PushCategory category;
  final String title;
  final String content;
  final String courseName;
  final String courseId;
  final String classId;
  final String cpi;
  final Map<String, dynamic> rawData;
  final String? homeworkUrl;
  final String? homeworkId;

  const PushNotification({
    required this.channel,
    required this.category,
    required this.title,
    required this.content,
    this.courseName = '',
    this.courseId = '',
    this.classId = '',
    this.cpi = '',
    this.rawData = const {},
    this.homeworkUrl,
    this.homeworkId,
  });

  factory PushNotification.fromCourseActivity(Map<String, dynamic> data) {
    final int activeTypeValue = data['activeType'] is int
        ? data['activeType']
        : int.tryParse(data['activeType']?.toString() ?? '0') ?? 0;
    final String typeTitle = data['typeTitle'] ?? data['title'] ?? '';
    final courseInfo = data['courseInfo'] as Map<String, dynamic>?;
    final courseName = courseInfo?['coursename'] ?? '未知课程';
    final courseId = courseInfo?['courseid']?.toString() ?? '';
    final classId = courseInfo?['classid']?.toString() ?? '';
    final cpi = courseInfo?['cpi']?.toString() ?? '';
    final category = PushCategory.fromActiveType(activeTypeValue);

    String content;
    if (PushCategory.isHomework(activeTypeValue)) {
      content = '「$courseName」发布了新作业：$typeTitle';
    } else {
      content = '「$courseName」发布了「${category.label}」';
    }

    return PushNotification(
      channel: PushChannel.imCourseActivity,
      category: category,
      title: typeTitle.isNotEmpty ? typeTitle : category.label,
      content: content,
      courseName: courseName,
      courseId: courseId,
      classId: classId,
      cpi: cpi,
      rawData: data,
    );
  }

  factory PushNotification.fromHomework(Map<String, dynamic> data) {
    final String title = data['title'] ?? '新作业';
    final String courseName = data['courseName'] ?? '未知课程';
    final String courseId = data['courseId']?.toString() ?? '';
    final String classId = data['classId']?.toString() ?? '';
    final String cpi = data['cpi']?.toString() ?? '';
    final String? url = data['url']?.toString();
    final String? workId = data['workId']?.toString();

    return PushNotification(
      channel: PushChannel.imHomework,
      category: PushCategory.homework,
      title: title,
      content: '「$courseName」发布了新作业：$title',
      courseName: courseName,
      courseId: courseId,
      classId: classId,
      cpi: cpi,
      rawData: data,
      homeworkUrl: url,
      homeworkId: workId,
    );
  }

  factory PushNotification.fromGroupSign(Map<String, dynamic> data) {
    final String title = data['title'] ?? '群聊签到';
    final String courseId = data['courseId']?.toString() ?? '';
    final String classId = data['classId']?.toString() ?? '';

    return PushNotification(
      channel: PushChannel.imGroupSign,
      category: PushCategory.groupSignIn,
      title: title,
      content: title,
      courseId: courseId,
      classId: classId,
      rawData: data,
    );
  }

  bool get hasHomeworkLink => homeworkUrl != null && homeworkUrl!.isNotEmpty;
  bool get isCourseActivity => channel == PushChannel.imCourseActivity;
  bool get isGroupSign => channel == PushChannel.imGroupSign;
}

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
  homework(19, '作业'),
  exam(19, '考试'),
  signIn(2, '签到'),
  scheduledSignIn(54, '定时签到'),
  groupSignIn(75, '群聊签到'),
  answer(4, '抢答'),
  pick(11, '选人'),
  questionnaire(14, '问卷'),
  vote(43, '投票'),
  topicDiscuss(5, '主题讨论'),
  quiz(42, '随堂练习'),
  evaluation(23, '评分'),
  groupTask(35, '分组任务'),
  live(17, '直播'),
  cxMeeting(56, '超星课堂'),
  tencentMeeting(64, '腾讯会议'),
  pptClass(40, 'PPT课堂'),
  notice(45, '通知'),
  feedback(46, '学生反馈'),
  interactivePractice(68, '互动练习'),
  aiEvaluate(77, 'AI实践'),
  punch(61, '打卡'),
  timer(47, '计时器'),
  whiteboard(49, '白板'),
  syncCourse(51, '同步课堂'),
  signOut(74, '签退'),
  draw(59, '抽签'),
  system(0, '系统通知'),
  courseNotice(1000, '课程通知');

  final int activeType;
  final String label;

  const PushCategory(this.activeType, this.label);

  static PushCategory fromActiveType(int type) {
    for (final category in values) {
      if (category.activeType == type) return category;
    }
    return system;
  }

  static bool isHomework(int type) => type == 19;
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

  bool get hasHomeworkLink => homeworkUrl != null && homeworkUrl!.isNotEmpty;
  bool get isCourseActivity => channel == PushChannel.imCourseActivity;
  bool get isGroupSign => channel == PushChannel.imGroupSign;
}

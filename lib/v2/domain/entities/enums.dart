enum PlatformType { chaoxing, rainClassroom }

enum RainClassroomServerType { yuketang, pro, changjiang, huanghe }

enum ActiveType {
  signIn(2, '签到'),
  answer(4, '抢答'),
  topicDiscuss(5, '主题讨论'),
  pick(11, '选人'),
  questionnaire(14, '问卷'),
  live(17, '直播'),
  work(19, '作业'),
  evaluation(23, '评分'),
  groupTask(35, '分组任务'),
  pptClass(40, 'PPT课堂'),
  quiz(42, '随堂练习'),
  vote(43, '投票'),
  notice(45, '通知'),
  feedback(46, '学生反馈'),
  timer(47, '计时器'),
  whiteboard(49, '白板'),
  syncCourse(51, '同步课堂'),
  scheduledSignIn(54, '定时签到'),
  cxMeeting(56, '超星课堂'),
  draw(59, '抽签'),
  tencentMeeting(64, '腾讯会议'),
  interactivePractice(68, '互动练习'),
  signOut(74, '签退'),
  groupSignIn(75, '群聊签到'),
  punch(61, '打卡'),
  aiEvaluate(77, 'AI实践');

  final int value;
  final String label;

  const ActiveType(this.value, this.label);

  static ActiveType? fromValue(int value) {
    for (final type in values) {
      if (type.value == value) return type;
    }
    return null;
  }
}

enum SignType { normal, qrCode, pattern, location, code }

const Map<int, SignType> signTypeIndexMap = {
  0: SignType.normal,
  2: SignType.qrCode,
  3: SignType.pattern,
  4: SignType.location,
  5: SignType.code,
};

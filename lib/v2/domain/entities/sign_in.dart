class SignIn {
  final String activeId;
  final String courseId;
  final String title;
  final int type;
  final int startTime;
  final int endTime;
  final String status;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? signCode;
  final bool isSigned;

  const SignIn({
    required this.activeId,
    required this.courseId,
    this.title = '',
    this.type = 0,
    this.startTime = 0,
    this.endTime = 0,
    this.status = '',
    this.address,
    this.latitude,
    this.longitude,
    this.signCode,
    this.isSigned = false,
  });

  SignIn copyWith({
    String? activeId,
    String? courseId,
    String? title,
    int? type,
    int? startTime,
    int? endTime,
    String? status,
    String? address,
    double? latitude,
    double? longitude,
    String? signCode,
    bool? isSigned,
  }) {
    return SignIn(
      activeId: activeId ?? this.activeId,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      signCode: signCode ?? this.signCode,
      isSigned: isSigned ?? this.isSigned,
    );
  }
}

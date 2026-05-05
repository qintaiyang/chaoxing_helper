class CourseLocation {
  final String? classroom;
  final String address;
  final String latitude;
  final String longitude;

  const CourseLocation({
    this.classroom,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  CourseLocation copyWith({
    String? classroom,
    String? address,
    String? latitude,
    String? longitude,
  }) {
    return CourseLocation(
      classroom: classroom ?? this.classroom,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}

class CourseSettings {
  final CourseLocation? location;
  final List<String>? imageObjectIds;

  const CourseSettings({this.location, this.imageObjectIds});

  CourseSettings copyWith({
    CourseLocation? location,
    List<String>? imageObjectIds,
  }) {
    return CourseSettings(
      location: location ?? this.location,
      imageObjectIds: imageObjectIds ?? this.imageObjectIds,
    );
  }
}

class Course {
  final String courseId;
  final String classId;
  final String? cpi;
  final String image;
  final String name;
  final String teacher;
  final bool state;
  final String? note;
  final String? schools;
  final String? beginDate;
  final String? endDate;
  final String? lessonId;
  final CourseSettings? settings;

  const Course({
    required this.courseId,
    required this.classId,
    this.cpi,
    required this.image,
    required this.name,
    required this.teacher,
    required this.state,
    this.note,
    this.schools,
    this.beginDate,
    this.endDate,
    this.lessonId,
    this.settings,
  });

  Course copyWith({
    String? courseId,
    String? classId,
    String? cpi,
    String? image,
    String? name,
    String? teacher,
    bool? state,
    String? note,
    String? schools,
    String? beginDate,
    String? endDate,
    String? lessonId,
    CourseSettings? settings,
  }) {
    return Course(
      courseId: courseId ?? this.courseId,
      classId: classId ?? this.classId,
      cpi: cpi ?? this.cpi,
      image: image ?? this.image,
      name: name ?? this.name,
      teacher: teacher ?? this.teacher,
      state: state ?? this.state,
      note: note ?? this.note,
      schools: schools ?? this.schools,
      beginDate: beginDate ?? this.beginDate,
      endDate: endDate ?? this.endDate,
      lessonId: lessonId ?? this.lessonId,
      settings: settings ?? this.settings,
    );
  }
}

import '../../domain/entities/notice.dart';
import '../models/notice_dto.dart';

class NoticeMapper {
  static Notice toEntity(NoticeDto dto, {String courseId = ''}) {
    return Notice(
      noticeId: dto.noticeId,
      courseId: dto.courseId.isNotEmpty ? dto.courseId : courseId,
      title: dto.title,
      content: dto.content,
      author: dto.author,
      createTime: dto.createTime,
      isRead: dto.isRead,
      folderId: dto.folderId,
    );
  }

  static List<Notice> toEntityList(
    List<NoticeDto> dtos, {
    String courseId = '',
  }) {
    return dtos.map((dto) => toEntity(dto, courseId: courseId)).toList();
  }
}

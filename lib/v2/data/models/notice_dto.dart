import 'package:freezed_annotation/freezed_annotation.dart';

part 'notice_dto.freezed.dart';
part 'notice_dto.g.dart';

@Freezed(fromJson: true, toJson: true)
class NoticeDto with _$NoticeDto {
  const factory NoticeDto({
    @Default('') String noticeId,
    @Default('') String title,
    @Default('') String content,
    @Default('') String author,
    @Default(0) int createTime,
    @Default(false) bool isRead,
    @Default('') String courseId,
    @Default('') String folderId,
    @Default({}) Map<String, dynamic> extras,
  }) = _NoticeDto;

  factory NoticeDto.fromJson(Map<String, dynamic> json) =>
      _$NoticeDtoFromJson(json);
}

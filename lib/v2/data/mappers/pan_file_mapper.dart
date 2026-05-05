import '../../domain/entities/pan_file.dart';
import '../models/pan_file_dto.dart';

class PanFileMapper {
  static PanFile toEntity(PanFileDto dto) {
    return PanFile(
      fileId: dto.fileId,
      fileName: dto.fileName,
      fileType: dto.fileType,
      fileSize: dto.fileSize,
      fileUrl: dto.fileUrl,
      encryptedId: dto.encryptedId,
      parentId: dto.parentId,
      isFolder: dto.isFolder,
      isPinned: dto.isPinned,
      createTime: dto.createTime,
      updateTime: dto.updateTime,
      thumbnailUrl: dto.thumbnailUrl,
    );
  }

  static List<PanFile> toEntityList(List<PanFileDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}

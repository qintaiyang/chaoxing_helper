class PanFile {
  final String fileId;
  final String fileName;
  final String fileType;
  final int fileSize;
  final String fileUrl;
  final String encryptedId;
  final String parentId;
  final bool isFolder;
  final bool isPinned;
  final int createTime;
  final int updateTime;
  final String thumbnailUrl;

  const PanFile({
    required this.fileId,
    required this.fileName,
    this.fileType = '',
    this.fileSize = 0,
    this.fileUrl = '',
    this.encryptedId = '',
    this.parentId = '',
    this.isFolder = false,
    this.isPinned = false,
    this.createTime = 0,
    this.updateTime = 0,
    this.thumbnailUrl = '',
  });

  PanFile copyWith({
    String? fileId,
    String? fileName,
    String? fileType,
    int? fileSize,
    String? fileUrl,
    String? encryptedId,
    String? parentId,
    bool? isFolder,
    bool? isPinned,
    int? createTime,
    int? updateTime,
    String? thumbnailUrl,
  }) {
    return PanFile(
      fileId: fileId ?? this.fileId,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      fileUrl: fileUrl ?? this.fileUrl,
      encryptedId: encryptedId ?? this.encryptedId,
      parentId: parentId ?? this.parentId,
      isFolder: isFolder ?? this.isFolder,
      isPinned: isPinned ?? this.isPinned,
      createTime: createTime ?? this.createTime,
      updateTime: updateTime ?? this.updateTime,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}

class Material {
  final String id;
  final String name;
  final bool isFile;
  final String? suffix;
  final int? size;
  final String? objectId;
  final int? puid;
  final int? ownerPuid;
  final bool forbidDownload;
  final int? cataId;
  final String? cataName;
  final int? orderId;

  const Material({
    required this.id,
    required this.name,
    required this.isFile,
    this.suffix,
    this.size,
    this.objectId,
    this.puid,
    this.ownerPuid,
    this.forbidDownload = false,
    this.cataId,
    this.cataName,
    this.orderId,
  });
}

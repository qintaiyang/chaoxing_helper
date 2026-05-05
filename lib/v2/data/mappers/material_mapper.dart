import '../../domain/entities/material.dart';
import '../models/material_dto.dart';

class MaterialMapper {
  static Material toEntity(MaterialDto dto) {
    return Material(
      id: dto.id.isNotEmpty ? dto.id : dto.objectId,
      name: dto.dataName.isNotEmpty ? dto.dataName : '未知文件',
      isFile: dto.isfile,
      suffix: dto.suffix,
      size: dto.size,
      objectId: dto.objectId.isNotEmpty ? dto.objectId : dto.id,
      puid: dto.puid,
      ownerPuid: dto.ownerPuid > 0 ? dto.ownerPuid : null,
      forbidDownload: dto.forbidDownload == 1,
      cataId: dto.cfid > 0 ? dto.cfid : null,
      cataName: dto.cataName.isNotEmpty ? dto.cataName : null,
      orderId: dto.orderId > 0 ? dto.orderId : null,
    );
  }

  static List<Material> toEntityList(List<MaterialDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}

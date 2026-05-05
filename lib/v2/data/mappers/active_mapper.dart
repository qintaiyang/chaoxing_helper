import '../../domain/entities/active.dart';
import '../../domain/entities/enums.dart';
import '../models/active_dto.dart';

extension ActiveDtoX on ActiveDto {
  Active toEntity() => Active(
    type: type,
    id: id,
    name: name,
    description: description,
    startTime: startTime,
    url: url,
    attendNum: attendNum,
    status: status,
    extras: extras,
    signType: signTypeIndexMap[signType],
  );
}

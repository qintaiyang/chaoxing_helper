import '../../domain/entities/sign_in.dart';
import '../models/signin_dto.dart';

class SignInMapper {
  static SignIn toEntity(
    SignInDto dto, {
    String courseId = '',
    String activeId = '',
  }) {
    return SignIn(
      activeId: activeId,
      courseId: courseId,
      title: dto.message,
      type: dto.signType,
      startTime: 0,
      endTime: 0,
      status: dto.result,
      address: dto.address.isNotEmpty ? dto.address : null,
      latitude: dto.latitude != 0 ? dto.latitude : null,
      longitude: dto.longitude != 0 ? dto.longitude : null,
      isSigned: dto.success,
    );
  }
}

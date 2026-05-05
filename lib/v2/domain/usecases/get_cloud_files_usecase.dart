import 'package:fpdart/fpdart.dart';
import '../entities/pan_file.dart';
import '../repositories/pan_repository.dart';
import '../failures/failure.dart';

class GetCloudFilesUseCase {
  final PanRepository _panRepo;

  GetCloudFilesUseCase(this._panRepo);

  Future<Either<Failure, List<PanFile>>> execute({
    String fldid = '0',
    int page = 1,
    int size = 20,
    String filterType = '',
    String orderField = 'default',
    String orderType = 'desc',
    String searchValue = '',
  }) {
    return _panRepo.getMyCloudFiles(
      fldid: fldid,
      page: page,
      size: size,
      filterType: filterType,
      orderField: orderField,
      orderType: orderType,
      searchValue: searchValue,
    );
  }
}

import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../entities/pan_file.dart';
import '../repositories/pan_repository.dart';
import '../failures/failure.dart';

class UploadFileUseCase {
  final PanRepository _repo;
  UploadFileUseCase(this._repo);

  Future<Either<Failure, PanFile>> execute({
    required File file,
    required String folderId,
    void Function(int, int)? onProgress,
  }) {
    return _repo.uploadFile(
      file: file,
      folderId: folderId,
      onProgress: onProgress,
    );
  }
}

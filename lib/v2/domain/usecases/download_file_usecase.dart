import 'dart:io';
import 'package:fpdart/fpdart.dart';
import '../entities/pan_file.dart';
import '../repositories/pan_repository.dart';
import '../failures/failure.dart';

class DownloadFileUseCase {
  final PanRepository _repo;
  DownloadFileUseCase(this._repo);

  Future<Either<Failure, File>> execute({
    required PanFile file,
    required Directory saveDir,
    void Function(int, int)? onProgress,
  }) {
    return _repo.downloadFile(
      file: file,
      saveDir: saveDir,
      onProgress: onProgress,
    );
  }
}

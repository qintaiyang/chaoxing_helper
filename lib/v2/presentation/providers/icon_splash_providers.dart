import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/local/icon_splash_local_data_source.dart';
import '../../data/repositories/icon_splash_repository_impl.dart';
import '../../domain/repositories/icon_splash_repository.dart';
import '../../domain/usecases/pick_save_icon_usecase.dart';
import '../../domain/usecases/pick_save_splash_usecase.dart';
import '../../domain/usecases/apply_icon_to_slot_usecase.dart';
import '../../domain/usecases/switch_icon_usecase.dart';
import '../../domain/usecases/get_current_icon_index_usecase.dart';
import '../../domain/usecases/get_saved_icon_path_usecase.dart';
import '../../domain/usecases/get_saved_splash_path_usecase.dart';
import '../../domain/usecases/clear_saved_icon_usecase.dart';
import '../../domain/usecases/clear_saved_splash_usecase.dart';
import '../../domain/usecases/update_splash_image_usecase.dart';
import '../../infra/storage/storage_service.dart';

part 'icon_splash_providers.g.dart';

@riverpod
IconSplashLocalDataSource iconSplashLocalDataSource(
    IconSplashLocalDataSourceRef ref) {
  return IconSplashLocalDataSource();
}

@riverpod
IconSplashRepository iconSplashRepository(IconSplashRepositoryRef ref) {
  final localDataSource = ref.watch(iconSplashLocalDataSourceProvider);
  final storage = SharedPreferencesStorage.instance;
  return IconSplashRepositoryImpl(localDataSource, storage);
}

@riverpod
PickAndSaveIconUseCase pickAndSaveIconUseCase(PickAndSaveIconUseCaseRef ref) {
  final repository = ref.watch(iconSplashRepositoryProvider);
  return PickAndSaveIconUseCase(repository);
}

@riverpod
PickAndSaveSplashImageUseCase pickAndSaveSplashImageUseCase(
    PickAndSaveSplashImageUseCaseRef ref) {
  final repository = ref.watch(iconSplashRepositoryProvider);
  return PickAndSaveSplashImageUseCase(repository);
}

@riverpod
ApplyIconToSlotUseCase applyIconToSlotUseCase(ApplyIconToSlotUseCaseRef ref) {
  final repository = ref.watch(iconSplashRepositoryProvider);
  return ApplyIconToSlotUseCase(repository);
}

@riverpod
SwitchIconUseCase switchIconUseCase(SwitchIconUseCaseRef ref) {
  final repository = ref.watch(iconSplashRepositoryProvider);
  return SwitchIconUseCase(repository);
}

@riverpod
GetCurrentIconIndexUseCase getCurrentIconIndexUseCase(
    GetCurrentIconIndexUseCaseRef ref) {
  final repository = ref.watch(iconSplashRepositoryProvider);
  return GetCurrentIconIndexUseCase(repository);
}

@riverpod
GetSavedIconPathUseCase getSavedIconPathUseCase(
    GetSavedIconPathUseCaseRef ref) {
  final repository = ref.watch(iconSplashRepositoryProvider);
  return GetSavedIconPathUseCase(repository);
}

@riverpod
GetSavedSplashPathUseCase getSavedSplashPathUseCase(
    GetSavedSplashPathUseCaseRef ref) {
  final repository = ref.watch(iconSplashRepositoryProvider);
  return GetSavedSplashPathUseCase(repository);
}

@riverpod
ClearSavedIconUseCase clearSavedIconUseCase(ClearSavedIconUseCaseRef ref) {
  final repository = ref.watch(iconSplashRepositoryProvider);
  return ClearSavedIconUseCase(repository);
}

@riverpod
ClearSavedSplashUseCase clearSavedSplashUseCase(
    ClearSavedSplashUseCaseRef ref) {
  final repository = ref.watch(iconSplashRepositoryProvider);
  return ClearSavedSplashUseCase(repository);
}

@riverpod
UpdateSplashImageUseCase updateSplashImageUseCase(
    UpdateSplashImageUseCaseRef ref) {
  final repository = ref.watch(iconSplashRepositoryProvider);
  return UpdateSplashImageUseCase(repository);
}

import 'package:fpdart/fpdart.dart';
import '../failures/failure.dart';

abstract class ThemeRepository {
  String getActiveThemeId();
  Future<Either<Failure, void>> activateTheme(String themeId);
  Future<Either<Failure, void>> installTheme(Map<String, dynamic> themeJson);
  Future<Either<Failure, void>> uninstallTheme(String themeId);
  Future<Either<Failure, void>> updateTheme(Map<String, dynamic> themeJson);
  Map<String, dynamic>? getActiveTheme();
  List<Map<String, dynamic>> getInstalledThemes();
}

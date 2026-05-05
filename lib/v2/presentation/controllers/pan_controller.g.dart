// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pan_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recycleBinHash() => r'4c1a22871d44eefecc0d5735de57c6296aa738ae';

/// See also [recycleBin].
@ProviderFor(recycleBin)
final recycleBinProvider = AutoDisposeFutureProvider<List<PanFile>>.internal(
  recycleBin,
  name: r'recycleBinProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recycleBinHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecycleBinRef = AutoDisposeFutureProviderRef<List<PanFile>>;
String _$panListControllerHash() => r'c7f4acb2873811834564491f1fba964620935c1a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PanListController
    extends BuildlessAutoDisposeAsyncNotifier<List<PanFile>> {
  late final String folderId;

  FutureOr<List<PanFile>> build({String folderId = '0'});
}

/// See also [PanListController].
@ProviderFor(PanListController)
const panListControllerProvider = PanListControllerFamily();

/// See also [PanListController].
class PanListControllerFamily extends Family<AsyncValue<List<PanFile>>> {
  /// See also [PanListController].
  const PanListControllerFamily();

  /// See also [PanListController].
  PanListControllerProvider call({String folderId = '0'}) {
    return PanListControllerProvider(folderId: folderId);
  }

  @override
  PanListControllerProvider getProviderOverride(
    covariant PanListControllerProvider provider,
  ) {
    return call(folderId: provider.folderId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'panListControllerProvider';
}

/// See also [PanListController].
class PanListControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<PanListController, List<PanFile>> {
  /// See also [PanListController].
  PanListControllerProvider({String folderId = '0'})
    : this._internal(
        () => PanListController()..folderId = folderId,
        from: panListControllerProvider,
        name: r'panListControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$panListControllerHash,
        dependencies: PanListControllerFamily._dependencies,
        allTransitiveDependencies:
            PanListControllerFamily._allTransitiveDependencies,
        folderId: folderId,
      );

  PanListControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.folderId,
  }) : super.internal();

  final String folderId;

  @override
  FutureOr<List<PanFile>> runNotifierBuild(
    covariant PanListController notifier,
  ) {
    return notifier.build(folderId: folderId);
  }

  @override
  Override overrideWith(PanListController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PanListControllerProvider._internal(
        () => create()..folderId = folderId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        folderId: folderId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PanListController, List<PanFile>>
  createElement() {
    return _PanListControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PanListControllerProvider && other.folderId == folderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, folderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PanListControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<PanFile>> {
  /// The parameter `folderId` of this provider.
  String get folderId;
}

class _PanListControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PanListController,
          List<PanFile>
        >
    with PanListControllerRef {
  _PanListControllerProviderElement(super.provider);

  @override
  String get folderId => (origin as PanListControllerProvider).folderId;
}

String _$fileUploadControllerHash() =>
    r'd176617e0a43e7d3154ec2ecc0671c40aa08a200';

/// See also [FileUploadController].
@ProviderFor(FileUploadController)
final fileUploadControllerProvider =
    AutoDisposeNotifierProvider<FileUploadController, double>.internal(
      FileUploadController.new,
      name: r'fileUploadControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fileUploadControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FileUploadController = AutoDisposeNotifier<double>;
String _$fileDownloadControllerHash() =>
    r'fa0caa35ff68a7bbff59441604715866898d5d1e';

/// See also [FileDownloadController].
@ProviderFor(FileDownloadController)
final fileDownloadControllerProvider =
    AutoDisposeNotifierProvider<FileDownloadController, double>.internal(
      FileDownloadController.new,
      name: r'fileDownloadControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fileDownloadControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FileDownloadController = AutoDisposeNotifier<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

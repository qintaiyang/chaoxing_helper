// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homework_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeworkListControllerHash() =>
    r'0a6c570c5f4f9cc37ae39decebad483a2be1af25';

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

abstract class _$HomeworkListController
    extends BuildlessAutoDisposeAsyncNotifier<List<HomeworkInfo>> {
  late final String courseId;
  late final String classId;
  late final String cpi;

  FutureOr<List<HomeworkInfo>> build(
    String courseId,
    String classId,
    String cpi,
  );
}

/// See also [HomeworkListController].
@ProviderFor(HomeworkListController)
const homeworkListControllerProvider = HomeworkListControllerFamily();

/// See also [HomeworkListController].
class HomeworkListControllerFamily
    extends Family<AsyncValue<List<HomeworkInfo>>> {
  /// See also [HomeworkListController].
  const HomeworkListControllerFamily();

  /// See also [HomeworkListController].
  HomeworkListControllerProvider call(
    String courseId,
    String classId,
    String cpi,
  ) {
    return HomeworkListControllerProvider(courseId, classId, cpi);
  }

  @override
  HomeworkListControllerProvider getProviderOverride(
    covariant HomeworkListControllerProvider provider,
  ) {
    return call(provider.courseId, provider.classId, provider.cpi);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'homeworkListControllerProvider';
}

/// See also [HomeworkListController].
class HomeworkListControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          HomeworkListController,
          List<HomeworkInfo>
        > {
  /// See also [HomeworkListController].
  HomeworkListControllerProvider(String courseId, String classId, String cpi)
    : this._internal(
        () => HomeworkListController()
          ..courseId = courseId
          ..classId = classId
          ..cpi = cpi,
        from: homeworkListControllerProvider,
        name: r'homeworkListControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$homeworkListControllerHash,
        dependencies: HomeworkListControllerFamily._dependencies,
        allTransitiveDependencies:
            HomeworkListControllerFamily._allTransitiveDependencies,
        courseId: courseId,
        classId: classId,
        cpi: cpi,
      );

  HomeworkListControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
    required this.classId,
    required this.cpi,
  }) : super.internal();

  final String courseId;
  final String classId;
  final String cpi;

  @override
  FutureOr<List<HomeworkInfo>> runNotifierBuild(
    covariant HomeworkListController notifier,
  ) {
    return notifier.build(courseId, classId, cpi);
  }

  @override
  Override overrideWith(HomeworkListController Function() create) {
    return ProviderOverride(
      origin: this,
      override: HomeworkListControllerProvider._internal(
        () => create()
          ..courseId = courseId
          ..classId = classId
          ..cpi = cpi,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
        classId: classId,
        cpi: cpi,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    HomeworkListController,
    List<HomeworkInfo>
  >
  createElement() {
    return _HomeworkListControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HomeworkListControllerProvider &&
        other.courseId == courseId &&
        other.classId == classId &&
        other.cpi == cpi;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);
    hash = _SystemHash.combine(hash, classId.hashCode);
    hash = _SystemHash.combine(hash, cpi.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HomeworkListControllerRef
    on AutoDisposeAsyncNotifierProviderRef<List<HomeworkInfo>> {
  /// The parameter `courseId` of this provider.
  String get courseId;

  /// The parameter `classId` of this provider.
  String get classId;

  /// The parameter `cpi` of this provider.
  String get cpi;
}

class _HomeworkListControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          HomeworkListController,
          List<HomeworkInfo>
        >
    with HomeworkListControllerRef {
  _HomeworkListControllerProviderElement(super.provider);

  @override
  String get courseId => (origin as HomeworkListControllerProvider).courseId;
  @override
  String get classId => (origin as HomeworkListControllerProvider).classId;
  @override
  String get cpi => (origin as HomeworkListControllerProvider).cpi;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

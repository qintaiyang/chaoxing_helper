// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$examListControllerHash() =>
    r'e24e39a27ba64756dd43e5b168f897dc01886f96';

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

abstract class _$ExamListController
    extends BuildlessAutoDisposeAsyncNotifier<List<Exam>> {
  late final String courseId;
  late final String classId;

  FutureOr<List<Exam>> build(String courseId, String classId);
}

/// See also [ExamListController].
@ProviderFor(ExamListController)
const examListControllerProvider = ExamListControllerFamily();

/// See also [ExamListController].
class ExamListControllerFamily extends Family<AsyncValue<List<Exam>>> {
  /// See also [ExamListController].
  const ExamListControllerFamily();

  /// See also [ExamListController].
  ExamListControllerProvider call(String courseId, String classId) {
    return ExamListControllerProvider(courseId, classId);
  }

  @override
  ExamListControllerProvider getProviderOverride(
    covariant ExamListControllerProvider provider,
  ) {
    return call(provider.courseId, provider.classId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'examListControllerProvider';
}

/// See also [ExamListController].
class ExamListControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<ExamListController, List<Exam>> {
  /// See also [ExamListController].
  ExamListControllerProvider(String courseId, String classId)
    : this._internal(
        () => ExamListController()
          ..courseId = courseId
          ..classId = classId,
        from: examListControllerProvider,
        name: r'examListControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$examListControllerHash,
        dependencies: ExamListControllerFamily._dependencies,
        allTransitiveDependencies:
            ExamListControllerFamily._allTransitiveDependencies,
        courseId: courseId,
        classId: classId,
      );

  ExamListControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
    required this.classId,
  }) : super.internal();

  final String courseId;
  final String classId;

  @override
  FutureOr<List<Exam>> runNotifierBuild(covariant ExamListController notifier) {
    return notifier.build(courseId, classId);
  }

  @override
  Override overrideWith(ExamListController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExamListControllerProvider._internal(
        () => create()
          ..courseId = courseId
          ..classId = classId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
        classId: classId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ExamListController, List<Exam>>
  createElement() {
    return _ExamListControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExamListControllerProvider &&
        other.courseId == courseId &&
        other.classId == classId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);
    hash = _SystemHash.combine(hash, classId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExamListControllerRef on AutoDisposeAsyncNotifierProviderRef<List<Exam>> {
  /// The parameter `courseId` of this provider.
  String get courseId;

  /// The parameter `classId` of this provider.
  String get classId;
}

class _ExamListControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<ExamListController, List<Exam>>
    with ExamListControllerRef {
  _ExamListControllerProviderElement(super.provider);

  @override
  String get courseId => (origin as ExamListControllerProvider).courseId;
  @override
  String get classId => (origin as ExamListControllerProvider).classId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

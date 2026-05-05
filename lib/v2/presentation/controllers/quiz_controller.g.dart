// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quizDetailControllerHash() =>
    r'e8104a95d6fa736eb209b1e7d8e7fc6ae9c121cd';

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

abstract class _$QuizDetailController
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final String activeId;

  FutureOr<Map<String, dynamic>> build(String activeId);
}

/// See also [QuizDetailController].
@ProviderFor(QuizDetailController)
const quizDetailControllerProvider = QuizDetailControllerFamily();

/// See also [QuizDetailController].
class QuizDetailControllerFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [QuizDetailController].
  const QuizDetailControllerFamily();

  /// See also [QuizDetailController].
  QuizDetailControllerProvider call(String activeId) {
    return QuizDetailControllerProvider(activeId);
  }

  @override
  QuizDetailControllerProvider getProviderOverride(
    covariant QuizDetailControllerProvider provider,
  ) {
    return call(provider.activeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quizDetailControllerProvider';
}

/// See also [QuizDetailController].
class QuizDetailControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          QuizDetailController,
          Map<String, dynamic>
        > {
  /// See also [QuizDetailController].
  QuizDetailControllerProvider(String activeId)
    : this._internal(
        () => QuizDetailController()..activeId = activeId,
        from: quizDetailControllerProvider,
        name: r'quizDetailControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$quizDetailControllerHash,
        dependencies: QuizDetailControllerFamily._dependencies,
        allTransitiveDependencies:
            QuizDetailControllerFamily._allTransitiveDependencies,
        activeId: activeId,
      );

  QuizDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.activeId,
  }) : super.internal();

  final String activeId;

  @override
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant QuizDetailController notifier,
  ) {
    return notifier.build(activeId);
  }

  @override
  Override overrideWith(QuizDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuizDetailControllerProvider._internal(
        () => create()..activeId = activeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        activeId: activeId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    QuizDetailController,
    Map<String, dynamic>
  >
  createElement() {
    return _QuizDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizDetailControllerProvider && other.activeId == activeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, activeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuizDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `activeId` of this provider.
  String get activeId;
}

class _QuizDetailControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          QuizDetailController,
          Map<String, dynamic>
        >
    with QuizDetailControllerRef {
  _QuizDetailControllerProviderElement(super.provider);

  @override
  String get activeId => (origin as QuizDetailControllerProvider).activeId;
}

String _$quizStatusControllerHash() =>
    r'3f55f6f19fbb27d149c0c16fd474084b265c66a5';

abstract class _$QuizStatusController
    extends BuildlessAutoDisposeAsyncNotifier<bool> {
  late final String classId;
  late final String activeId;

  FutureOr<bool> build(String classId, String activeId);
}

/// See also [QuizStatusController].
@ProviderFor(QuizStatusController)
const quizStatusControllerProvider = QuizStatusControllerFamily();

/// See also [QuizStatusController].
class QuizStatusControllerFamily extends Family<AsyncValue<bool>> {
  /// See also [QuizStatusController].
  const QuizStatusControllerFamily();

  /// See also [QuizStatusController].
  QuizStatusControllerProvider call(String classId, String activeId) {
    return QuizStatusControllerProvider(classId, activeId);
  }

  @override
  QuizStatusControllerProvider getProviderOverride(
    covariant QuizStatusControllerProvider provider,
  ) {
    return call(provider.classId, provider.activeId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quizStatusControllerProvider';
}

/// See also [QuizStatusController].
class QuizStatusControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<QuizStatusController, bool> {
  /// See also [QuizStatusController].
  QuizStatusControllerProvider(String classId, String activeId)
    : this._internal(
        () => QuizStatusController()
          ..classId = classId
          ..activeId = activeId,
        from: quizStatusControllerProvider,
        name: r'quizStatusControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$quizStatusControllerHash,
        dependencies: QuizStatusControllerFamily._dependencies,
        allTransitiveDependencies:
            QuizStatusControllerFamily._allTransitiveDependencies,
        classId: classId,
        activeId: activeId,
      );

  QuizStatusControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.classId,
    required this.activeId,
  }) : super.internal();

  final String classId;
  final String activeId;

  @override
  FutureOr<bool> runNotifierBuild(covariant QuizStatusController notifier) {
    return notifier.build(classId, activeId);
  }

  @override
  Override overrideWith(QuizStatusController Function() create) {
    return ProviderOverride(
      origin: this,
      override: QuizStatusControllerProvider._internal(
        () => create()
          ..classId = classId
          ..activeId = activeId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        classId: classId,
        activeId: activeId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<QuizStatusController, bool>
  createElement() {
    return _QuizStatusControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuizStatusControllerProvider &&
        other.classId == classId &&
        other.activeId == activeId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, classId.hashCode);
    hash = _SystemHash.combine(hash, activeId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuizStatusControllerRef on AutoDisposeAsyncNotifierProviderRef<bool> {
  /// The parameter `classId` of this provider.
  String get classId;

  /// The parameter `activeId` of this provider.
  String get activeId;
}

class _QuizStatusControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<QuizStatusController, bool>
    with QuizStatusControllerRef {
  _QuizStatusControllerProviderElement(super.provider);

  @override
  String get classId => (origin as QuizStatusControllerProvider).classId;
  @override
  String get activeId => (origin as QuizStatusControllerProvider).activeId;
}

String _$quizSubmitControllerHash() =>
    r'ce77400f2e53d750b043a8f6108fbf53d305735d';

/// See also [QuizSubmitController].
@ProviderFor(QuizSubmitController)
final quizSubmitControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      QuizSubmitController,
      Map<String, dynamic>
    >.internal(
      QuizSubmitController.new,
      name: r'quizSubmitControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$quizSubmitControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$QuizSubmitController = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'requirement_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchRequirementsHash() => r'34633ab28ed17203c4aec9a54bd73b9ea3a192df';

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

/// See also [fetchRequirements].
@ProviderFor(fetchRequirements)
const fetchRequirementsProvider = FetchRequirementsFamily();

/// See also [fetchRequirements].
class FetchRequirementsFamily extends Family<AsyncValue<List<Requirement>>> {
  /// See also [fetchRequirements].
  const FetchRequirementsFamily();

  /// See also [fetchRequirements].
  FetchRequirementsProvider call(
    String token,
  ) {
    return FetchRequirementsProvider(
      token,
    );
  }

  @override
  FetchRequirementsProvider getProviderOverride(
    covariant FetchRequirementsProvider provider,
  ) {
    return call(
      provider.token,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchRequirementsProvider';
}

/// See also [fetchRequirements].
class FetchRequirementsProvider
    extends AutoDisposeFutureProvider<List<Requirement>> {
  /// See also [fetchRequirements].
  FetchRequirementsProvider(
    String token,
  ) : this._internal(
          (ref) => fetchRequirements(
            ref as FetchRequirementsRef,
            token,
          ),
          from: fetchRequirementsProvider,
          name: r'fetchRequirementsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchRequirementsHash,
          dependencies: FetchRequirementsFamily._dependencies,
          allTransitiveDependencies:
              FetchRequirementsFamily._allTransitiveDependencies,
          token: token,
        );

  FetchRequirementsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
  }) : super.internal();

  final String token;

  @override
  Override overrideWith(
    FutureOr<List<Requirement>> Function(FetchRequirementsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchRequirementsProvider._internal(
        (ref) => create(ref as FetchRequirementsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Requirement>> createElement() {
    return _FetchRequirementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchRequirementsProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchRequirementsRef on AutoDisposeFutureProviderRef<List<Requirement>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchRequirementsProviderElement
    extends AutoDisposeFutureProviderElement<List<Requirement>>
    with FetchRequirementsRef {
  _FetchRequirementsProviderElement(super.provider);

  @override
  String get token => (origin as FetchRequirementsProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'college_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchCollegesHash() => r'a169d6bbd9b0300025e7282165862e75cf0a19bf';

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

/// See also [fetchColleges].
@ProviderFor(fetchColleges)
const fetchCollegesProvider = FetchCollegesFamily();

/// See also [fetchColleges].
class FetchCollegesFamily extends Family<AsyncValue<List<College>>> {
  /// See also [fetchColleges].
  const FetchCollegesFamily();

  /// See also [fetchColleges].
  FetchCollegesProvider call(
    String token,
  ) {
    return FetchCollegesProvider(
      token,
    );
  }

  @override
  FetchCollegesProvider getProviderOverride(
    covariant FetchCollegesProvider provider,
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
  String? get name => r'fetchCollegesProvider';
}

/// See also [fetchColleges].
class FetchCollegesProvider extends AutoDisposeFutureProvider<List<College>> {
  /// See also [fetchColleges].
  FetchCollegesProvider(
    String token,
  ) : this._internal(
          (ref) => fetchColleges(
            ref as FetchCollegesRef,
            token,
          ),
          from: fetchCollegesProvider,
          name: r'fetchCollegesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchCollegesHash,
          dependencies: FetchCollegesFamily._dependencies,
          allTransitiveDependencies:
              FetchCollegesFamily._allTransitiveDependencies,
          token: token,
        );

  FetchCollegesProvider._internal(
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
    FutureOr<List<College>> Function(FetchCollegesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchCollegesProvider._internal(
        (ref) => create(ref as FetchCollegesRef),
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
  AutoDisposeFutureProviderElement<List<College>> createElement() {
    return _FetchCollegesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchCollegesProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchCollegesRef on AutoDisposeFutureProviderRef<List<College>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchCollegesProviderElement
    extends AutoDisposeFutureProviderElement<List<College>>
    with FetchCollegesRef {
  _FetchCollegesProviderElement(super.provider);

  @override
  String get token => (origin as FetchCollegesProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

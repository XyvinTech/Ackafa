// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchFeedsHash() => r'a450d462cc72a6ea75d4d86237054207f47c3f19';

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

/// See also [fetchFeeds].
@ProviderFor(fetchFeeds)
const fetchFeedsProvider = FetchFeedsFamily();

/// See also [fetchFeeds].
class FetchFeedsFamily extends Family<AsyncValue<List<Feed>>> {
  /// See also [fetchFeeds].
  const FetchFeedsFamily();

  /// See also [fetchFeeds].
  FetchFeedsProvider call(
    String token,
  ) {
    return FetchFeedsProvider(
      token,
    );
  }

  @override
  FetchFeedsProvider getProviderOverride(
    covariant FetchFeedsProvider provider,
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
  String? get name => r'fetchFeedsProvider';
}

/// See also [fetchFeeds].
class FetchFeedsProvider extends AutoDisposeFutureProvider<List<Feed>> {
  /// See also [fetchFeeds].
  FetchFeedsProvider(
    String token,
  ) : this._internal(
          (ref) => fetchFeeds(
            ref as FetchFeedsRef,
            token,
          ),
          from: fetchFeedsProvider,
          name: r'fetchFeedsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchFeedsHash,
          dependencies: FetchFeedsFamily._dependencies,
          allTransitiveDependencies:
              FetchFeedsFamily._allTransitiveDependencies,
          token: token,
        );

  FetchFeedsProvider._internal(
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
    FutureOr<List<Feed>> Function(FetchFeedsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchFeedsProvider._internal(
        (ref) => create(ref as FetchFeedsRef),
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
  AutoDisposeFutureProviderElement<List<Feed>> createElement() {
    return _FetchFeedsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchFeedsProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchFeedsRef on AutoDisposeFutureProviderRef<List<Feed>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchFeedsProviderElement
    extends AutoDisposeFutureProviderElement<List<Feed>> with FetchFeedsRef {
  _FetchFeedsProviderElement(super.provider);

  @override
  String get token => (origin as FetchFeedsProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

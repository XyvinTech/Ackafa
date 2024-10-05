// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotions_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchPromotionsHash() => r'8d97b02b19a0786631701616084a0793c080826b';

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

/// See also [fetchPromotions].
@ProviderFor(fetchPromotions)
const fetchPromotionsProvider = FetchPromotionsFamily();

/// See also [fetchPromotions].
class FetchPromotionsFamily extends Family<AsyncValue<List<Promotion>>> {
  /// See also [fetchPromotions].
  const FetchPromotionsFamily();

  /// See also [fetchPromotions].
  FetchPromotionsProvider call(
    String token,
  ) {
    return FetchPromotionsProvider(
      token,
    );
  }

  @override
  FetchPromotionsProvider getProviderOverride(
    covariant FetchPromotionsProvider provider,
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
  String? get name => r'fetchPromotionsProvider';
}

/// See also [fetchPromotions].
class FetchPromotionsProvider
    extends AutoDisposeFutureProvider<List<Promotion>> {
  /// See also [fetchPromotions].
  FetchPromotionsProvider(
    String token,
  ) : this._internal(
          (ref) => fetchPromotions(
            ref as FetchPromotionsRef,
            token,
          ),
          from: fetchPromotionsProvider,
          name: r'fetchPromotionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchPromotionsHash,
          dependencies: FetchPromotionsFamily._dependencies,
          allTransitiveDependencies:
              FetchPromotionsFamily._allTransitiveDependencies,
          token: token,
        );

  FetchPromotionsProvider._internal(
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
    FutureOr<List<Promotion>> Function(FetchPromotionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchPromotionsProvider._internal(
        (ref) => create(ref as FetchPromotionsRef),
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
  AutoDisposeFutureProviderElement<List<Promotion>> createElement() {
    return _FetchPromotionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchPromotionsProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchPromotionsRef on AutoDisposeFutureProviderRef<List<Promotion>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchPromotionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Promotion>>
    with FetchPromotionsRef {
  _FetchPromotionsProviderElement(super.provider);

  @override
  String get token => (origin as FetchPromotionsProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

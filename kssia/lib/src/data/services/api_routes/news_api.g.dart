// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchNewsHash() => r'164953c336b3ec6cc4c55226a6a94be0f1e33f5a';

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

/// See also [fetchNews].
@ProviderFor(fetchNews)
const fetchNewsProvider = FetchNewsFamily();

/// See also [fetchNews].
class FetchNewsFamily extends Family<AsyncValue<List<News>>> {
  /// See also [fetchNews].
  const FetchNewsFamily();

  /// See also [fetchNews].
  FetchNewsProvider call(
    String token,
  ) {
    return FetchNewsProvider(
      token,
    );
  }

  @override
  FetchNewsProvider getProviderOverride(
    covariant FetchNewsProvider provider,
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
  String? get name => r'fetchNewsProvider';
}

/// See also [fetchNews].
class FetchNewsProvider extends AutoDisposeFutureProvider<List<News>> {
  /// See also [fetchNews].
  FetchNewsProvider(
    String token,
  ) : this._internal(
          (ref) => fetchNews(
            ref as FetchNewsRef,
            token,
          ),
          from: fetchNewsProvider,
          name: r'fetchNewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchNewsHash,
          dependencies: FetchNewsFamily._dependencies,
          allTransitiveDependencies: FetchNewsFamily._allTransitiveDependencies,
          token: token,
        );

  FetchNewsProvider._internal(
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
    FutureOr<List<News>> Function(FetchNewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchNewsProvider._internal(
        (ref) => create(ref as FetchNewsRef),
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
  AutoDisposeFutureProviderElement<List<News>> createElement() {
    return _FetchNewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchNewsProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchNewsRef on AutoDisposeFutureProviderRef<List<News>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchNewsProviderElement
    extends AutoDisposeFutureProviderElement<List<News>> with FetchNewsRef {
  _FetchNewsProviderElement(super.provider);

  @override
  String get token => (origin as FetchNewsProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

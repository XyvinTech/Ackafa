// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchFeedsHash() => r'49d2c58fb528452bdd83e9765d868b010982a8b1';

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
  FetchFeedsProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return FetchFeedsProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchFeedsProvider getProviderOverride(
    covariant FetchFeedsProvider provider,
  ) {
    return call(
      pageNo: provider.pageNo,
      limit: provider.limit,
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
  FetchFeedsProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchFeeds(
            ref as FetchFeedsRef,
            pageNo: pageNo,
            limit: limit,
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
          pageNo: pageNo,
          limit: limit,
        );

  FetchFeedsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pageNo,
    required this.limit,
  }) : super.internal();

  final int pageNo;
  final int limit;

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
        pageNo: pageNo,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Feed>> createElement() {
    return _FetchFeedsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchFeedsProvider &&
        other.pageNo == pageNo &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pageNo.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchFeedsRef on AutoDisposeFutureProviderRef<List<Feed>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchFeedsProviderElement
    extends AutoDisposeFutureProviderElement<List<Feed>> with FetchFeedsRef {
  _FetchFeedsProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchFeedsProvider).pageNo;
  @override
  int get limit => (origin as FetchFeedsProvider).limit;
}

String _$fetchMyPostsHash() => r'f85332fa59731a561f7ea0a47856631fcd8cb578';

/// See also [fetchMyPosts].
@ProviderFor(fetchMyPosts)
final fetchMyPostsProvider = AutoDisposeFutureProvider<List<Feed>>.internal(
  fetchMyPosts,
  name: r'fetchMyPostsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fetchMyPostsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchMyPostsRef = AutoDisposeFutureProviderRef<List<Feed>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

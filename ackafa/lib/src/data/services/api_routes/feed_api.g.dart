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

String _$fetchAdminPublishedFeedsHash() =>
    r'dfcfc50bde5efa67b1c3220b459d3418320b85cd';

/// See also [fetchAdminPublishedFeeds].
@ProviderFor(fetchAdminPublishedFeeds)
const fetchAdminPublishedFeedsProvider = FetchAdminPublishedFeedsFamily();

/// See also [fetchAdminPublishedFeeds].
class FetchAdminPublishedFeedsFamily extends Family<AsyncValue<List<Feed>>> {
  /// See also [fetchAdminPublishedFeeds].
  const FetchAdminPublishedFeedsFamily();

  /// See also [fetchAdminPublishedFeeds].
  FetchAdminPublishedFeedsProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return FetchAdminPublishedFeedsProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchAdminPublishedFeedsProvider getProviderOverride(
    covariant FetchAdminPublishedFeedsProvider provider,
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
  String? get name => r'fetchAdminPublishedFeedsProvider';
}

/// See also [fetchAdminPublishedFeeds].
class FetchAdminPublishedFeedsProvider
    extends AutoDisposeFutureProvider<List<Feed>> {
  /// See also [fetchAdminPublishedFeeds].
  FetchAdminPublishedFeedsProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchAdminPublishedFeeds(
            ref as FetchAdminPublishedFeedsRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: fetchAdminPublishedFeedsProvider,
          name: r'fetchAdminPublishedFeedsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAdminPublishedFeedsHash,
          dependencies: FetchAdminPublishedFeedsFamily._dependencies,
          allTransitiveDependencies:
              FetchAdminPublishedFeedsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  FetchAdminPublishedFeedsProvider._internal(
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
    FutureOr<List<Feed>> Function(FetchAdminPublishedFeedsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAdminPublishedFeedsProvider._internal(
        (ref) => create(ref as FetchAdminPublishedFeedsRef),
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
    return _FetchAdminPublishedFeedsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAdminPublishedFeedsProvider &&
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

mixin FetchAdminPublishedFeedsRef on AutoDisposeFutureProviderRef<List<Feed>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchAdminPublishedFeedsProviderElement
    extends AutoDisposeFutureProviderElement<List<Feed>>
    with FetchAdminPublishedFeedsRef {
  _FetchAdminPublishedFeedsProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchAdminPublishedFeedsProvider).pageNo;
  @override
  int get limit => (origin as FetchAdminPublishedFeedsProvider).limit;
}

String _$fetchAdminFeedsHash() => r'0e7a688adf8a0ec0b689ed8be67557a64f7d52f6';

/// See also [fetchAdminFeeds].
@ProviderFor(fetchAdminFeeds)
const fetchAdminFeedsProvider = FetchAdminFeedsFamily();

/// See also [fetchAdminFeeds].
class FetchAdminFeedsFamily extends Family<AsyncValue<List<Feed>>> {
  /// See also [fetchAdminFeeds].
  const FetchAdminFeedsFamily();

  /// See also [fetchAdminFeeds].
  FetchAdminFeedsProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return FetchAdminFeedsProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchAdminFeedsProvider getProviderOverride(
    covariant FetchAdminFeedsProvider provider,
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
  String? get name => r'fetchAdminFeedsProvider';
}

/// See also [fetchAdminFeeds].
class FetchAdminFeedsProvider extends AutoDisposeFutureProvider<List<Feed>> {
  /// See also [fetchAdminFeeds].
  FetchAdminFeedsProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchAdminFeeds(
            ref as FetchAdminFeedsRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: fetchAdminFeedsProvider,
          name: r'fetchAdminFeedsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAdminFeedsHash,
          dependencies: FetchAdminFeedsFamily._dependencies,
          allTransitiveDependencies:
              FetchAdminFeedsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  FetchAdminFeedsProvider._internal(
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
    FutureOr<List<Feed>> Function(FetchAdminFeedsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAdminFeedsProvider._internal(
        (ref) => create(ref as FetchAdminFeedsRef),
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
    return _FetchAdminFeedsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAdminFeedsProvider &&
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

mixin FetchAdminFeedsRef on AutoDisposeFutureProviderRef<List<Feed>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchAdminFeedsProviderElement
    extends AutoDisposeFutureProviderElement<List<Feed>>
    with FetchAdminFeedsRef {
  _FetchAdminFeedsProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchAdminFeedsProvider).pageNo;
  @override
  int get limit => (origin as FetchAdminFeedsProvider).limit;
}

String _$fetchAdminRejectedFeedsHash() =>
    r'dd3557ff5724ce5fd616107ce9fd093551953bc1';

/// See also [fetchAdminRejectedFeeds].
@ProviderFor(fetchAdminRejectedFeeds)
const fetchAdminRejectedFeedsProvider = FetchAdminRejectedFeedsFamily();

/// See also [fetchAdminRejectedFeeds].
class FetchAdminRejectedFeedsFamily extends Family<AsyncValue<List<Feed>>> {
  /// See also [fetchAdminRejectedFeeds].
  const FetchAdminRejectedFeedsFamily();

  /// See also [fetchAdminRejectedFeeds].
  FetchAdminRejectedFeedsProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return FetchAdminRejectedFeedsProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchAdminRejectedFeedsProvider getProviderOverride(
    covariant FetchAdminRejectedFeedsProvider provider,
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
  String? get name => r'fetchAdminRejectedFeedsProvider';
}

/// See also [fetchAdminRejectedFeeds].
class FetchAdminRejectedFeedsProvider
    extends AutoDisposeFutureProvider<List<Feed>> {
  /// See also [fetchAdminRejectedFeeds].
  FetchAdminRejectedFeedsProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchAdminRejectedFeeds(
            ref as FetchAdminRejectedFeedsRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: fetchAdminRejectedFeedsProvider,
          name: r'fetchAdminRejectedFeedsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAdminRejectedFeedsHash,
          dependencies: FetchAdminRejectedFeedsFamily._dependencies,
          allTransitiveDependencies:
              FetchAdminRejectedFeedsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  FetchAdminRejectedFeedsProvider._internal(
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
    FutureOr<List<Feed>> Function(FetchAdminRejectedFeedsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAdminRejectedFeedsProvider._internal(
        (ref) => create(ref as FetchAdminRejectedFeedsRef),
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
    return _FetchAdminRejectedFeedsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAdminRejectedFeedsProvider &&
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

mixin FetchAdminRejectedFeedsRef on AutoDisposeFutureProviderRef<List<Feed>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchAdminRejectedFeedsProviderElement
    extends AutoDisposeFutureProviderElement<List<Feed>>
    with FetchAdminRejectedFeedsRef {
  _FetchAdminRejectedFeedsProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchAdminRejectedFeedsProvider).pageNo;
  @override
  int get limit => (origin as FetchAdminRejectedFeedsProvider).limit;
}

String _$fetchMyPostsHash() => r'238226ab610fd7eadf17221e03b773b1cf9a8683';

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

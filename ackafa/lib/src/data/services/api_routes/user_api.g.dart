// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchUserDetailsHash() => r'c1741d24e9b37bbf9e00a340b52f0d35297ab9bc';

/// See also [fetchUserDetails].
@ProviderFor(fetchUserDetails)
final fetchUserDetailsProvider = AutoDisposeFutureProvider<UserModel>.internal(
  fetchUserDetails,
  name: r'fetchUserDetailsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchUserDetailsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchUserDetailsRef = AutoDisposeFutureProviderRef<UserModel>;
String _$fetchUsersHash() => r'a625743c8b215c1cf89767be106cd0d11eaadf31';

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

/// See also [fetchUsers].
@ProviderFor(fetchUsers)
const fetchUsersProvider = FetchUsersFamily();

/// See also [fetchUsers].
class FetchUsersFamily extends Family<AsyncValue<List<UserModel>>> {
  /// See also [fetchUsers].
  const FetchUsersFamily();

  /// See also [fetchUsers].
  FetchUsersProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return FetchUsersProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchUsersProvider getProviderOverride(
    covariant FetchUsersProvider provider,
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
  String? get name => r'fetchUsersProvider';
}

/// See also [fetchUsers].
class FetchUsersProvider extends AutoDisposeFutureProvider<List<UserModel>> {
  /// See also [fetchUsers].
  FetchUsersProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchUsers(
            ref as FetchUsersRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: fetchUsersProvider,
          name: r'fetchUsersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUsersHash,
          dependencies: FetchUsersFamily._dependencies,
          allTransitiveDependencies:
              FetchUsersFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  FetchUsersProvider._internal(
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
    FutureOr<List<UserModel>> Function(FetchUsersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUsersProvider._internal(
        (ref) => create(ref as FetchUsersRef),
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
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _FetchUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUsersProvider &&
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

mixin FetchUsersRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with FetchUsersRef {
  _FetchUsersProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchUsersProvider).pageNo;
  @override
  int get limit => (origin as FetchUsersProvider).limit;
}

String _$fetchUserByIdHash() => r'6f107963db5a52e120576de6b88423940c4c65f7';

/// See also [fetchUserById].
@ProviderFor(fetchUserById)
const fetchUserByIdProvider = FetchUserByIdFamily();

/// See also [fetchUserById].
class FetchUserByIdFamily extends Family<AsyncValue<UserModel>> {
  /// See also [fetchUserById].
  const FetchUserByIdFamily();

  /// See also [fetchUserById].
  FetchUserByIdProvider call(
    String id,
  ) {
    return FetchUserByIdProvider(
      id,
    );
  }

  @override
  FetchUserByIdProvider getProviderOverride(
    covariant FetchUserByIdProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'fetchUserByIdProvider';
}

/// See also [fetchUserById].
class FetchUserByIdProvider extends AutoDisposeFutureProvider<UserModel> {
  /// See also [fetchUserById].
  FetchUserByIdProvider(
    String id,
  ) : this._internal(
          (ref) => fetchUserById(
            ref as FetchUserByIdRef,
            id,
          ),
          from: fetchUserByIdProvider,
          name: r'fetchUserByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUserByIdHash,
          dependencies: FetchUserByIdFamily._dependencies,
          allTransitiveDependencies:
              FetchUserByIdFamily._allTransitiveDependencies,
          id: id,
        );

  FetchUserByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<UserModel> Function(FetchUserByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUserByIdProvider._internal(
        (ref) => create(ref as FetchUserByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<UserModel> createElement() {
    return _FetchUserByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserByIdProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchUserByIdRef on AutoDisposeFutureProviderRef<UserModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _FetchUserByIdProviderElement
    extends AutoDisposeFutureProviderElement<UserModel> with FetchUserByIdRef {
  _FetchUserByIdProviderElement(super.provider);

  @override
  String get id => (origin as FetchUserByIdProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

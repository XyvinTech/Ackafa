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
String _$fetchUsersHash() => r'aa9fab01523c5489c67302b32c8082ca0d38ea09';

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
  FetchUsersProvider call(
    String token,
  ) {
    return FetchUsersProvider(
      token,
    );
  }

  @override
  FetchUsersProvider getProviderOverride(
    covariant FetchUsersProvider provider,
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
  String? get name => r'fetchUsersProvider';
}

/// See also [fetchUsers].
class FetchUsersProvider extends AutoDisposeFutureProvider<List<UserModel>> {
  /// See also [fetchUsers].
  FetchUsersProvider(
    String token,
  ) : this._internal(
          (ref) => fetchUsers(
            ref as FetchUsersRef,
            token,
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
          token: token,
        );

  FetchUsersProvider._internal(
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
        token: token,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<UserModel>> createElement() {
    return _FetchUsersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUsersProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchUsersRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchUsersProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with FetchUsersRef {
  _FetchUsersProviderElement(super.provider);

  @override
  String get token => (origin as FetchUsersProvider).token;
}

String _$fetchUserRequirementsHash() =>
    r'70a98749b03496377a7b52cf7796680eed1ce6ea';

/// See also [fetchUserRequirements].
@ProviderFor(fetchUserRequirements)
const fetchUserRequirementsProvider = FetchUserRequirementsFamily();

/// See also [fetchUserRequirements].
class FetchUserRequirementsFamily
    extends Family<AsyncValue<List<UserRequirementModel>>> {
  /// See also [fetchUserRequirements].
  const FetchUserRequirementsFamily();

  /// See also [fetchUserRequirements].
  FetchUserRequirementsProvider call(
    String token,
  ) {
    return FetchUserRequirementsProvider(
      token,
    );
  }

  @override
  FetchUserRequirementsProvider getProviderOverride(
    covariant FetchUserRequirementsProvider provider,
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
  String? get name => r'fetchUserRequirementsProvider';
}

/// See also [fetchUserRequirements].
class FetchUserRequirementsProvider
    extends AutoDisposeFutureProvider<List<UserRequirementModel>> {
  /// See also [fetchUserRequirements].
  FetchUserRequirementsProvider(
    String token,
  ) : this._internal(
          (ref) => fetchUserRequirements(
            ref as FetchUserRequirementsRef,
            token,
          ),
          from: fetchUserRequirementsProvider,
          name: r'fetchUserRequirementsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUserRequirementsHash,
          dependencies: FetchUserRequirementsFamily._dependencies,
          allTransitiveDependencies:
              FetchUserRequirementsFamily._allTransitiveDependencies,
          token: token,
        );

  FetchUserRequirementsProvider._internal(
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
    FutureOr<List<UserRequirementModel>> Function(
            FetchUserRequirementsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUserRequirementsProvider._internal(
        (ref) => create(ref as FetchUserRequirementsRef),
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
  AutoDisposeFutureProviderElement<List<UserRequirementModel>> createElement() {
    return _FetchUserRequirementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUserRequirementsProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchUserRequirementsRef
    on AutoDisposeFutureProviderRef<List<UserRequirementModel>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchUserRequirementsProviderElement
    extends AutoDisposeFutureProviderElement<List<UserRequirementModel>>
    with FetchUserRequirementsRef {
  _FetchUserRequirementsProviderElement(super.provider);

  @override
  String get token => (origin as FetchUserRequirementsProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchUnreadNotificationsHash() =>
    r'5df6327b99b49ae369f12142b00ea8286b1905e0';

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

/// See also [fetchUnreadNotifications].
@ProviderFor(fetchUnreadNotifications)
const fetchUnreadNotificationsProvider = FetchUnreadNotificationsFamily();

/// See also [fetchUnreadNotifications].
class FetchUnreadNotificationsFamily
    extends Family<AsyncValue<List<NotificationModel>>> {
  /// See also [fetchUnreadNotifications].
  const FetchUnreadNotificationsFamily();

  /// See also [fetchUnreadNotifications].
  FetchUnreadNotificationsProvider call(
    String token,
  ) {
    return FetchUnreadNotificationsProvider(
      token,
    );
  }

  @override
  FetchUnreadNotificationsProvider getProviderOverride(
    covariant FetchUnreadNotificationsProvider provider,
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
  String? get name => r'fetchUnreadNotificationsProvider';
}

/// See also [fetchUnreadNotifications].
class FetchUnreadNotificationsProvider
    extends AutoDisposeFutureProvider<List<NotificationModel>> {
  /// See also [fetchUnreadNotifications].
  FetchUnreadNotificationsProvider(
    String token,
  ) : this._internal(
          (ref) => fetchUnreadNotifications(
            ref as FetchUnreadNotificationsRef,
            token,
          ),
          from: fetchUnreadNotificationsProvider,
          name: r'fetchUnreadNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchUnreadNotificationsHash,
          dependencies: FetchUnreadNotificationsFamily._dependencies,
          allTransitiveDependencies:
              FetchUnreadNotificationsFamily._allTransitiveDependencies,
          token: token,
        );

  FetchUnreadNotificationsProvider._internal(
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
    FutureOr<List<NotificationModel>> Function(
            FetchUnreadNotificationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchUnreadNotificationsProvider._internal(
        (ref) => create(ref as FetchUnreadNotificationsRef),
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
  AutoDisposeFutureProviderElement<List<NotificationModel>> createElement() {
    return _FetchUnreadNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchUnreadNotificationsProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchUnreadNotificationsRef
    on AutoDisposeFutureProviderRef<List<NotificationModel>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchUnreadNotificationsProviderElement
    extends AutoDisposeFutureProviderElement<List<NotificationModel>>
    with FetchUnreadNotificationsRef {
  _FetchUnreadNotificationsProviderElement(super.provider);

  @override
  String get token => (origin as FetchUnreadNotificationsProvider).token;
}

String _$fetchreadNotificationsHash() =>
    r'c1f355d11e44c1f4bd9dbaede6fc338315085ca7';

/// See also [fetchreadNotifications].
@ProviderFor(fetchreadNotifications)
const fetchreadNotificationsProvider = FetchreadNotificationsFamily();

/// See also [fetchreadNotifications].
class FetchreadNotificationsFamily
    extends Family<AsyncValue<List<NotificationModel>>> {
  /// See also [fetchreadNotifications].
  const FetchreadNotificationsFamily();

  /// See also [fetchreadNotifications].
  FetchreadNotificationsProvider call(
    String token,
  ) {
    return FetchreadNotificationsProvider(
      token,
    );
  }

  @override
  FetchreadNotificationsProvider getProviderOverride(
    covariant FetchreadNotificationsProvider provider,
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
  String? get name => r'fetchreadNotificationsProvider';
}

/// See also [fetchreadNotifications].
class FetchreadNotificationsProvider
    extends AutoDisposeFutureProvider<List<NotificationModel>> {
  /// See also [fetchreadNotifications].
  FetchreadNotificationsProvider(
    String token,
  ) : this._internal(
          (ref) => fetchreadNotifications(
            ref as FetchreadNotificationsRef,
            token,
          ),
          from: fetchreadNotificationsProvider,
          name: r'fetchreadNotificationsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchreadNotificationsHash,
          dependencies: FetchreadNotificationsFamily._dependencies,
          allTransitiveDependencies:
              FetchreadNotificationsFamily._allTransitiveDependencies,
          token: token,
        );

  FetchreadNotificationsProvider._internal(
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
    FutureOr<List<NotificationModel>> Function(
            FetchreadNotificationsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchreadNotificationsProvider._internal(
        (ref) => create(ref as FetchreadNotificationsRef),
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
  AutoDisposeFutureProviderElement<List<NotificationModel>> createElement() {
    return _FetchreadNotificationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchreadNotificationsProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchreadNotificationsRef
    on AutoDisposeFutureProviderRef<List<NotificationModel>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchreadNotificationsProviderElement
    extends AutoDisposeFutureProviderElement<List<NotificationModel>>
    with FetchreadNotificationsRef {
  _FetchreadNotificationsProviderElement(super.provider);

  @override
  String get token => (origin as FetchreadNotificationsProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

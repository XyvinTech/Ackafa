// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchTransactionsHash() => r'533479805bec42269ff7f3172b0a05e5dbb86b75';

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

/// See also [fetchTransactions].
@ProviderFor(fetchTransactions)
const fetchTransactionsProvider = FetchTransactionsFamily();

/// See also [fetchTransactions].
class FetchTransactionsFamily extends Family<AsyncValue<List<Transaction>>> {
  /// See also [fetchTransactions].
  const FetchTransactionsFamily();

  /// See also [fetchTransactions].
  FetchTransactionsProvider call(
    String token,
  ) {
    return FetchTransactionsProvider(
      token,
    );
  }

  @override
  FetchTransactionsProvider getProviderOverride(
    covariant FetchTransactionsProvider provider,
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
  String? get name => r'fetchTransactionsProvider';
}

/// See also [fetchTransactions].
class FetchTransactionsProvider
    extends AutoDisposeFutureProvider<List<Transaction>> {
  /// See also [fetchTransactions].
  FetchTransactionsProvider(
    String token,
  ) : this._internal(
          (ref) => fetchTransactions(
            ref as FetchTransactionsRef,
            token,
          ),
          from: fetchTransactionsProvider,
          name: r'fetchTransactionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchTransactionsHash,
          dependencies: FetchTransactionsFamily._dependencies,
          allTransitiveDependencies:
              FetchTransactionsFamily._allTransitiveDependencies,
          token: token,
        );

  FetchTransactionsProvider._internal(
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
    FutureOr<List<Transaction>> Function(FetchTransactionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchTransactionsProvider._internal(
        (ref) => create(ref as FetchTransactionsRef),
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
  AutoDisposeFutureProviderElement<List<Transaction>> createElement() {
    return _FetchTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchTransactionsProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchTransactionsRef on AutoDisposeFutureProviderRef<List<Transaction>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Transaction>>
    with FetchTransactionsRef {
  _FetchTransactionsProviderElement(super.provider);

  @override
  String get token => (origin as FetchTransactionsProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

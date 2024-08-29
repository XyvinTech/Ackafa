// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchChatThreadHash() => r'5e1f49b40fd4887ba4fbaadd91f395ef23658a20';

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

/// See also [fetchChatThread].
@ProviderFor(fetchChatThread)
const fetchChatThreadProvider = FetchChatThreadFamily();

/// See also [fetchChatThread].
class FetchChatThreadFamily extends Family<AsyncValue<List<ChatModel>>> {
  /// See also [fetchChatThread].
  const FetchChatThreadFamily();

  /// See also [fetchChatThread].
  FetchChatThreadProvider call(
    String token,
  ) {
    return FetchChatThreadProvider(
      token,
    );
  }

  @override
  FetchChatThreadProvider getProviderOverride(
    covariant FetchChatThreadProvider provider,
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
  String? get name => r'fetchChatThreadProvider';
}

/// See also [fetchChatThread].
class FetchChatThreadProvider
    extends AutoDisposeFutureProvider<List<ChatModel>> {
  /// See also [fetchChatThread].
  FetchChatThreadProvider(
    String token,
  ) : this._internal(
          (ref) => fetchChatThread(
            ref as FetchChatThreadRef,
            token,
          ),
          from: fetchChatThreadProvider,
          name: r'fetchChatThreadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchChatThreadHash,
          dependencies: FetchChatThreadFamily._dependencies,
          allTransitiveDependencies:
              FetchChatThreadFamily._allTransitiveDependencies,
          token: token,
        );

  FetchChatThreadProvider._internal(
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
    FutureOr<List<ChatModel>> Function(FetchChatThreadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchChatThreadProvider._internal(
        (ref) => create(ref as FetchChatThreadRef),
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
  AutoDisposeFutureProviderElement<List<ChatModel>> createElement() {
    return _FetchChatThreadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchChatThreadProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchChatThreadRef on AutoDisposeFutureProviderRef<List<ChatModel>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchChatThreadProviderElement
    extends AutoDisposeFutureProviderElement<List<ChatModel>>
    with FetchChatThreadRef {
  _FetchChatThreadProviderElement(super.provider);

  @override
  String get token => (origin as FetchChatThreadProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

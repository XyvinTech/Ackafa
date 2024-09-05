// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchEventsHash() => r'97016089f01fd2745a12019ad887e6faabe90c51';

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

/// See also [fetchEvents].
@ProviderFor(fetchEvents)
const fetchEventsProvider = FetchEventsFamily();

/// See also [fetchEvents].
class FetchEventsFamily extends Family<AsyncValue<List<Event>>> {
  /// See also [fetchEvents].
  const FetchEventsFamily();

  /// See also [fetchEvents].
  FetchEventsProvider call(
    String token,
  ) {
    return FetchEventsProvider(
      token,
    );
  }

  @override
  FetchEventsProvider getProviderOverride(
    covariant FetchEventsProvider provider,
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
  String? get name => r'fetchEventsProvider';
}

/// See also [fetchEvents].
class FetchEventsProvider extends AutoDisposeFutureProvider<List<Event>> {
  /// See also [fetchEvents].
  FetchEventsProvider(
    String token,
  ) : this._internal(
          (ref) => fetchEvents(
            ref as FetchEventsRef,
            token,
          ),
          from: fetchEventsProvider,
          name: r'fetchEventsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchEventsHash,
          dependencies: FetchEventsFamily._dependencies,
          allTransitiveDependencies:
              FetchEventsFamily._allTransitiveDependencies,
          token: token,
        );

  FetchEventsProvider._internal(
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
    FutureOr<List<Event>> Function(FetchEventsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchEventsProvider._internal(
        (ref) => create(ref as FetchEventsRef),
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
  AutoDisposeFutureProviderElement<List<Event>> createElement() {
    return _FetchEventsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchEventsProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchEventsRef on AutoDisposeFutureProviderRef<List<Event>> {
  /// The parameter `token` of this provider.
  String get token;
}

class _FetchEventsProviderElement
    extends AutoDisposeFutureProviderElement<List<Event>> with FetchEventsRef {
  _FetchEventsProviderElement(super.provider);

  @override
  String get token => (origin as FetchEventsProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

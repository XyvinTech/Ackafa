// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchHallBookingsHash() => r'0a2213ce06bcbd0dcd2ee5d6cd10957b2de3dd07';

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

/// See also [fetchHallBookings].
@ProviderFor(fetchHallBookings)
const fetchHallBookingsProvider = FetchHallBookingsFamily();

/// See also [fetchHallBookings].
class FetchHallBookingsFamily extends Family<AsyncValue<List<HallBooking>>> {
  /// See also [fetchHallBookings].
  const FetchHallBookingsFamily();

  /// See also [fetchHallBookings].
  FetchHallBookingsProvider call(
    String date,
  ) {
    return FetchHallBookingsProvider(
      date,
    );
  }

  @override
  FetchHallBookingsProvider getProviderOverride(
    covariant FetchHallBookingsProvider provider,
  ) {
    return call(
      provider.date,
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
  String? get name => r'fetchHallBookingsProvider';
}

/// See also [fetchHallBookings].
class FetchHallBookingsProvider
    extends AutoDisposeFutureProvider<List<HallBooking>> {
  /// See also [fetchHallBookings].
  FetchHallBookingsProvider(
    String date,
  ) : this._internal(
          (ref) => fetchHallBookings(
            ref as FetchHallBookingsRef,
            date,
          ),
          from: fetchHallBookingsProvider,
          name: r'fetchHallBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchHallBookingsHash,
          dependencies: FetchHallBookingsFamily._dependencies,
          allTransitiveDependencies:
              FetchHallBookingsFamily._allTransitiveDependencies,
          date: date,
        );

  FetchHallBookingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String date;

  @override
  Override overrideWith(
    FutureOr<List<HallBooking>> Function(FetchHallBookingsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchHallBookingsProvider._internal(
        (ref) => create(ref as FetchHallBookingsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<HallBooking>> createElement() {
    return _FetchHallBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchHallBookingsProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchHallBookingsRef on AutoDisposeFutureProviderRef<List<HallBooking>> {
  /// The parameter `date` of this provider.
  String get date;
}

class _FetchHallBookingsProviderElement
    extends AutoDisposeFutureProviderElement<List<HallBooking>>
    with FetchHallBookingsRef {
  _FetchHallBookingsProviderElement(super.provider);

  @override
  String get date => (origin as FetchHallBookingsProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

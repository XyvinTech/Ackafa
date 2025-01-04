// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchHallBookingsHash() => r'e79ea35b917bcd9440bb31bf0beb311d2529f7b6';

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
    String hallId,
  ) {
    return FetchHallBookingsProvider(
      date,
      hallId,
    );
  }

  @override
  FetchHallBookingsProvider getProviderOverride(
    covariant FetchHallBookingsProvider provider,
  ) {
    return call(
      provider.date,
      provider.hallId,
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
    String hallId,
  ) : this._internal(
          (ref) => fetchHallBookings(
            ref as FetchHallBookingsRef,
            date,
            hallId,
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
          hallId: hallId,
        );

  FetchHallBookingsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
    required this.hallId,
  }) : super.internal();

  final String date;
  final String hallId;

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
        hallId: hallId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<HallBooking>> createElement() {
    return _FetchHallBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchHallBookingsProvider &&
        other.date == date &&
        other.hallId == hallId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);
    hash = _SystemHash.combine(hash, hallId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchHallBookingsRef on AutoDisposeFutureProviderRef<List<HallBooking>> {
  /// The parameter `date` of this provider.
  String get date;

  /// The parameter `hallId` of this provider.
  String get hallId;
}

class _FetchHallBookingsProviderElement
    extends AutoDisposeFutureProviderElement<List<HallBooking>>
    with FetchHallBookingsRef {
  _FetchHallBookingsProviderElement(super.provider);

  @override
  String get date => (origin as FetchHallBookingsProvider).date;
  @override
  String get hallId => (origin as FetchHallBookingsProvider).hallId;
}

String _$fetchHallsHash() => r'078eab5e6101293aa51f3c8c6afa57f0b0097b16';

/// See also [fetchHalls].
@ProviderFor(fetchHalls)
final fetchHallsProvider = AutoDisposeFutureProvider<List<Hall>>.internal(
  fetchHalls,
  name: r'fetchHallsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$fetchHallsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchHallsRef = AutoDisposeFutureProviderRef<List<Hall>>;
String _$fetchMyHallBookingsHash() =>
    r'0056f213824e9775326fb3935f2233f0c420d343';

/// See also [fetchMyHallBookings].
@ProviderFor(fetchMyHallBookings)
const fetchMyHallBookingsProvider = FetchMyHallBookingsFamily();

/// See also [fetchMyHallBookings].
class FetchMyHallBookingsFamily extends Family<AsyncValue<List<HallBooking>>> {
  /// See also [fetchMyHallBookings].
  const FetchMyHallBookingsFamily();

  /// See also [fetchMyHallBookings].
  FetchMyHallBookingsProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return FetchMyHallBookingsProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchMyHallBookingsProvider getProviderOverride(
    covariant FetchMyHallBookingsProvider provider,
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
  String? get name => r'fetchMyHallBookingsProvider';
}

/// See also [fetchMyHallBookings].
class FetchMyHallBookingsProvider
    extends AutoDisposeFutureProvider<List<HallBooking>> {
  /// See also [fetchMyHallBookings].
  FetchMyHallBookingsProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchMyHallBookings(
            ref as FetchMyHallBookingsRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: fetchMyHallBookingsProvider,
          name: r'fetchMyHallBookingsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchMyHallBookingsHash,
          dependencies: FetchMyHallBookingsFamily._dependencies,
          allTransitiveDependencies:
              FetchMyHallBookingsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  FetchMyHallBookingsProvider._internal(
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
    FutureOr<List<HallBooking>> Function(FetchMyHallBookingsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchMyHallBookingsProvider._internal(
        (ref) => create(ref as FetchMyHallBookingsRef),
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
  AutoDisposeFutureProviderElement<List<HallBooking>> createElement() {
    return _FetchMyHallBookingsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchMyHallBookingsProvider &&
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchMyHallBookingsRef
    on AutoDisposeFutureProviderRef<List<HallBooking>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchMyHallBookingsProviderElement
    extends AutoDisposeFutureProviderElement<List<HallBooking>>
    with FetchMyHallBookingsRef {
  _FetchMyHallBookingsProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchMyHallBookingsProvider).pageNo;
  @override
  int get limit => (origin as FetchMyHallBookingsProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

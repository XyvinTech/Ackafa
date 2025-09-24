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

String _$fetchBookedDatesHash() => r'4a25b0dec032a4665e4a641362bb7b5080cec986';

/// See also [fetchBookedDates].
@ProviderFor(fetchBookedDates)
const fetchBookedDatesProvider = FetchBookedDatesFamily();

/// See also [fetchBookedDates].
class FetchBookedDatesFamily extends Family<AsyncValue<List<DateTime?>>> {
  /// See also [fetchBookedDates].
  const FetchBookedDatesFamily();

  /// See also [fetchBookedDates].
  FetchBookedDatesProvider call(
    String month,
  ) {
    return FetchBookedDatesProvider(
      month,
    );
  }

  @override
  FetchBookedDatesProvider getProviderOverride(
    covariant FetchBookedDatesProvider provider,
  ) {
    return call(
      provider.month,
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
  String? get name => r'fetchBookedDatesProvider';
}

/// See also [fetchBookedDates].
class FetchBookedDatesProvider
    extends AutoDisposeFutureProvider<List<DateTime?>> {
  /// See also [fetchBookedDates].
  FetchBookedDatesProvider(
    String month,
  ) : this._internal(
          (ref) => fetchBookedDates(
            ref as FetchBookedDatesRef,
            month,
          ),
          from: fetchBookedDatesProvider,
          name: r'fetchBookedDatesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchBookedDatesHash,
          dependencies: FetchBookedDatesFamily._dependencies,
          allTransitiveDependencies:
              FetchBookedDatesFamily._allTransitiveDependencies,
          month: month,
        );

  FetchBookedDatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.month,
  }) : super.internal();

  final String month;

  @override
  Override overrideWith(
    FutureOr<List<DateTime?>> Function(FetchBookedDatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchBookedDatesProvider._internal(
        (ref) => create(ref as FetchBookedDatesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<DateTime?>> createElement() {
    return _FetchBookedDatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchBookedDatesProvider && other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FetchBookedDatesRef on AutoDisposeFutureProviderRef<List<DateTime?>> {
  /// The parameter `month` of this provider.
  String get month;
}

class _FetchBookedDatesProviderElement
    extends AutoDisposeFutureProviderElement<List<DateTime?>>
    with FetchBookedDatesRef {
  _FetchBookedDatesProviderElement(super.provider);

  @override
  String get month => (origin as FetchBookedDatesProvider).month;
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

String _$fetchHallTimesHash() => r'a6922294450912e5dae84ae2e58347487fb81f69';

/// See also [fetchHallTimes].
@ProviderFor(fetchHallTimes)
final fetchHallTimesProvider =
    AutoDisposeFutureProvider<List<AvailableTimeModel>>.internal(
  fetchHallTimes,
  name: r'fetchHallTimesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fetchHallTimesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FetchHallTimesRef
    = AutoDisposeFutureProviderRef<List<AvailableTimeModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

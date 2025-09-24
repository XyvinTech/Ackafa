// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'approval_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchApprovalsHash() => r'27e3725264f40a90d877798c2c34853bfed0946f';

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

/// See also [fetchApprovals].
@ProviderFor(fetchApprovals)
const fetchApprovalsProvider = FetchApprovalsFamily();

/// See also [fetchApprovals].
class FetchApprovalsFamily extends Family<AsyncValue<List<UserModel>>> {
  /// See also [fetchApprovals].
  const FetchApprovalsFamily();

  /// See also [fetchApprovals].
  FetchApprovalsProvider call({
    int pageNo = 1,
    int limit = 10,
  }) {
    return FetchApprovalsProvider(
      pageNo: pageNo,
      limit: limit,
    );
  }

  @override
  FetchApprovalsProvider getProviderOverride(
    covariant FetchApprovalsProvider provider,
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
  String? get name => r'fetchApprovalsProvider';
}

/// See also [fetchApprovals].
class FetchApprovalsProvider
    extends AutoDisposeFutureProvider<List<UserModel>> {
  /// See also [fetchApprovals].
  FetchApprovalsProvider({
    int pageNo = 1,
    int limit = 10,
  }) : this._internal(
          (ref) => fetchApprovals(
            ref as FetchApprovalsRef,
            pageNo: pageNo,
            limit: limit,
          ),
          from: fetchApprovalsProvider,
          name: r'fetchApprovalsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchApprovalsHash,
          dependencies: FetchApprovalsFamily._dependencies,
          allTransitiveDependencies:
              FetchApprovalsFamily._allTransitiveDependencies,
          pageNo: pageNo,
          limit: limit,
        );

  FetchApprovalsProvider._internal(
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
    FutureOr<List<UserModel>> Function(FetchApprovalsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchApprovalsProvider._internal(
        (ref) => create(ref as FetchApprovalsRef),
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
    return _FetchApprovalsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchApprovalsProvider &&
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

mixin FetchApprovalsRef on AutoDisposeFutureProviderRef<List<UserModel>> {
  /// The parameter `pageNo` of this provider.
  int get pageNo;

  /// The parameter `limit` of this provider.
  int get limit;
}

class _FetchApprovalsProviderElement
    extends AutoDisposeFutureProviderElement<List<UserModel>>
    with FetchApprovalsRef {
  _FetchApprovalsProviderElement(super.provider);

  @override
  int get pageNo => (origin as FetchApprovalsProvider).pageNo;
  @override
  int get limit => (origin as FetchApprovalsProvider).limit;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

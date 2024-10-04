// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getGroupListHash() => r'7415982095e2f03f80451324203adbb097142cd1';

/// See also [getGroupList].
@ProviderFor(getGroupList)
final getGroupListProvider =
    AutoDisposeFutureProvider<List<GroupModel>>.internal(
  getGroupList,
  name: r'getGroupListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getGroupListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetGroupListRef = AutoDisposeFutureProviderRef<List<GroupModel>>;
String _$getGroupMembersHash() => r'08a2b5267326ad66df9fb6856870dbfa5689046a';

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

/// See also [getGroupMembers].
@ProviderFor(getGroupMembers)
const getGroupMembersProvider = GetGroupMembersFamily();

/// See also [getGroupMembers].
class GetGroupMembersFamily extends Family<AsyncValue<List<GroupMember>>> {
  /// See also [getGroupMembers].
  const GetGroupMembersFamily();

  /// See also [getGroupMembers].
  GetGroupMembersProvider call({
    required String groupId,
  }) {
    return GetGroupMembersProvider(
      groupId: groupId,
    );
  }

  @override
  GetGroupMembersProvider getProviderOverride(
    covariant GetGroupMembersProvider provider,
  ) {
    return call(
      groupId: provider.groupId,
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
  String? get name => r'getGroupMembersProvider';
}

/// See also [getGroupMembers].
class GetGroupMembersProvider
    extends AutoDisposeFutureProvider<List<GroupMember>> {
  /// See also [getGroupMembers].
  GetGroupMembersProvider({
    required String groupId,
  }) : this._internal(
          (ref) => getGroupMembers(
            ref as GetGroupMembersRef,
            groupId: groupId,
          ),
          from: getGroupMembersProvider,
          name: r'getGroupMembersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getGroupMembersHash,
          dependencies: GetGroupMembersFamily._dependencies,
          allTransitiveDependencies:
              GetGroupMembersFamily._allTransitiveDependencies,
          groupId: groupId,
        );

  GetGroupMembersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.groupId,
  }) : super.internal();

  final String groupId;

  @override
  Override overrideWith(
    FutureOr<List<GroupMember>> Function(GetGroupMembersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetGroupMembersProvider._internal(
        (ref) => create(ref as GetGroupMembersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        groupId: groupId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<GroupMember>> createElement() {
    return _GetGroupMembersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetGroupMembersProvider && other.groupId == groupId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, groupId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetGroupMembersRef on AutoDisposeFutureProviderRef<List<GroupMember>> {
  /// The parameter `groupId` of this provider.
  String get groupId;
}

class _GetGroupMembersProviderElement
    extends AutoDisposeFutureProviderElement<List<GroupMember>>
    with GetGroupMembersRef {
  _GetGroupMembersProviderElement(super.provider);

  @override
  String get groupId => (origin as GetGroupMembersProvider).groupId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

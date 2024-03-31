// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$followListHash() => r'2c402e5a31379037d426799b4c44877477f30a2c';

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

/// See also [followList].
@ProviderFor(followList)
const followListProvider = FollowListFamily();

/// See also [followList].
class FollowListFamily extends Family<List<List<String>>> {
  /// See also [followList].
  const FollowListFamily();

  /// See also [followList].
  FollowListProvider call(
    String pubHex,
  ) {
    return FollowListProvider(
      pubHex,
    );
  }

  @override
  FollowListProvider getProviderOverride(
    covariant FollowListProvider provider,
  ) {
    return call(
      provider.pubHex,
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
  String? get name => r'followListProvider';
}

/// See also [followList].
class FollowListProvider extends Provider<List<List<String>>> {
  /// See also [followList].
  FollowListProvider(
    String pubHex,
  ) : this._internal(
          (ref) => followList(
            ref as FollowListRef,
            pubHex,
          ),
          from: followListProvider,
          name: r'followListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$followListHash,
          dependencies: FollowListFamily._dependencies,
          allTransitiveDependencies:
              FollowListFamily._allTransitiveDependencies,
          pubHex: pubHex,
        );

  FollowListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pubHex,
  }) : super.internal();

  final String pubHex;

  @override
  Override overrideWith(
    List<List<String>> Function(FollowListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FollowListProvider._internal(
        (ref) => create(ref as FollowListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pubHex: pubHex,
      ),
    );
  }

  @override
  ProviderElement<List<List<String>>> createElement() {
    return _FollowListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FollowListProvider && other.pubHex == pubHex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pubHex.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin FollowListRef on ProviderRef<List<List<String>>> {
  /// The parameter `pubHex` of this provider.
  String get pubHex;
}

class _FollowListProviderElement extends ProviderElement<List<List<String>>>
    with FollowListRef {
  _FollowListProviderElement(super.provider);

  @override
  String get pubHex => (origin as FollowListProvider).pubHex;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

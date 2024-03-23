// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_posts_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPostsNotifierHash() => r'7a77b81dc0f7bd93391ce8f88de64bc6c3f679b8';

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

abstract class _$UserPostsNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<Event>> {
  late final String pubHex;

  FutureOr<List<Event>> build(
    String pubHex,
  );
}

/// See also [UserPostsNotifier].
@ProviderFor(UserPostsNotifier)
const userPostsNotifierProvider = UserPostsNotifierFamily();

/// See also [UserPostsNotifier].
class UserPostsNotifierFamily extends Family<AsyncValue<List<Event>>> {
  /// See also [UserPostsNotifier].
  const UserPostsNotifierFamily();

  /// See also [UserPostsNotifier].
  UserPostsNotifierProvider call(
    String pubHex,
  ) {
    return UserPostsNotifierProvider(
      pubHex,
    );
  }

  @override
  UserPostsNotifierProvider getProviderOverride(
    covariant UserPostsNotifierProvider provider,
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
  String? get name => r'userPostsNotifierProvider';
}

/// See also [UserPostsNotifier].
class UserPostsNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    UserPostsNotifier, List<Event>> {
  /// See also [UserPostsNotifier].
  UserPostsNotifierProvider(
    String pubHex,
  ) : this._internal(
          () => UserPostsNotifier()..pubHex = pubHex,
          from: userPostsNotifierProvider,
          name: r'userPostsNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userPostsNotifierHash,
          dependencies: UserPostsNotifierFamily._dependencies,
          allTransitiveDependencies:
              UserPostsNotifierFamily._allTransitiveDependencies,
          pubHex: pubHex,
        );

  UserPostsNotifierProvider._internal(
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
  FutureOr<List<Event>> runNotifierBuild(
    covariant UserPostsNotifier notifier,
  ) {
    return notifier.build(
      pubHex,
    );
  }

  @override
  Override overrideWith(UserPostsNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UserPostsNotifierProvider._internal(
        () => create()..pubHex = pubHex,
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
  AutoDisposeAsyncNotifierProviderElement<UserPostsNotifier, List<Event>>
      createElement() {
    return _UserPostsNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserPostsNotifierProvider && other.pubHex == pubHex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pubHex.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserPostsNotifierRef on AutoDisposeAsyncNotifierProviderRef<List<Event>> {
  /// The parameter `pubHex` of this provider.
  String get pubHex;
}

class _UserPostsNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UserPostsNotifier,
        List<Event>> with UserPostsNotifierRef {
  _UserPostsNotifierProviderElement(super.provider);

  @override
  String get pubHex => (origin as UserPostsNotifierProvider).pubHex;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

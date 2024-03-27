// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileDataImpl _$$ProfileDataImplFromJson(Map<String, dynamic> json) =>
    _$ProfileDataImpl(
      name: json['name'] as String,
      picture: json['picture'] as String,
      about: json['about'] as String,
      pubHex: json['pubHex'] as String,
    );

Map<String, dynamic> _$$ProfileDataImplToJson(_$ProfileDataImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'picture': instance.picture,
      'about': instance.about,
      'pubHex': instance.pubHex,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileHash() => r'8f3b04deef4c875b026d6e912aef5da8d4fd2aa5';

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

/// See also [profile].
@ProviderFor(profile)
const profileProvider = ProfileFamily();

/// See also [profile].
class ProfileFamily extends Family<AsyncValue<ProfileData?>> {
  /// See also [profile].
  const ProfileFamily();

  /// See also [profile].
  ProfileProvider call(
    String pubHex,
  ) {
    return ProfileProvider(
      pubHex,
    );
  }

  @override
  ProfileProvider getProviderOverride(
    covariant ProfileProvider provider,
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
  String? get name => r'profileProvider';
}

/// See also [profile].
class ProfileProvider extends FutureProvider<ProfileData?> {
  /// See also [profile].
  ProfileProvider(
    String pubHex,
  ) : this._internal(
          (ref) => profile(
            ref as ProfileRef,
            pubHex,
          ),
          from: profileProvider,
          name: r'profileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileHash,
          dependencies: ProfileFamily._dependencies,
          allTransitiveDependencies: ProfileFamily._allTransitiveDependencies,
          pubHex: pubHex,
        );

  ProfileProvider._internal(
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
    FutureOr<ProfileData?> Function(ProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ProfileProvider._internal(
        (ref) => create(ref as ProfileRef),
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
  FutureProviderElement<ProfileData?> createElement() {
    return _ProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileProvider && other.pubHex == pubHex;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pubHex.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProfileRef on FutureProviderRef<ProfileData?> {
  /// The parameter `pubHex` of this provider.
  String get pubHex;
}

class _ProfileProviderElement extends FutureProviderElement<ProfileData?>
    with ProfileRef {
  _ProfileProviderElement(super.provider);

  @override
  String get pubHex => (origin as ProfileProvider).pubHex;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

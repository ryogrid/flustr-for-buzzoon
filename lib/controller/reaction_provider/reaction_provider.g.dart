// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reactionHash() => r'95dc9ba294b49d60302a9033693cfa5b0db2a091';

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

/// See also [reaction].
@ProviderFor(reaction)
const reactionProvider = ReactionFamily();

/// See also [reaction].
class ReactionFamily extends Family<AsyncValue<ReactionData>> {
  /// See also [reaction].
  const ReactionFamily();

  /// See also [reaction].
  ReactionProvider call(
    String eventId,
  ) {
    return ReactionProvider(
      eventId,
    );
  }

  @override
  ReactionProvider getProviderOverride(
    covariant ReactionProvider provider,
  ) {
    return call(
      provider.eventId,
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
  String? get name => r'reactionProvider';
}

/// See also [reaction].
class ReactionProvider extends FutureProvider<ReactionData> {
  /// See also [reaction].
  ReactionProvider(
    String eventId,
  ) : this._internal(
          (ref) => reaction(
            ref as ReactionRef,
            eventId,
          ),
          from: reactionProvider,
          name: r'reactionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$reactionHash,
          dependencies: ReactionFamily._dependencies,
          allTransitiveDependencies: ReactionFamily._allTransitiveDependencies,
          eventId: eventId,
        );

  ReactionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.eventId,
  }) : super.internal();

  final String eventId;

  @override
  Override overrideWith(
    FutureOr<ReactionData> Function(ReactionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReactionProvider._internal(
        (ref) => create(ref as ReactionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        eventId: eventId,
      ),
    );
  }

  @override
  FutureProviderElement<ReactionData> createElement() {
    return _ReactionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReactionProvider && other.eventId == eventId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, eventId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ReactionRef on FutureProviderRef<ReactionData> {
  /// The parameter `eventId` of this provider.
  String get eventId;
}

class _ReactionProviderElement extends FutureProviderElement<ReactionData>
    with ReactionRef {
  _ReactionProviderElement(super.provider);

  @override
  String get eventId => (origin as ReactionProvider).eventId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

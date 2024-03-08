// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servaddr_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ImplServAddrSettingImpl _$$ImplServAddrSettingImplFromJson(
        Map<String, dynamic> json) =>
    _$ImplServAddrSettingImpl(
      servAddr: json['servAddr'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ImplServAddrSettingImplToJson(
        _$ImplServAddrSettingImpl instance) =>
    <String, dynamic>{
      'servAddr': instance.servAddr,
      'runtimeType': instance.$type,
    };

_$EmptyServAddrSettingImpl _$$EmptyServAddrSettingImplFromJson(
        Map<String, dynamic> json) =>
    _$EmptyServAddrSettingImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$EmptyServAddrSettingImplToJson(
        _$EmptyServAddrSettingImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$servAddrSettingNotifierHash() =>
    r'cf8628cb0e5b324e269df56076266a07defe6fb1';

/// See also [ServAddrSettingNotifier].
@ProviderFor(ServAddrSettingNotifier)
final servAddrSettingNotifierProvider =
    AsyncNotifierProvider<ServAddrSettingNotifier, ServAddrSetting>.internal(
  ServAddrSettingNotifier.new,
  name: r'servAddrSettingNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$servAddrSettingNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ServAddrSettingNotifier = AsyncNotifier<ServAddrSetting>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member

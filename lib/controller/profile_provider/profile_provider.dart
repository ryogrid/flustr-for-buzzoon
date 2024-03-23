import 'dart:convert';

import 'package:nostrp2p/controller/connection_pool_provider/connection_pool_provider.dart';
import 'package:nostrp2p/controller/profile_cache_provider/profile_cache_notifier.dart';
import 'package:nostrp2p/external/connection_pool.dart';
import 'package:flutter/foundation.dart';
import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../current_sechex_provider/current_sechex_provider.dart';

part 'profile_provider.freezed.dart';
part 'profile_provider.g.dart';

// run this to generate code
// dart run build_runner build

@freezed
class ProfileData with _$ProfileData {
  factory ProfileData({
    required String name,
    required String picture,
    required String about,
    required String pubHex,
  }) = _ProfileData;

  const ProfileData._();

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);
  factory ProfileData.fromEvent(Event event) {
    if (event.kind != 0) {
      throw Exception('expected kind0, but got non-kind0');
    }
    final eventMap = jsonDecode(event.content) as Map<String, dynamic>;
    return ProfileData(
      name: eventMap['name'] ?? 'undefined',
      picture: eventMap['picture'] ?? '',
      about: eventMap['about'] ?? '',
      pubHex: event.pubkey,
    );
  }
}



@Riverpod(keepAlive: true)
FutureOr<ProfileData> profile(ProfileRef ref, String pubHex) async {
  final cache = ref.read(profileCacheNotifierProvider);
  // if (cache.any((element) => element.pubHex == pubHex)) {
  //   return cache.firstWhere((e) => e.pubHex == pubHex);
  // }
  //final pool = await ref.watch(connectionPoolProvider.future);
  if (cache.profiles.any((element) => element.pubHex == pubHex)) {
    //return cache.lastWhere((e) => e.pubHex == pubHex);
    var ret = cache.profiles.lastWhere((e) => e.pubHex == pubHex);
    print("found profile: " + ret.toString());
    return ret;
  }

  return fetchProfile(cache, pubHex)!;
}

ProfileData? fetchProfile(ProfileDataRepository prepo, String pubHex) {
  // TODO: call REST API (fetchProfile at profile_provider.dart)
  return null;
}


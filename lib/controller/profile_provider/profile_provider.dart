import 'dart:convert';

import 'package:nostrp2p/controller/profile_cache_provider/profile_cache_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../external/np2p_api.dart';
import '../current_sechex_provider/current_sechex_provider.dart';
import '../servaddr_provider/servaddr_provider.dart';

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
FutureOr<ProfileData?> profile(ProfileRef ref, String pubHex) async {
  final cache = ref.read(profileCacheNotifierProvider);
  if (cache.profiles.any((element) => element.pubHex == pubHex)) {
    var ret = cache.profiles.lastWhere((e) => e.pubHex == pubHex);
    return ret;
  }

  final url = await ref.watch(servAddrSettingNotifierProvider.future);
  var retVal =  await fetchProfile(url.getServAddr!, pubHex);
  if (retVal != null) {
    ref.read(profileCacheNotifierProvider.notifier).profileRepo.profiles.add(retVal);
    ref.read(profileCacheNotifierProvider.notifier).profileRepo.profileMap[retVal.pubHex] = retVal;
  }
  return retVal;
}

Future<ProfileData?> fetchProfile(String url, String pubHex) async {
  return await Np2pAPI.fetchProfile(url, pubHex);
}


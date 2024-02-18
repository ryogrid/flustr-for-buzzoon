import 'dart:convert';

import 'package:flustr/controller/connection_pool_provider/connection_pool_provider.dart';
import 'package:flustr/controller/profile_cache_provider/profile_cache_provider.dart';
import 'package:flustr/external/connection_pool.dart';
import 'package:flutter/foundation.dart';
import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

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
  final cache = await ref.watch(profileCacheProvider.future);
  if (cache.any((element) => element.pubHex == pubHex)) {
    return cache.firstWhere((e) => e.pubHex == pubHex);
  }
  final pool = await ref.watch(connectionPoolProvider.future);
  return fetchProfile(pool, pubHex);
}

Future<ProfileData> fetchProfile(ConnectionPool pool, String pubHex) async {
  // TODO: need to modify for buzzoon (fetchProfile at profile_provider.dart)
  final events = await pool.getStoredEvent(
    [
      Filter(authors: [pubHex], kinds: [0], limit: 1),
    ],
    timeout: const Duration(seconds: 10),
  );

  // パースで死ぬことを考慮
  try {
    if (events.length == 1) {
      return ProfileData.fromEvent(events.first);
    }
  } catch (e) {
    debugPrint('hogehoge $e');
  }
  throw Exception('profile not found.');
}

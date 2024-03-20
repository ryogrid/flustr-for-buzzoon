import 'dart:async';
import 'dart:convert';

import 'package:nostrp2p/controller/servaddr_provider/servaddr_provider.dart';
import 'package:nostrp2p/external/connection_pool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../external/np2p_api.dart';
import '../profile_cache_provider/profile_cache_provider.dart';
import '../profile_provider/profile_provider.dart';

part 'connection_pool_provider.g.dart';

@Riverpod(keepAlive: true)
Future<ConnectionPool> connectionPool(ConnectionPoolRef ref) async {
  final urls = await ref.watch(servAddrSettingNotifierProvider.future);
  var retPool = ConnectionPool(urls.getServAddr!);

  Timer.periodic(Duration(seconds: 10), (timer) async {
    print(timer.tick);
    var isExistProfile = false;
    if (retPool.isAggregatorGenerated) {
      final now = DateTime.now();
      final nowUnix = (now.millisecondsSinceEpoch / 1000).toInt();
      int since;
      if (retPool.lastEvtReceived == -1) {
        since = nowUnix - 60 * 60 * 24 * 7; // 1 week ago
        retPool.lastEvtReceived = nowUnix;
      } else {
        since = retPool.lastEvtReceived;
        retPool.lastEvtReceived = nowUnix;
      }

      var events = await Np2pAPI.getEvents(urls.getServAddr!, since, nowUnix);
      print(events);
      for (var e in events) {
        if (e.kind == 0) {
          try{
            var profileMap = jsonDecode(e.content);
            var profile = ProfileData(
              name: profileMap['name'],
              about: profileMap['about'],
              picture: profileMap['picture'],
              pubHex: e.pubkey,
            );
            retPool.profiles.add(profile);
            var check = retPool.profileMap[profile.pubHex];
            if (check == null) {
              isExistProfile = true;
            }else{
              if (check.name != profile.name || check.about != profile.about || check.picture != profile.picture) {
                isExistProfile = true;
              }
            }

            retPool.profileMap[profile.pubHex] = profile;
          } catch (e) {
            print(e);
          }
        } else {
          await retPool.addEvent(e);
        }
      }
    }
    if (isExistProfile) {
      ref.invalidate(profileCacheProvider);
    }
  });

  return retPool;
}

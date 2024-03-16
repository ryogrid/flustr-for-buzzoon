import 'dart:async';

import 'package:nostrp2p/controller/relay_url_provider.dart/relay_url_provider.dart';
import 'package:nostrp2p/controller/servaddr_provider/servaddr_provider.dart';
import 'package:nostrp2p/external/connection_pool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../external/np2p_api.dart';
import '../profile_cache_provider/profile_cache_provider.dart';
import '../profile_provider/profile_provider.dart';

part 'connection_pool_provider.g.dart';

@Riverpod(keepAlive: true)
Future<ConnectionPool> connectionPool(ConnectionPoolRef ref) async {
  //final urls = await ref.watch(relayUrlProvider.future);
  final urls = await ref.watch(servAddrSettingNotifierProvider.future);
  //final pcache = await ref.watch(profileCacheProvider.future);
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
          var profile = ProfileData(
            name: e.tags.firstWhere((element) => element.first == 'name')[1],
            picture: e.tags.firstWhere((element) =>
            element.first == 'picture')[1],
            about: e.tags.firstWhere((element) =>
            element.first == 'about')[1],
            pubHex: e.pubkey,
          );
          retPool.profiles.add(profile);
          retPool.profileMap[profile.pubHex] = profile;
          isExistProfile = true;
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

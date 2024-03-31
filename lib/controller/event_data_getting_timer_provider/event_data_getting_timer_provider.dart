import 'dart:async';
import 'dart:convert';

import 'package:nostrp2p/const.dart';
import 'package:nostrp2p/controller/reaction_cache_provider/reaction_cache_notifier.dart';
import 'package:nostrp2p/controller/reaction_provider/reaction_provider.dart';
import 'package:nostrp2p/controller/servaddr_provider/servaddr_provider.dart';
import 'package:nostrp2p/controller/timeline_posts_notifier/timeline_posts_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../external/np2p_api.dart';
import '../profile_cache_provider/profile_cache_notifier.dart';
import '../profile_provider/profile_provider.dart';

part 'event_data_getting_timer_provider.g.dart';

Timer? t = null;

// this provider is used to get event data from the server periodically
// and update the profile data and timeline posts with Timer.periodic
// No widget and other providers needs state of this provider but it needs to be kept alive
@Riverpod(keepAlive: true)
Future<bool> eventDataGettingTimer(EventDataGettingTimerRef ref) async {
  final urls = await ref.watch(servAddrSettingNotifierProvider.future);

  final profiles = ref.read(profileCacheNotifierProvider);
  final reactions = ref.read(reactionCacheNotifierProvider);

  if (t != null) {
    t!.cancel();
  }

  var lastEvtReceived = -1;
  t = Timer.periodic(Duration(seconds: PrefKeys.eventDataGettingIntervalSec),
      (timer) async {
    var isExistProfile = false;
    var isExistReaction = false;

    final now = DateTime.now();
    final nowUnix = (now.millisecondsSinceEpoch / 1000).toInt();
    int since;
    if (lastEvtReceived == -1) {
      since = nowUnix - PrefKeys.firstGettingDataPeriod;
      lastEvtReceived = nowUnix;
    } else {
      since = lastEvtReceived;
      lastEvtReceived = nowUnix;
    }

    var events = await Np2pAPI.reqEvents(urls.getServAddr!, since, nowUnix);
    for (var e in events) {
      switch (e.kind) {
        case 0: // profile
          try {
            var profileMap = jsonDecode(e.content);
            var profile = ProfileData(
              name: profileMap['name'],
              about: profileMap['about'],
              picture: profileMap['picture'],
              pubHex: e.pubkey,
            );
            profiles.profiles.add(profile);
            var check = profiles.profileMap[profile.pubHex];
            if (check == null) {
              isExistProfile = true;
            } else {
              if (check.name != profile.name ||
                  check.about != profile.about ||
                  check.picture != profile.picture) {
                isExistProfile = true;
              }
            }

            profiles.profileMap[profile.pubHex] = profile;
          } catch (e) {
            print(e);
          }
          break;
        case 1: // text note
          ref.read(timelinePostsNotifierProvider.notifier).addEvent(e);
          break;
        case 7: //reaction
          // reactions.notifyReactionEvent(e);
          ref.read(reactionCacheNotifierProvider.notifier).addReaction(e);
          isExistReaction = true;
          break;
        default:
          print('unexpected event kind');
      }
    }

    if (isExistProfile) {
      ref.invalidate(profileProvider);
    }
    if (isExistReaction) {
      ref.invalidate(reactionProvider);
    }
  });

  return true;
}

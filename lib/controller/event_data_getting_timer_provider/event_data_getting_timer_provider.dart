import 'dart:async';
import 'dart:convert';

import 'package:nostrp2p/const.dart';
import 'package:nostrp2p/controller/follow_list_cache_probider/follow_list_cache_notifier.dart';
import 'package:nostrp2p/controller/notification_cache_notifier/notification_cache_notifier.dart';
import 'package:nostrp2p/controller/reaction_cache_provider/reaction_cache_notifier.dart';
import 'package:nostrp2p/controller/reaction_provider/reaction_provider.dart';
import 'package:nostrp2p/controller/servaddr_provider/servaddr_provider.dart';
import 'package:nostrp2p/controller/timeline_posts_notifier/timeline_posts_notifier.dart';
import 'package:nostrp2p/external/np2p_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../external/np2p_api.dart';
import '../current_pubhex_provider/current_pubhex_provider.dart';
import '../follow_list_provider/follow_list_provider.dart';
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
  final pubHex = ref.watch(currentPubHexProvider);

  final profiles = ref.read(profileCacheNotifierProvider);

  if (t != null) {
    t!.cancel();
  }

  // setup self follow list
  if (pubHex != null) {
    final followListEvt = await Np2pAPI.fetchFolloList(urls.getServAddr!, pubHex!);
    if (followListEvt != null) {
      ref.read(followListCacheNotifierProvider.notifier).setOrUpdateFollowList(pubHex, followListEvt.tags);
    }
  }

  var lastEvtReceived = -1;
  t = Timer.periodic(Duration(seconds: EVENT_DATA_GETTING_INTERVAL_SEC),
      (timer) async {
    var isExistProfile = false;
    var isExistFollowList = false;
    var isExistNotificationNeededEvt = false;
    var isExistReply = false;

    final now = DateTime.now();
    final nowUnix = (now.millisecondsSinceEpoch / 1000).toInt();
    int since;
    if (lastEvtReceived == -1) {
      since = nowUnix - FIRST_GETTING_DATA_PERIOD;
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
          if (classifyPostKind(e.tags) == POST_KIND.REPLY || classifyPostKind(e.tags) == POST_KIND.MENTION) {
            ref.read(notificationCacheNotifierProvider.notifier).addNotification(e);
            isExistNotificationNeededEvt = true;
          }
          break;
        case 3: // follow
            ref.read(followListCacheNotifierProvider.notifier).setOrUpdateFollowList(e.pubkey, e.tags);
            isExistFollowList = true;
        case 7: //reaction
          // reactions.notifyReactionEvent(e);
          ref.read(reactionCacheNotifierProvider.notifier).addReaction(e);
          ref.read(notificationCacheNotifierProvider.notifier).addNotification(e);
          isExistNotificationNeededEvt = true;
          break;
        default:
          print('unexpected event kind');
          return;
      }
      // this provider stores all events on Map...
      ref.read(notificationCacheNotifierProvider.notifier).addEvent(e);
    }


    if (isExistProfile) {
      ref.invalidate(profileProvider);
    }
    if (isExistFollowList) {
      ref.invalidate(followListProvider);
    }
    if (isExistNotificationNeededEvt) {
      ref.invalidate(reactionProvider);
      ref.invalidate(notificationCacheNotifierProvider);
    }
  });

  return true;
}

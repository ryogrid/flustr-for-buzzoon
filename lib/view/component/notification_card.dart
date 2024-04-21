import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr/nostr.dart';
import 'package:nostrp2p/external/np2p_api.dart';
import 'package:nostrp2p/external/np2p_util.dart';
import 'package:nostrp2p/view/component/reaction_card.dart';

import 'dart:convert';
import '../../const.dart';
import '../../controller/current_pubhex_provider/current_pubhex_provider.dart';
import '../../controller/notification_cache_notifier/notification_cache_notifier.dart';
import 'post_card.dart';

class NotificationCard extends ConsumerWidget {
  const NotificationCard({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationCacheNotifierProvider);

    // NOTE: here, already checked this.event's tags include self pubHex as p tag
    if(this.event.kind == 7 && notifications.eventDataMap[this.event.tags[0][1]] != null) {
      // reaction to my post
      return ReactionCard(event: this.event);
    } else if (this.event.kind == 6 && notifications.eventDataMap[extractEAndPtags(this.event.tags)["e"]!.last[1]] != null) {
      // repost of my post
      var decodedJsonMap = jsonDecode(this.event.content);
      if (!(decodedJsonMap is Map)){
        return Container();
      }
      var repostedEvt = Np2pAPI.jsonToEvent(decodedJsonMap as Map<String, dynamic>);
      return PostCard(event: repostedEvt, parentScreen: "notification",repostUserPubHex: this.event.pubkey,);
    } else if (this.event.kind == 1 && classifyPostKind(this.event) == POST_KIND.QUOTE_REPOST && notifications.eventDataMap[extractEAndPtags(this.event.tags)["e"]!.last[1]] != null) {
      // quote repost to my post
      // TODO: need to fix PostCard component to display quote repost collectly
      return PostCard(event: this.event, parentScreen: "notification",);
    } else if (this.event.kind == 1 && classifyPostKind(this.event) == POST_KIND.REPLY && notifications.eventDataMap[extractEAndPtags(this.event.tags)["e"]!.last[1]] != null) {
      // reply to my post
      return PostCard(event: this.event, parentScreen: "notification",);
    }else if (this.event.kind == 1 && classifyPostKind(this.event) == POST_KIND.MENTION) {
      // mention to me
      return PostCard(event: this.event, parentScreen: "notification",);
    }else{
      return Container(); // display nothing
    }
  }
}

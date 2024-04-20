import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr/nostr.dart';
import 'package:nostrp2p/external/np2p_util.dart';
import 'package:nostrp2p/view/component/reaction_card.dart';

import '../../const.dart';
import '../../controller/current_pubhex_provider/current_pubhex_provider.dart';
import '../../controller/notification_cache_notifier/notification_cache_notifier.dart';
import 'post_card.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationCacheNotifierProvider);
    final pubHex = ref.watch(currentPubHexProvider);

    if (this.event.kind == 1 && classifyPostKind(this.event.tags) == POST_KIND.REPLY && notifications.eventDataMap[extractEAndPtags(this.event.tags)["e"]!.last[1]] != null && notifications.eventDataMap[extractEAndPtags(this.event.tags)["e"]!.last[1]]!.pubkey == pubHex) {
      // reply to my post
      return PostCard(event: this.event, parentScreen: "notification",);
    }else if (this.event.kind == 1 && classifyPostKind(this.event.tags) == POST_KIND.MENTION && extractEAndPtags(this.event.tags)["p"]!.last[1] == pubHex) {
      // mention to me
      return PostCard(event: this.event, parentScreen: "notification",);
    }else if(this.event.kind == 7 && notifications.eventDataMap[this.event.tags[0][1]] != null && notifications.eventDataMap[this.event.tags[0][1]]!.pubkey == pubHex) {
      // reaction to my post
      return ReactionCard(event: this.event);
    }else{
      return Container(); // display nothing
    }
  }
}

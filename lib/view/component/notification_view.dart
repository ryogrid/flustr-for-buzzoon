import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr/nostr.dart';
import 'package:intl/intl.dart';
import 'package:nostrp2p/controller/reaction_cache_provider/reaction_cache_notifier.dart';
import 'package:nostrp2p/external/np2p_api.dart';
import 'package:nostrp2p/external/np2p_util.dart';
import 'package:nostrp2p/view/component/reaction_view.dart';
import 'package:nostrp2p/view/screen/thread_screen.dart';

import '../../const.dart';
import '../../controller/current_pubhex_provider/current_pubhex_provider.dart';
import '../../controller/current_sechex_provider/current_sechex_provider.dart';
import '../../controller/notification_cache_notifier/notification_cache_notifier.dart';
import '../../controller/reaction_provider/reaction_provider.dart';
import '../../controller/servaddr_provider/servaddr_provider.dart';
import '../screen/profile_screen.dart';
import 'event_view.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationCacheNotifierProvider);
    final pubHex = ref.watch(currentPubHexProvider);

    if (this.event.kind == 1 && notifications.eventDataMap[extractEAndPtags(this.event.tags)["e"]!.last[1]] != null && notifications.eventDataMap[extractEAndPtags(this.event.tags)["e"]!.last[1]]!.pubkey == pubHex) {
      // reply to my post
      return EventView(event: this.event, parentScreen: "notification",);
    }else if(this.event.kind == 7 && notifications.eventDataMap[this.event.tags[0][1]] != null && notifications.eventDataMap[this.event.tags[0][1]]!.pubkey == pubHex) {
      // reaction to my post
      return ReactionView(event: this.event);
    }else{
      return Container(); // display nothing
    }
  }
}

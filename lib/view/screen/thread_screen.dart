import 'package:collection/collection.dart';
import 'package:nostr/nostr.dart';
import 'package:nostrp2p/controller/event_data_getting_timer_provider/event_data_getting_timer_provider.dart';
import 'package:nostrp2p/controller/is_seckey_available_provider/is_seckey_available_provider.dart';
import 'package:nostrp2p/controller/timeline_posts_notifier/timeline_posts_notifier.dart';
import 'package:nostrp2p/view/component/event_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/current_pubhex_provider/current_pubhex_provider.dart';
import '../../controller/follow_list_provider/follow_list_provider.dart';
import '../../controller/is_following_only_tl_provider/is_following_only_tl_provider.dart';
import '../../controller/notification_cache_notifier/notification_cache_notifier.dart';
import '../../external/np2p_util.dart';
import '../component/posting_button.dart';
import '../component/thread_view.dart';
import '../component/top_bar.dart';

class ThreadScreen extends ConsumerWidget {
  const ThreadScreen({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reply thread'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(eventDataGettingTimerProvider),
        child: ListView(
          children: constructTheadViewList(ref, this.event),
        ),
      ),
    );
  }

  List<Widget> constructTheadViewList(WidgetRef ref, Event event) {
    var retList = <Widget>[];

    final notifications = ref.watch(notificationCacheNotifierProvider);

    // traverse the parent post events
    var parentEvent = notifications.eventDataMap[extractEAndPtags(event.tags)["e"]!.last[1]];
    while (parentEvent != null) {
      retList.add(ThreadView(event: parentEvent));
      if (extractEAndPtags(parentEvent.tags)["e"]!.length > 0){
        parentEvent = notifications.eventDataMap[extractEAndPtags(parentEvent.tags)["e"]!.last[1]];
      }else{
        parentEvent = null;
      }
    }

    retList = retList.reversed.toList();
    retList.add(ThreadView(event: event));
    return retList;
  }
}

import 'package:nostr/nostr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/event_data_getting_timer_provider/event_data_getting_timer_provider.dart';
import '../component/post_card.dart';
import '../../controller/notification_cache_notifier/notification_cache_notifier.dart';
import '../../external/np2p_util.dart';

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
          children: constructEventViewList(ref, this.event),
        ),
      ),
    );
  }

  List<Widget> constructEventViewList(WidgetRef ref, Event event) {
    var retList = <Widget>[];

    final notifications = ref.watch(notificationCacheNotifierProvider);

    // traverse the parent post events
    var parentEvent = notifications.eventDataMap[extractEAndPtags(event.tags)["e"]!.last[1]];
    while (parentEvent != null) {
      //retList.add(ThreadView(event: parentEvent));
      retList.add(PostCard(event: parentEvent, parentScreen: "thread"));
      if (extractEAndPtags(parentEvent.tags)["e"]!.length > 0){
        parentEvent = notifications.eventDataMap[extractEAndPtags(parentEvent.tags)["e"]!.last[1]];
      }else{
        parentEvent = null;
      }
    }

    retList = retList.reversed.toList();
    //retList.add(ThreadView(event: event));
    retList.add(PostCard(event: event, parentScreen: "thread"));
    return retList;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrp2p/const.dart';

import '../../controller/event_data_getting_timer_provider/event_data_getting_timer_provider.dart';
import '../../controller/notification_cache_notifier/notification_cache_notifier.dart';
import '../component/notification_card.dart';


class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref
        .watch(notificationCacheNotifierProvider);

    final evtTimer = ref.watch(eventDataGettingTimerProvider);

    // this print is for generation of eventDataGettingTimerProvider object
    print('thread screen rebuilded: ' + evtTimer.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(eventDataGettingTimerProvider),
        child: ListView(
          children: notifications.notificationDataList
              .take(POSTS_PER_PAGE)
              .map((e) => NotificationCard(event: e))
              .toList()
              .reversed
              .toList()
              .toSet() // for dedupulication
              .toList()
          ,
        ),
      ),
    );
  }
}

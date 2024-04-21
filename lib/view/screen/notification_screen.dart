import 'package:nostrp2p/controller/event_data_getting_timer_provider/event_data_getting_timer_provider.dart';
import 'package:nostrp2p/controller/is_seckey_available_provider/is_seckey_available_provider.dart';
import 'package:nostrp2p/controller/notification_cache_notifier/notification_cache_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/current_pubhex_provider/current_pubhex_provider.dart';
import '../../controller/follow_list_provider/follow_list_provider.dart';
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

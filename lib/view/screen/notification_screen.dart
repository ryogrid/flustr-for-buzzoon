import 'package:collection/collection.dart';
import 'package:nostrp2p/controller/event_data_getting_timer_provider/event_data_getting_timer_provider.dart';
import 'package:nostrp2p/controller/is_seckey_available_provider/is_seckey_available_provider.dart';
import 'package:nostrp2p/controller/timeline_posts_notifier/timeline_posts_notifier.dart';
import 'package:nostrp2p/view/component/event_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/current_pubhex_provider/current_pubhex_provider.dart';
import '../../controller/follow_list_provider/follow_list_provider.dart';
import '../../controller/is_following_only_tl_provider/is_following_only_tl_provider.dart';
import '../component/posting_button.dart';
import '../component/top_bar.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelinePosts = ref.watch(timelinePostsNotifierProvider);
    final isSeckeyAvailable = ref.watch(isSeckeyAvailableProvider);
    final evtTimer = ref.watch(eventDataGettingTimerProvider);
    final pubHex = ref.watch(currentPubHexProvider);
    final followList = ref.watch(followListProvider(pubHex!));
    final isFollowingOnlyTl = ref.watch(isFollowingOnlyTlProvider);

    // this print is for generation of eventDataGettingTimerProvider object
    print('thread screen rebuilded: ' + evtTimer.toString());

    var followListPubHexes = followList.map((e) => e[1]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('notifications'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(eventDataGettingTimerProvider),
        child: ListView( // TODO: need to implement (NotificationScreen::build)
          children: switch (timelinePosts) {
            AsyncLoading() => [const LinearProgressIndicator()],
            AsyncError(:final error, :final stackTrace) => [
                Text(error.toString()),
                Text(stackTrace.toString()),
              ],
            AsyncData(value: final posts) => isFollowingOnlyTl
                ? posts
                    .where((e) => followListPubHexes.contains(e.pubkey))
                    .map((e) => EventView(event: e))
                    .toList()
                : posts.map((e) => EventView(event: e)).toList(),
            _ => [const Text('Oops! something went wrong!')],
          },
        ),
      ),
    );
  }
}

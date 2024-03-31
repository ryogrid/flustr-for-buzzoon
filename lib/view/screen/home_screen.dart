import 'package:nostrp2p/controller/event_data_getting_timer_provider/event_data_getting_timer_provider.dart';
import 'package:nostrp2p/controller/is_seckey_available_provider/is_seckey_available_provider.dart';
import 'package:nostrp2p/controller/timeline_posts_notifier/timeline_posts_notifier.dart';
import 'package:nostrp2p/view/component/event_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../component/posting_button.dart';
import '../component/top_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timelinePosts = ref.watch(timelinePostsNotifierProvider);
    final isSeckeyAvailable = ref.watch(isSeckeyAvailableProvider);
    final evtTimer = ref.watch(eventDataGettingTimerProvider);

    // this print is for generation of eventDataGettingTimerProvider object
    print('home screen rebuilded: ' + evtTimer.toString());

    return Scaffold(
      // button for posting
      floatingActionButton: isSeckeyAvailable
      ? PostingButton()
          : null,
      appBar: TopBar(),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(eventDataGettingTimerProvider),
        child: ListView(
          children: switch (timelinePosts) {
            AsyncLoading() => [const LinearProgressIndicator()],
            AsyncError(:final error, :final stackTrace) => [
                Text(error.toString()),
                Text(stackTrace.toString()),
              ],
            AsyncData(value: final posts) =>
                posts.map((e) => EventView(event: e)).toList(),
            _ => [const Text('Oops! something went wrong!')],
          },
        ),
      ),
    );
  }
}

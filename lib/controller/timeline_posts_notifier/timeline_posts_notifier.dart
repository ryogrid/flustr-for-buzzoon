import 'package:collection/collection.dart';
import 'package:nostrp2p/controller/connection_pool_provider/connection_pool_provider.dart';
import 'package:nostrp2p/controller/follow_list_provider/follow_list_provider.dart';
import 'package:nostr/nostr.dart';
import 'package:nostrp2p/external/stream_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timeline_posts_notifier.g.dart';

@riverpod
class TimelinePostsNotifier extends _$TimelinePostsNotifier {
  StreamAggregator? aggregator;

  @override
  Future<List<Event>> build() async {
    //final followeePubHexList = await ref.watch(followListProvider.future);
    final pool = await ref.watch(connectionPoolProvider.future);

    aggregator = pool.getEventStreamAfterEose(
      [
        // Filter(
        //   authors: followeePubHexList,
        //   kinds: [1],
        //   limit: 30,
        // ),
      ],
    );
    aggregator!.eventStream.listen((e) {
      state = switch (state) {
        AsyncData(:final value) => AsyncData([e, ...value]),
        _ => state,
      };
    });
    ref.onDispose(() {
      aggregator!.dispose();
    });
    return [];
  }

  void addEvent(Event e) {
    if (aggregator != null) {
      aggregator!.addEvent(e);
    }
  }
}

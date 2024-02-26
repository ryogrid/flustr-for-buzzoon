import 'package:collection/collection.dart';
import 'package:flustr/controller/connection_pool_provider/connection_pool_provider.dart';
import 'package:flustr/controller/follow_list_provider/follow_list_provider.dart';
import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timeline_posts_notifier.g.dart';

@riverpod
class TimelinePostsNotifier extends _$TimelinePostsNotifier {

  // TODO: need to modify for buzzoon TimelinePostsNotifier::build
  @override
  Future<List<Event>> build() async {
    //final followeePubHexList = await ref.watch(followListProvider.future);
    final pool = await ref.watch(connectionPoolProvider.future);
    final posts = await pool.getStoredEvent(
      [
        Filter(
          authors: followeePubHexList,
          kinds: [1],
          limit: 30,
        ),
      ],
      // fixme: タイムアウトはもっと考えたほうが良さそう
      timeout: const Duration(seconds: 3),
    );
    final aggregator = pool.getEventStreamAfterEose(
      [
        Filter(
          authors: followeePubHexList,
          kinds: [1],
          limit: 30,
        ),
      ],
    );
    aggregator.eventStream.listen((e) {
      state = switch (state) {
        AsyncData(:final value) => AsyncData([e, ...value]),
        _ => state,
      };
    });
    ref.onDispose(() {
      aggregator.dispose();
    });
    return posts
        .sortedBy<num>((element) => element.createdAt)
        .reversed
        .toList();
  }

  bool _loading = false;

  Future<void> loadOlderPosts() async {
    if (_loading) return;
    _loading = true;
    final pool = await ref.read(connectionPoolProvider.future);
    final currentPosts = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (currentPosts == null) {
      return;
    }

    //final followees = await ref.read(followListProvider.future);

    final last = currentPosts.last;
    final oldEvents = await pool.getStoredEvent(
      [
        Filter(
          authors: followees,
          kinds: [1],
          limit: 30,
          until: last.createdAt + 1,
        )
      ],
      timeout: const Duration(seconds: 3),
    );

    final newEventsWithDups = [...currentPosts, ...oldEvents];

    final seen = <String>{};
    final newEvents = <Event>[];
    for (final event in newEventsWithDups) {
      if (seen.contains(event.id)) {
        continue;
      }
      seen.add(event.id);
      newEvents.add(event);
    }

    state = AsyncData(newEvents);
    _loading = false;
  }
}

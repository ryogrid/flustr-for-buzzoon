import 'package:collection/collection.dart';
import 'package:buzzoon/controller/connection_pool_provider/connection_pool_provider.dart';
import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_posts_notifier.g.dart';

@riverpod
class UserPostsNotifier extends _$UserPostsNotifier {
  @override
  Future<List<Event>> build(String pubHex) async {
    final pool = await ref.watch(connectionPoolProvider.future);
    final posts = await pool.getStoredEvent(
      [
        Filter(
          authors: [pubHex],
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
          authors: [pubHex],
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

    final last = currentPosts.last;
    final oldEvents = await pool.getStoredEvent(
      [
        Filter(
          authors: [pubHex],
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

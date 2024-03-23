import 'package:collection/collection.dart';
import 'package:nostrp2p/controller/connection_pool_provider/connection_pool_provider.dart';
import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_posts_notifier.g.dart';

@riverpod
class UserPostsNotifier extends _$UserPostsNotifier {
  @override
  Future<List<Event>> build(String pubHex) async {
    final pool = await ref.watch(connectionPoolProvider.future);
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
    return [];
  }
}

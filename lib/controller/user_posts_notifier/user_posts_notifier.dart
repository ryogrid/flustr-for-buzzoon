import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../external/stream_wrapper.dart';

part 'user_posts_notifier.g.dart';

@riverpod
class UserPostsNotifier extends _$UserPostsNotifier {
  @override
  Future<List<Event>> build(String pubHex) async {
    final aggregator = StreamWrapper();
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

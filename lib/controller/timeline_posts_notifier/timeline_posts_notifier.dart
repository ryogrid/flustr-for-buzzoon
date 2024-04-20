import 'package:nostr/nostr.dart';
import 'package:nostrp2p/external/stream_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timeline_posts_notifier.g.dart';

@riverpod
class TimelinePostsNotifier extends _$TimelinePostsNotifier {
  StreamWrapper? aggregator;

  @override
  Future<List<Event>> build() async {
    //final followeePubHexList = await ref.watch(followListProvider.future);
    aggregator = StreamWrapper();
    aggregator!.eventStream.listen((e) {
      print(e.content);
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

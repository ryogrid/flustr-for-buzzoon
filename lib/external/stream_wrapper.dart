import 'dart:async';

import 'package:nostr/nostr.dart';

class StreamWrapper {
  StreamWrapper({
    Duration rotateBy = const Duration(minutes: 1),
  }) {
    _events = StreamController<Event>();
    // _logDeleter = Timer.periodic(rotateBy, (timer) {
    //   final now = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    //   final oneMinuteAgo = now - rotateBy.inSeconds;
    //   _removeUntil(oneMinuteAgo);
    // });
  }

  late final StreamController<Event> _events;
  late final Timer _logDeleter;
  // addEventにイベントを流すlistenの中でStreamWrapperが必要だが、
  // listenしないとpoolCleanerに入れるべき関数を作れない
  void Function()? cleanUp;
  final Map<String, int> _seenAlready = {};

  // // threshold以前のeventのログを削除
  // void _removeUntil(int threshold) {
  //   final newMap = <String, int>{};
  //   for (final entry in _seenAlready.entries) {
  //     if (entry.value >= threshold) {
  //       newMap.addEntries([entry]);
  //     }
  //   }
  //   _seenAlready.clear();
  //   _seenAlready.addAll(newMap);
  // }

  // 重複込みでイベントを受け取る
  void addEvent(Event event) {
    if (_seenAlready.containsKey(event.id)) {
      return;
    }
    _seenAlready[event.id] = event.createdAt;
    _events.sink.add(event);
  }

  // 重複を排除したものを出す
  Stream<Event> get eventStream => _events.stream;

  Future<void> dispose() async {
    // _logDeleter.cancel();
    if (cleanUp != null) {
      cleanUp!();
    }
    _events.close();
  }
}

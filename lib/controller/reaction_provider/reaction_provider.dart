import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../reaction_cache_provider/reaction_cache_notifier.dart';

part 'reaction_provider.freezed.dart';
part 'reaction_provider.g.dart';

// run this to generate code
// dart run build_runner build

@freezed
class ReactionData with _$ReactionData {
  factory ReactionData({
    required String eventId,
    required List<String> pubHexs,
  }) = _ReactionData;

  const ReactionData._();
}

@Riverpod(keepAlive: true)
FutureOr<ReactionData> reaction(ReactionRef ref, String eventId) async {
  final cache = ref.read(reactionCacheNotifierProvider);

  print("reaction");
  print("eventId: " + eventId);
  print(cache.reactionDataMap);
  if (cache.reactionDataMap[eventId] != null) {
    var retProf = cache.reactionDataMap[eventId]!;
    print(retProf);
    return retProf;
  }else{
    print("reaction: not found");
    return ReactionData(eventId: eventId, pubHexs: []);
  }

}

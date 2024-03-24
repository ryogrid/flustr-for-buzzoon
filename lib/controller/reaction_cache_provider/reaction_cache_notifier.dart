import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../reaction_provider/reaction_provider.dart';
part 'reaction_cache_notifier.g.dart';

class ReactionDataRepository {
  static final ReactionDataRepository _singleton = ReactionDataRepository._internal();
  factory ReactionDataRepository() {
    return _singleton;
  }
  ReactionDataRepository._internal();

  Map<String, ReactionData> reactionDataMap = <String, ReactionData>{};

  void notifyReactionEvent(Event reactionEvent){
    if (this.reactionDataMap[reactionEvent.id] == null) {
      this.reactionDataMap[reactionEvent.id] = ReactionData(eventId: reactionEvent.id, pubHexs: [reactionEvent.pubkey]);
    }else{
      var reactionData = this.reactionDataMap[reactionEvent.id]!;
      if (!reactionData.pubHexs.contains(reactionEvent.pubkey)) {
        reactionData.pubHexs.add(reactionEvent.pubkey);
      }
      this.reactionDataMap[reactionEvent.id] = reactionData;
    }
  }
}

@riverpod
class ReactionCacheNotifier extends _$ReactionCacheNotifier {
  ReactionDataRepository reactionRepo = ReactionDataRepository();

  @override
  ReactionDataRepository build() {
    return this.reactionRepo;
  }
}
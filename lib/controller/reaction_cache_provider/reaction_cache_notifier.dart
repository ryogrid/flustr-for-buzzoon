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
    var tgtEvtId = reactionEvent.tags.firstWhere((element) => element[0] == "e")![1];
    if (this.reactionDataMap[tgtEvtId] == null) {
      this.reactionDataMap[tgtEvtId] = ReactionData(eventId: tgtEvtId , pubHexs: [reactionEvent.pubkey]);
    }else{
      var reactionData = this.reactionDataMap[tgtEvtId]!;
      if (!reactionData.pubHexs.contains(reactionEvent.pubkey)) {
        reactionData.pubHexs.add(reactionEvent.pubkey);
        this.reactionDataMap[reactionEvent.id] = reactionData;
      }
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
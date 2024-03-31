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
}

@riverpod
class ReactionCacheNotifier extends _$ReactionCacheNotifier {
  ReactionDataRepository reactionRepo = ReactionDataRepository();

  @override
  ReactionDataRepository build() {
    return this.reactionRepo;
  }

  void addReaction(Event reactionEvent){
    var tgtEvtId = reactionEvent.tags.firstWhere((element) => element[0] == "e")![1];

    if (this.reactionRepo.reactionDataMap[tgtEvtId] == null) {
      this.reactionRepo.reactionDataMap[tgtEvtId] = ReactionData(eventId: tgtEvtId , pubHexs: [reactionEvent.pubkey]);
    }else{
      var reactionData = this.reactionRepo.reactionDataMap[tgtEvtId]!;
      if (!reactionData.pubHexs.contains(reactionEvent.pubkey)) {
        // create new ReactionData for update immutable state
        var newPubHexList = reactionData.pubHexs.toSet().toList();
        newPubHexList.add(reactionEvent.pubkey);
        this.reactionRepo.reactionDataMap[tgtEvtId] = ReactionData(eventId: tgtEvtId, pubHexs: newPubHexList);
      }
    }
  }
}
import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_cache_notifier.g.dart';

class NotificationDataRepository {
  static final NotificationDataRepository _singleton = NotificationDataRepository._internal();
  factory NotificationDataRepository() {
    return _singleton;
  }
  NotificationDataRepository._internal();

  List<Event> notificationDataList = <Event>[];
  Map<String, Event> eventDataMap = <String, Event>{};
}

@riverpod
class NotificationCacheNotifier extends _$NotificationCacheNotifier {
  NotificationDataRepository notificationRepo = NotificationDataRepository();

  @override
  NotificationDataRepository build() {
    return this.notificationRepo;
  }

  void addNotification(Event notificationEvent){
    this.notificationRepo.notificationDataList.add(notificationEvent);
    this.notificationRepo.eventDataMap[notificationEvent.id] = notificationEvent;

    // var tgtEvtId = reactionEvent.tags.firstWhere((element) => element[0] == "e")![1];
    //
    // if (this.reactionRepo.reactionDataMap[tgtEvtId] == null) {
    //   this.reactionRepo.reactionDataMap[tgtEvtId] = ReactionData(eventId: tgtEvtId , pubHexs: [reactionEvent.pubkey]);
    // }else{
    //   var reactionData = this.reactionRepo.reactionDataMap[tgtEvtId]!;
    //   if (!reactionData.pubHexs.contains(reactionEvent.pubkey)) {
    //     // create new ReactionData for update immutable state
    //     var newPubHexList = reactionData.pubHexs.toSet().toList();
    //     newPubHexList.add(reactionEvent.pubkey);
    //     this.reactionRepo.reactionDataMap[tgtEvtId] = ReactionData(eventId: tgtEvtId, pubHexs: newPubHexList);
    //   }
    // }
  }
}
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

  void addEvent(Event evt){
    this.notificationRepo.eventDataMap[evt.id] = evt;
  }

  void addNotification(Event notificationEvent){
    if (this.notificationRepo.eventDataMap[notificationEvent.id] == null) {
      this.notificationRepo.notificationDataList.add(notificationEvent);
    }
  }
}
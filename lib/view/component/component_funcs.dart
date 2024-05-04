import 'package:nostrp2p/controller/notification_cache_notifier/notification_cache_notifier.dart';
import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr/nostr.dart';
import 'package:intl/intl.dart';
import '../../const.dart';
import '../../external/np2p_util.dart';
import '../screen/profile_screen.dart';

Widget buildAuthorPic(BuildContext context, WidgetRef ref, Event evt) {
  final author = ref.watch(profileProvider(evt.pubkey));

  return switch (author) {
    AsyncData(value: final authorProf) => Container(
      clipBehavior: Clip.antiAlias,
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProfileScreen(pubHex: evt.pubkey),
              ),
            );
          },
          child: Image.network(
            authorProf == null
                ? NO_PROFILE_USER_PICTURE_URL
                : authorProf.picture,
          ),
        ),
      ),
    ),
    AsyncError(:final error, :final stackTrace) => Container(
      clipBehavior: Clip.antiAlias,
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Image.network(
        NO_PROFILE_USER_PICTURE_URL,
      ),
    ),
    _ => const SizedBox(),
  };
}

Widget buildChildCard(BuildContext context, WidgetRef ref, Event evt) {
  final notifications = ref.watch(notificationCacheNotifierProvider);
  final quotedEvt =
  notifications.eventDataMap[extractEAndPtags(evt.tags)["e"]!.last[1]];
  if (quotedEvt == null) {
    return const Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.zero,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quoted post not found"),
          ],
        ),
      ),
    );
  }

  final author = ref.watch(profileProvider(quotedEvt.pubkey));

  return Card(
    shape: const RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey, width: 0.5),
      borderRadius: BorderRadius.zero,
    ),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildAuthorPic(context, ref, quotedEvt),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  extractAsyncValue(
                      author, (authorProf) => authorProf!.name, "unkown"),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(quotedEvt.content),
                Align(
                  child: Text((Nip19.encodePubkey(evt.pubkey).replaceAll("npub", "")).substring(0, 9) + "..."),
                  alignment: Alignment.centerRight,
                ),
                Align(
                  child: Text(
                      DateFormat.Md().add_jm().format(
                          DateTime.fromMillisecondsSinceEpoch(
                              quotedEvt.createdAt * 1000))
                  ),
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
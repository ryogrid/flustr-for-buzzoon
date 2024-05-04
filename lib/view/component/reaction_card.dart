import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr/nostr.dart';
import 'package:intl/intl.dart';
import 'package:nostrp2p/view/component/component_funcs.dart';

import '../../const.dart';
import '../../controller/notification_cache_notifier/notification_cache_notifier.dart';
import '../../external/np2p_util.dart';
import '../screen/profile_screen.dart';

class ReactionCard extends ConsumerWidget {
  const ReactionCard({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tgtPostAuthor = ref.watch(profileProvider(extractEAndPtags(this.event.tags)["p"]!.last[1]));
    final reactedUser = ref.watch(profileProvider(this.event.pubkey));
    final notifications = ref.watch(notificationCacheNotifierProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            switch (tgtPostAuthor) {
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
                            builder: (_) => ProfileScreen(pubHex: event.pubkey),
                          ),
                        );
                      },
                      child: Image.network(
                        authorProf == null ? NO_PROFILE_USER_PICTURE_URL : authorProf.picture,
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
            },
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    extractAsyncValue(tgtPostAuthor, (authorProf) => authorProf!.name, "unknown"),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(notifications.eventDataMap[event.tags[0][1]] != null
                        ? notifications.eventDataMap[event.tags[0][1]]!.content
                        : "",
                  ),
                  Align(
                    child: Text((Nip19.encodePubkey(event.pubkey).replaceAll("npub", "")).substring(0, 9) + "..."),
                    alignment: Alignment.centerRight,
                  ),
                  Align(
                    child: Text(DateFormat.Md().add_jm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                            event.createdAt * 1000))),
                    alignment: Alignment.centerRight,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                          Icons.favorite_border,
                          color: Colors.pinkAccent,
                      ),
                    ],
                  ),
                  Column(
                    // reacted user list
                    children: [
                      Align(
                        child: Text(
                            extractAsyncValue(reactedUser, (authorProf) => authorProf!.name, "unknown"),
                            style: const TextStyle(
                                color: Colors.pinkAccent)),
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                  classifyPostKind(notifications.eventDataMap[event.tags[0][1]]!) == POST_KIND.QUOTE_REPOST
                      ? buildChildCard(context, ref, notifications.eventDataMap[event.tags[0][1]]!)
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

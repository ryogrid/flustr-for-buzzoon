import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr/nostr.dart';
import 'package:intl/intl.dart';
import 'package:nostrp2p/controller/reaction_cache_provider/reaction_cache_notifier.dart';
import 'package:nostrp2p/external/np2p_api.dart';

import '../../const.dart';
import '../../controller/current_pubhex_provider/current_pubhex_provider.dart';
import '../../controller/current_sechex_provider/current_sechex_provider.dart';
import '../../controller/reaction_provider/reaction_provider.dart';
import '../../controller/servaddr_provider/servaddr_provider.dart';

class EventView extends ConsumerWidget {
  const EventView({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = ref.watch(profileProvider(event.pubkey));
    final pubHex = ref.watch(currentPubHexProvider);
    final secHex = ref.watch(currentSecHexProvider);
    final urls = ref.watch(servAddrSettingNotifierProvider.future);
    final reaction = ref.watch(reactionProvider(event.id));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            switch (author) {
              AsyncData(value: final authorProf) => Container(
                  clipBehavior: Clip.antiAlias,
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    authorProf.picture,
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
                    PrefKeys.noProfileUserPictureURL,
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
                    switch (author) {
                      AsyncData(value: final authorProf) => authorProf.name,
                      AsyncLoading() => 'loading',
                      AsyncError(:final error) => 'unknown', //error.toString(),
                      _ => "unkown",
                    },
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(event.content),
                  Align(
                    child: Text(event.pubkey.substring(0, 9) + "..."),
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
                      IconButton(
                        onPressed: () async {
                          var servAddrSettting = await urls;
                          var url = servAddrSettting.getServAddr!;
                          var _ = switch (reaction) {
                            AsyncData(value: final reactionVal) =>
                              // if already reacted, don't send reaction
                            // Np2pAPI.publishReaction(secHex!, pubHex!,
                            //     url, event.id, event.pubkey, "+"),
                              !reactionVal.pubHexs.contains(pubHex!)
                                  ? Np2pAPI.publishReaction(secHex!, pubHex!,
                                      url, event.id, event.pubkey, "+")
                                  : null,
                            AsyncValue() => null,
                          };
                        },
                        icon: Icon(
                          Icons.favorite_border,
                          color: switch (reaction) {
                            AsyncData(value: final reactionVal) =>
                              reactionVal.pubHexs.length > 0
                                  ? Colors.pinkAccent
                                  : Colors.grey,
                            AsyncValue() => Colors.grey,
                          },
                        ),
                      ),
                      Text(switch (reaction) {
                        AsyncData(value: final reactionVal) =>
                          reactionVal.pubHexs.length > 0
                              ? reactionVal.pubHexs.length.toString() + " "
                              : "  ",
                        AsyncValue() => "  ",
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

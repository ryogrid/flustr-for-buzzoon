import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr/nostr.dart';
import 'package:intl/intl.dart';

import '../../external/np2p_api.dart';
import '../../const.dart';
import '../../controller/current_pubhex_provider/current_pubhex_provider.dart';
import '../../controller/current_sechex_provider/current_sechex_provider.dart';
import '../../controller/reaction_provider/reaction_provider.dart';
import '../../controller/servaddr_provider/servaddr_provider.dart';
import '../../external/np2p_util.dart';
import '../screen/profile_screen.dart';
import '../screen/thread_screen.dart';
import './repost_button.dart';
import 'component_funcs.dart';

class PostCard extends ConsumerWidget {
  const PostCard(
      {Key? key,
      required this.event,
      required this.parentScreen,
      this.repostUserPubHex})
      : super(key: key);

  final Event event;
  final String parentScreen;
  final String? repostUserPubHex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = ref.watch(profileProvider(this.event.pubkey));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            this.parentScreen != "thread"
                ? this.buildPostAnnotation1(context, ref)
                : Container(),
            this.parentScreen != "thread"
                ? this.buildPostAnnotation2(context, ref)
                : Container(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAuthorPic(context, ref, this.event),
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
                      Text(this.event.content),
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
                      buildReplyAndLikeButton(context, ref),
                      buildReactedUserList(context, ref),
                      classifyPostKind(this.event) == POST_KIND.QUOTE_REPOST
                          ? buildChildCard(context, ref, this.event)
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPostAnnotation1(BuildContext context, WidgetRef ref) {
    return this.repostUserPubHex != null
        ? TextButton(
            child: Text(
              "Repost by " +
                  extractAsyncValue<ProfileData?, String>(
                      ref.watch(profileProvider(this.repostUserPubHex!)),
                      (prof) => prof!.name,
                      "unknown"),
              style: const TextStyle(color: Colors.blue),
            ),
            onPressed: () => {
              extractAsyncValue<ProfileData?, String>(
                          ref.watch(profileProvider(this.repostUserPubHex!)),
                          (prof) => prof!.name,
                          "unknown") !=
                      "unkown"
                  ? Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                          pubHex: this.repostUserPubHex!,
                        ),
                      ),
                    )
                  : null,
            },
          )
        : switch (classifyPostKind(this.event)) {
            POST_KIND.REPLY => TextButton(
                child: Text(
                  this.parentScreen == "notification"
                      ? "Go to reply thread"
                      : "Reply to " +
                          extractAsyncValue<ProfileData?, String>(
                              ref.watch(profileProvider(
                                  extractEAndPtags(this.event.tags)["p"]!
                                      .last[1])),
                              (prof) => prof!.name,
                              "unknown") +
                          "'s post",
                  style: const TextStyle(color: Colors.blue),
                ),
                onPressed: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ThreadScreen(event: this.event),
                    ),
                  ),
                },
              ),
            POST_KIND.MENTION => TextButton(
                child: Text(
                  "@" +
                      extractAsyncValue<ProfileData?, String>(
                          ref.watch(profileProvider(
                              extractEAndPtags(this.event.tags)["p"]!.last[1])),
                          (prof) => prof!.name,
                          "unknown"),
                  style: const TextStyle(color: Colors.blue),
                ),
                onPressed: () => {
                  extractAsyncValue<ProfileData?, String>(
                              ref.watch(profileProvider(
                                  extractEAndPtags(this.event.tags)["p"]!
                                      .last[1])),
                              (prof) => prof!.name,
                              "unknown") !=
                          "unkown"
                      ? Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                              pubHex: extractEAndPtags(this.event.tags)["p"]!
                                  .last[1],
                            ),
                          ),
                        )
                      : null,
                },
              ),
            _ => Container(),
          };
  }



  Widget buildPostAnnotation2(BuildContext context, WidgetRef ref) {
    return switch (classifyPostKind(this.event)) {
      POST_KIND.REPLY => const SizedBox(height: 4),
      POST_KIND.MENTION => const SizedBox(height: 4),
      _ => Container(),
    };
  }

  Widget buildReplyAndLikeButton(BuildContext context, WidgetRef ref) {
    final pubHex = ref.watch(currentPubHexProvider);
    final secHex = ref.watch(currentSecHexProvider);
    final urls = ref.watch(servAddrSettingNotifierProvider.future);
    final reaction = ref.watch(reactionProvider(this.event.id));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          // reply button
          onPressed: () async {
            showPostDialog(ref, context, "Send reply post",
                (ref, ctx, sendText) {
              final secHex = ref.watch(currentSecHexProvider);
              final pubHex = ref.watch(currentPubHexProvider);
              final servAddr = ref.watch(servAddrSettingNotifierProvider);

              final _ = switch (servAddr) {
                AsyncData(value: final servAddr) => Np2pAPI.publishPost(
                    secHex!,
                    pubHex!,
                    servAddr.getServAddr!,
                    sendText,
                    constructSpecialPostTags(ref, this.event)),
                _ => null,
              };
              Navigator.of(ctx).pop();
            });
          },
          icon: Icon(
            Icons.reply,
            color: Colors.grey,
          ),
        ),
        RepostButton(event: this.event),
        IconButton(
          // like button
          onPressed: () async {
            var servAddrSettting = await urls;
            var url = servAddrSettting.getServAddr!;
            var _ = switch (reaction) {
              AsyncData(value: final reactionVal) =>
                // if already reacted, don't send reaction
                !reactionVal.pubHexs.contains(pubHex!)
                    ? Np2pAPI.publishReaction(secHex!, pubHex!, url,
                        this.event.id, this.event.pubkey, "+")
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
          AsyncData(value: final reactionVal) => reactionVal.pubHexs.length > 0
              ? reactionVal.pubHexs.length.toString() + " "
              : "  ",
          AsyncValue() => "  ",
        }),
      ],
    );
  }

  Widget buildReactedUserList(BuildContext context, WidgetRef ref) {
    final reaction = ref.watch(reactionProvider(this.event.id));

    return Column(
      // reacted user list
      children: switch (reaction) {
        AsyncData(value: final reactionVal) => reactionVal.pubHexs
            .map((e) => Align(
                  child: Text(
                      switch (ref.watch(profileProvider(e))) {
                        AsyncData(value: final authorProf) => authorProf == null
                            ? e.substring(0, 9) + "..."
                            : authorProf.name + " ",
                        _ => e.substring(0, 9) + "..."
                      },
                      style: const TextStyle(color: Colors.pinkAccent)),
                  alignment: Alignment.centerRight,
                ))
            .toList(),
        _ => [],
      },
    );
  }


}

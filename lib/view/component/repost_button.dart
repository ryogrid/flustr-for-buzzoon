import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr/nostr.dart';

import '../../external/np2p_api.dart';
import '../../controller/current_pubhex_provider/current_pubhex_provider.dart';
import '../../controller/current_sechex_provider/current_sechex_provider.dart';
import '../../controller/servaddr_provider/servaddr_provider.dart';
import '../../external/np2p_util.dart';

class RepostButton extends ConsumerWidget {
  const RepostButton({Key? key, required this.event})
      : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => SimpleDialog(
              children: <Widget>[
                SimpleDialogOption( // Repost
                  onPressed: () {
                    final servAddr = ref.watch(servAddrSettingNotifierProvider);
                    final pubHex = ref.watch(currentPubHexProvider);
                    final secHex = ref.watch(currentSecHexProvider);

                    final _ = switch (servAddr) {
                      AsyncData(value: final servAddr) =>
                          this.sendRepostEvent(servAddr.getServAddr!, secHex!, pubHex!, this.event),
                      _ => print("no value"),//null,
                    };
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Repost'),
                ),
                SimpleDialogOption( // Quote Repost
                  onPressed: () {
                    showQuoteRepostDialog(ref, ctx);
                  },
                  child: const Text('Quote Repost'),
                ),
              ],
            ),
          );
        },
        icon: Icon(
          Icons.autorenew,
          color: Colors.grey,
        ),
    );
  }

  void showQuoteRepostDialog(WidgetRef ref, BuildContext context) {
    final pubHex = ref.watch(currentPubHexProvider);
    final secHex = ref.watch(currentSecHexProvider);
    final servAddr = ref.watch(servAddrSettingNotifierProvider);

    showPostDialog(ref, context, "Send quote repost",
          (ref, ctx, sendText) {
        final _ = switch (servAddr) {
          AsyncData(value: final servAddr) =>
              Np2pAPI.publishPost(
                  secHex!, pubHex!, servAddr.getServAddr!, sendText, [
                ["e", this.event.id, "", "mention"],
                ["p", this.event.pubkey],
                ["q"], // mark as quote repost
              ]),
          _ => null,
        };
        Navigator.of(ctx).pop();
        Navigator.of(ctx).pop();
      });

  }

  void sendRepostEvent(String url, String secHex, String pubHex, Event destEvt) {
    print("sendRepostEvent called.");
    var evtStr = destEvt.serialize();
    Np2pAPI.publishPost(secHex, pubHex, url, evtStr,
      [
        ["e", destEvt.id, ""],
        ["p", destEvt.pubkey],
      ],
      6 // mark as repost
    );
  }

}
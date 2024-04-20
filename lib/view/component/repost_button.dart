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
        onPressed: () async {
          // do nothing
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
    final servAddr = ref.watch(servAddrSettingNotifierProvider.future);

    showPostDialog(ref, context, "Send quote repost",
          (ref, ctx, sendText) {
        showPostDialog(
            ref, context, "Send mention", (ref, ctx, sendText) {
          final _ = switch (servAddr) {
            AsyncData(value: final servAddr) =>
                Np2pAPI.publishPost(
                    secHex!, pubHex!, servAddr.getServAddr!, sendText, [
                  ["p", this.event.pubkey]
                ]),
            _ => null,
          };
          Navigator.of(ctx).pop();
        });
      },
    );
  }
}
import 'package:nostrp2p/controller/current_pubhex_provider/current_pubhex_provider.dart';
import 'package:nostrp2p/controller/current_sechex_provider/current_sechex_provider.dart';
import 'package:nostrp2p/controller/servaddr_provider/servaddr_provider.dart';
import 'package:nostrp2p/external/np2p_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrp2p/external/np2p_util.dart';

class PostingButton extends ConsumerWidget {
  const PostingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
        onPressed: () {
          showPostDialog(ref, context, (ref, ctx, sendText) {
            final secHex = ref.watch(currentSecHexProvider);
            final pubHex = ref.watch(currentPubHexProvider);
            final servAddr = ref.watch(servAddrSettingNotifierProvider);

            final _ = switch (servAddr) {
              AsyncData(value: final servAddr) => Np2pAPI.publishPost(secHex!, pubHex!, servAddr.getServAddr!, sendText),
              _ => null,
            };
            Navigator.of(ctx).pop();
          });
        },
        child: const Icon(Icons.add),
      );
  }
}
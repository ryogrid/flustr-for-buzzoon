import 'package:nostrp2p/controller/current_pubhex_provider/current_pubhex_provider.dart';
import 'package:nostrp2p/controller/current_sechex_provider/current_sechex_provider.dart';
import 'package:nostrp2p/controller/servaddr_provider/servaddr_provider.dart';
import 'package:nostrp2p/external/np2p_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var _textToSend = '';

class PostingButton extends ConsumerWidget {
  const PostingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final secHex = ref.watch(currentSecHexProvider);
    final pubHex = ref.watch(currentPubHexProvider);
    final servAddr = ref.watch(servAddrSettingNotifierProvider);

    return FloatingActionButton(
        onPressed: () {
          showGeneralDialog(
            context: context,
            pageBuilder: (ctx, _, __) => Material(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('send text event'),
                    TextField(
                      onChanged: (value) {
                        _textToSend = value;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (secHex == null) {
                          return;
                        }
                        final _ = switch (servAddr) {
                          AsyncData(value: final servAddr) => Np2pAPI.publishPost(secHex!, pubHex!, servAddr.getServAddr!, _textToSend),
                          _ => null,
                        };
                        _textToSend = '';
                        Navigator.of(ctx).pop();
                      },
                      child: const Text('send!'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('go back'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      );
  }
}
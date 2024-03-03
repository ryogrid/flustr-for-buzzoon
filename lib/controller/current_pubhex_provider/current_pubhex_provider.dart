import 'package:nostrp2p/controller/setting_provider/setting_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_pubhex_provider.g.dart';

@Riverpod(keepAlive: true)
String? currentPubHex(CurrentPubHexRef ref) {
  final settings = ref.watch(settingNotifierProvider);
  final pubHex = switch (settings) {
    AsyncData(:final value) => value.hexPubKey,
    _ => null,
  };
  return pubHex;
}

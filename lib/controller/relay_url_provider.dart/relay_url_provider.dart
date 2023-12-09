import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_url_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<String>> relayUrl(RelayUrlRef ref) async {
  return ['wss://relay-jp.nostr.wirednet.jp/', 'wss://relay.damus.io'];
}

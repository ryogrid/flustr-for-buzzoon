import 'package:buzzoon/controller/current_pubhex_provider/current_pubhex_provider.dart';
import 'package:buzzoon/external/connection_pool.dart';
import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'relay_url_provider.g.dart';

final _tmpRelays = [
  'wss://yabu.me/'
  //'wss://relay-jp.nostr.wirednet.jp/',
  //'wss://relay.nostr.wirednet.jp/',
  'wss://relay.damus.io',
  'wss://nos.lol',
];

@Riverpod(keepAlive: true)
FutureOr<List<String>> relayUrl(RelayUrlRef ref) async {
  // final pubHex = ref.watch(currentPubHexProvider);
  // if (pubHex == null) {
  //   return _tmpRelays;
  // }
  // final tmpPool = ConnectionPool(
  //   _tmpRelays,
  // );
  // final rawEvents = await tmpPool.getStoredEvent(
  //   [
  //     Filter(
  //       authors: [pubHex],
  //       kinds: [10002],
  //       limit: 1,
  //     ),
  //   ],
  // );
  // final urls = rawEvents.first.tags
  //     .where((element) => element.length == 2)
  //     .map((e) => e[1])
  //     .toList();
  // return urls;
  return ["http://localhost:20001/"];
}

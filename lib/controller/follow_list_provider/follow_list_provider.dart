import 'package:collection/collection.dart';
import 'package:flustr/controller/connection_pool_provider/connection_pool_provider.dart';
import 'package:flustr/controller/current_pubhex_provider/current_pubhex_provider.dart';
import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_list_provider.g.dart';

@Riverpod(keepAlive: true)
//FutureOr<List<String>> followList(FollowListRef ref) async {
Future<List<String>> followList(FollowListRef ref) async {
    //final pool = await ref.watch(connectionPoolProvider.future);

    final pubHex = ref.watch(currentPubHexProvider);
    if (pubHex == null) {
      throw Exception('not logged in!');
    }

    // final rawEvents = await pool.getStoredEvent(
    //   [
    //     Filter(
    //       kinds: [3],
    //       authors: [pubHex],
    //     ),
    //   ],
    //   timeout: const Duration(seconds: 5),
    // );
    // final followeesPubHex = rawEvents
    //     .map(
    //       (e) => e.tags
    //           .where((element) => element.first == 'p')
    //           .map((e) => e[1])
    //           .toList(),
    //     )
    //     .flattened
    //     .toList();
    final followeesPubHex = <String>[];
    return Future(() => followeesPubHex);
}


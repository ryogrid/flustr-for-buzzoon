import 'package:nostrp2p/controller/current_pubhex_provider/current_pubhex_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_list_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> followList(FollowListRef ref) async {
    final pubHex = ref.watch(currentPubHexProvider);
    if (pubHex == null) {
      throw Exception('not logged in!');
    }

    final followeesPubHex = <String>[];
    return Future(() => followeesPubHex);
}


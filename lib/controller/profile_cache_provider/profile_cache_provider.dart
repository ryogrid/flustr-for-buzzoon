import 'package:buzzoon/controller/connection_pool_provider/connection_pool_provider.dart';
import 'package:buzzoon/controller/follow_list_provider/follow_list_provider.dart';
import 'package:buzzoon/controller/profile_provider/profile_provider.dart';
import 'package:nostr/nostr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_cache_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<ProfileData>> profileCache(ProfileCacheRef ref) async {
  final followees = await ref.watch(followListProvider.future);
  final pool = await ref.watch(connectionPoolProvider.future);
  final result = await pool.getStoredEvent(
    [
      Filter(authors: followees, kinds: [0], limit: followees.length),
    ],
    timeout: const Duration(seconds: 30),
  );
  try {
    final profiles = result.map((e) => ProfileData.fromEvent(e)).toList();
    return profiles;
  } catch (e) {
    // do nothing
  }
  throw Exception('profile not found.');
}

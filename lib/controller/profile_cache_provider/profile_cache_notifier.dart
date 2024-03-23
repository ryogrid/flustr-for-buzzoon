import 'package:nostrp2p/controller/connection_pool_provider/connection_pool_provider.dart';
import 'package:nostrp2p/controller/follow_list_provider/follow_list_provider.dart';
import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:nostrp2p/controller/timeline_posts_notifier/timeline_posts_notifier.dart';
import 'package:nostrp2p/controller/user_posts_notifier/user_posts_notifier.dart';
import 'package:nostr/nostr.dart';
import 'package:riverpod/src/framework.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../external/np2p_api.dart';

part 'profile_cache_notifier.g.dart';

class ProfileDataRepository {
  static final ProfileDataRepository _singleton = ProfileDataRepository._internal();
  factory ProfileDataRepository() {
    return _singleton;
  }
  ProfileDataRepository._internal();

  List<ProfileData> profiles = <ProfileData>[];
  Map<String, ProfileData> profileMap = <String, ProfileData>{};
}

@riverpod
class ProfileCacheNotifier extends _$ProfileCacheNotifier {
  ProfileDataRepository profileRepo = ProfileDataRepository();

  @override
  ProfileDataRepository build() {
    return this.profileRepo;
  }

  ProfileData fetchProfile(String pubHex) {
    Np2pAPI.getProfile(pubHex);

    print(pubHex);
    return this.profileRepo.profileMap[pubHex]!;
  }
/*
  @Riverpod(keepAlive: true)
  Future<List<ProfileData>> profileCache(ProfileCacheRef ref) async {
    // final followees = await ref.watch(followListProvider.future);
    //final pool = await ref.watch(connectionPoolProvider.future);
    //final posts = await ref.read(timelinePostsNotifierProvider.notifier);

    // for trigger refresh

    // var postDatas = posts.state.asData;
    //var retProfs = <ProfileData>[];
    // if (postDatas != null) {
    //   for (var postData in postDatas.value) {
    //     if (pool.profileMap[postData.pubkey] != null) {
    //       retProfs.add(pool.profileMap[postData.pubkey]!);
    //     }
    //   }
    // }

    // final result = await pool.getStoredEvent(
    //   [
    //     Filter(authors: followees, kinds: [0], limit: followees.length),
    //   ],
    //   timeout: const Duration(seconds: 30),
    // );
    // try {
    //   final profiles = result.map((e) => ProfileData.fromEvent(e)).toList();
    //   return profiles;
    // } catch (e) {
    //   // do nothing
    // }
    // throw Exception('profile not found.');

    //return Future(() => <ProfileData>[]);

    //return pool.profiles;
    //return retProfs;
    return profiles
    .
  }
*/
}
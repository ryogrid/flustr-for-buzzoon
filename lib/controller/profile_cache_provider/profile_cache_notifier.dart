import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
}
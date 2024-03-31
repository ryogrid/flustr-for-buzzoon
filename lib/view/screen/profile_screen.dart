import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/current_pubhex_provider/current_pubhex_provider.dart';
import '../../controller/current_sechex_provider/current_sechex_provider.dart';
import '../../controller/servaddr_provider/servaddr_provider.dart';
import '../component/profile_header.dart';
import '../component/profile_setting.dart';

// final _loadButtonLoadingProvider = StateProvider((ref) => false);

// for profile editing
final _profileEditableProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({
    Key? key,
    required this.pubHex,
  }) : super(key: key);

  final String pubHex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider(this.pubHex));
    // final rawPosts = ref.watch(UserPostsNotifierProvider(pubHex));
    // final rawPostsController =
    //     ref.watch(UserPostsNotifierProvider(pubHex).notifier);
    // final loadingOld = ref.watch(_loadButtonLoadingProvider);
    final urls = ref.watch(servAddrSettingNotifierProvider);
    final isProfileEditable = ref.watch(_profileEditableProvider);
    final secHex = ref.watch(currentSecHexProvider);
    final selfPubHex = ref.watch(currentPubHexProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: switch (profile) {
            AsyncData(value: final profile) => isProfileEditable ||
                    profile == null // when "edit profile" button is pressed
                ? switch (urls) {
                    AsyncData(value: final urladdr) => ProfileSetting(
                        url: urladdr.getServAddr!,
                        pubHex: this.pubHex,
                        secHex: secHex!,
                        name: profile == null ? "" : profile.name,
                        about: profile == null ? "" : profile.about,
                        picture: profile == null ? "" : profile.picture),
                    AsyncValue() => Text('Oops! something went wrong'),
                  }
                : ListView(
                    children: [
                      // app bar
                      ProfileHeader(profile: profile),
                      this.pubHex == selfPubHex!
                          ? TextButton(
                              onPressed: () async {
                                ref
                                    .read(_profileEditableProvider.notifier)
                                    .state = true;
                              },
                              child: const Text('edit profile'),
                            )
                          : const SizedBox(),
                      // // 投稿を出すところ
                      // ...switch (rawPosts) {
                      //   AsyncData(value: final posts) =>
                      //     posts.map((e) => EventView(event: e)),
                      //   AsyncError(:final error, :final stackTrace) => [
                      //       Text(error.toString()),
                      //       Text(stackTrace.toString()),
                      //     ],
                      //   AsyncLoading() => [const LinearProgressIndicator()],
                      //   _ => [],
                      // },
                      //
                      // TextButton(
                      //   onPressed: loadingOld
                      //       ? null
                      //       : () async {
                      //           ref
                      //               .read(_loadButtonLoadingProvider.notifier)
                      //               .state = true;
                      //           await rawPostsController.loadOlderPosts();
                      //           ref
                      //               .read(_loadButtonLoadingProvider.notifier)
                      //               .state = false;
                      //         },
                      //   child: const Text('load more'),
                      // ),
                    ],
                  ),

            // loading indicator
            AsyncLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            AsyncError(error: final error, stackTrace: final _) => switch (
                  urls) {
                AsyncData(value: final urladdr) => ProfileSetting(
                    url: urladdr.getServAddr!,
                    pubHex: pubHex,
                    secHex: secHex!,
                    name: "",
                    about: "",
                    picture: ""),
                AsyncValue() => Text('Oops! something went wrong'),
              },
            AsyncValue() => switch (urls) {
                AsyncData(value: final urladdr) => ProfileSetting(
                    url: urladdr.getServAddr!,
                    pubHex: pubHex,
                    secHex: secHex!,
                    name: "",
                    about: "",
                    picture: ""),
                AsyncValue() => Text('Oops! something went wrong'),
              },
          },
        ),
      ),
    );
  }
}

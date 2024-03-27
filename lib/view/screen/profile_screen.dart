import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:nostrp2p/controller/user_posts_notifier/user_posts_notifier.dart';
import 'package:nostrp2p/view/component/copyable_pubkey.dart';
import 'package:nostrp2p/view/component/event_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/current_sechex_provider/current_sechex_provider.dart';
import '../../controller/servaddr_provider/servaddr_provider.dart';
import '../../external/np2p_api.dart';
import '../component/section.dart';

// final _loadButtonLoadingProvider = StateProvider((ref) => false);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({
    Key? key,
    required this.pubHex,
  }) : super(key: key);

  final String pubHex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider(pubHex));
    // final rawPosts = ref.watch(UserPostsNotifierProvider(pubHex));
    // final rawPostsController =
    //     ref.watch(UserPostsNotifierProvider(pubHex).notifier);
    // final loadingOld = ref.watch(_loadButtonLoadingProvider);
    final urls = ref.watch(servAddrSettingNotifierProvider);
    final isProfileEditable = ref.watch(_profileEditableProvider);
    final secHex = ref.watch(currentSecHexProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: switch (profile) {
            AsyncData(value: final profile) => isProfileEditable || profile == null // when "edit profile" button is pressed
                ? switch (urls) {
                    AsyncData(value: final urladdr) => ProfileSetting(
                        url: urladdr.getServAddr!,
                        pubHex: pubHex,
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
                      TextButton(
                        onPressed: () async {
                          ref.read(_profileEditableProvider.notifier).state =
                              true;
                        },
                        child: const Text('edit profile'),
                      ),

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

// widget displays icon, user name and pubkey
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profile});

  final ProfileData profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),

        // user icon
        Container(
          clipBehavior: Clip.antiAlias,
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.network(
            profile.picture,
          ),
        ),

        // text under icon
        Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: theme.colorScheme.background),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // unser name
              Text(
                profile.name,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 24,
                ),
              ),

              // pubkey with copy button
              CopyablePubkey(pubkey: profile.pubHex),

              // about
              Text(profile.about),
            ],
          ),
        ),
      ],
    );
  }
}

// for profile editing
final _profileEditableProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

class ProfileSetting extends ConsumerWidget {
  ProfileSetting(
      {Key? key,
      required this.url,
      required this.pubHex,
      required this.secHex,
      required this.name,
      required this.about,
      required this.picture})
      : super(key: key);

  String url;
  String pubHex;
  String secHex;
  String name;
  String about;
  String picture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Center(
          child: const Section(
            title: 'Profile Setting',
            content: [],
          ),
        ),
        const SizedBox(height: 60),
        Align(
          alignment: Alignment.centerLeft,
          child: Section(
            title: 'name',
            content: [
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      initialValue: this.name,
                      onChanged: (value) {
                        this.name = value;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.centerLeft,
          child: Section(
            title: 'about',
            content: [
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      initialValue: this.about,
                      onChanged: (value) {
                        this.about = value;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.centerLeft,
          child: Section(
            title: 'picture (url)',
            content: [
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      initialValue: this.picture,
                      onChanged: (value) {
                        this.picture = value;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              final trimmedName = this.name.trim();
              final trimmedAbout = this.about.trim();
              final trimmedPicture = this.picture.trim();
              Np2pAPI.publishProfile(this.url, this.pubHex, this.secHex, trimmedName,
                  trimmedAbout, trimmedPicture);
            },
            child: const Text('save'),
          ),
        ),
      ],
    );
  }
}

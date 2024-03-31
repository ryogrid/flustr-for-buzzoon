import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:nostrp2p/external/np2p_api.dart';
import 'package:nostrp2p/view/component/copyable_pubkey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/current_pubhex_provider/current_pubhex_provider.dart';
import '../../controller/current_sechex_provider/current_sechex_provider.dart';
import '../../controller/follow_list_provider/follow_list_provider.dart';
import '../../controller/servaddr_provider/servaddr_provider.dart';

// widget displays icon, user name and pubkey
class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key, required this.profile});

  final ProfileData profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final followList = ref.watch(followListProvider(this.profile.pubHex));
    final secHex = ref.watch(currentSecHexProvider);
    final pubHex = ref.watch(currentPubHexProvider);
    final url = ref.watch(servAddrSettingNotifierProvider);

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
              TextButton(
                onPressed: followList.where((element) => element[1] == profile.pubHex).length > 0 ?
                    () {
                      final newList = followList.toSet().toList();
                      newList.removeWhere((element) => element[1] == profile.pubHex);
                      print(newList);
                      final _ = switch (url) {
                        AsyncData(value: final servAddr) => Np2pAPI.publishFollowList(secHex!, pubHex!, servAddr.getServAddr!, newList),
                        _ => null,
                      };
                    } :
                    () {
                      final newList = followList.toSet().toList();
                      newList.add(["p", profile.pubHex, "", ""]);
                      print(newList);
                      final _ = switch (url) {
                        AsyncData(value: final servAddr) => Np2pAPI.publishFollowList(secHex!, pubHex!, servAddr.getServAddr!, newList),
                        _ => null,
                      };
                    },
                child: followList.where((element) => element[1] == profile.pubHex).length > 0 ?  Text("Unfollow " + profile.name) : Text("Follow " + profile.name),
              )
            ],
          ),
        ),
      ],
    );
  }
}
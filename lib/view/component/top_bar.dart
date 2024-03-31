import 'package:nostrp2p/controller/current_pubhex_provider/current_pubhex_provider.dart';
import 'package:nostrp2p/view/screen/profile_screen.dart';
import 'package:nostrp2p/view/screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopBar extends ConsumerWidget implements PreferredSizeWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pubHex = ref.watch(currentPubHexProvider);
    // final secHex = ref.watch(currentSecHexProvider);
    // final timelinePosts = ref.watch(timelinePostsNotifierProvider);
    // final isSeckeyAvailable = ref.watch(isSeckeyAvailableProvider);
    // final servAddr = ref.watch(servAddrSettingNotifierProvider);
    // final evtTimer = ref.watch(eventDataGettingTimerProvider);

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: IconButton(
        // navigate to my profile
        onPressed: () {
          if (pubHex != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProfileScreen(pubHex: pubHex),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('provide your key in settings'),
              ),
            );
          }
        },
        icon: Icon(
          Icons.person,
          color: Theme.of(context).primaryIconTheme.color,
        ),
      ),
      actions: [
        IconButton(
          // navigate to setting page
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingScreen()),
            );
          },
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).primaryIconTheme.color,
          ),
        ),
      ],
    );
  }
}
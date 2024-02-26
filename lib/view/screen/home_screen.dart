import 'package:flustr/controller/connection_pool_provider/connection_pool_provider.dart';
import 'package:flustr/controller/current_pubhex_provider/current_pubhex_provider.dart';
import 'package:flustr/controller/current_sechex_provider/current_sechex_provider.dart';
import 'package:flustr/controller/is_seckey_available_provider/is_seckey_available_provider.dart';
import 'package:flustr/controller/timeline_posts_notifier/timeline_posts_notifier.dart';
import 'package:flustr/external/connection_pool.dart';
import 'package:flustr/view/component/event_view.dart';
import 'package:flustr/view/screen/profile_screen.dart';
import 'package:flustr/view/screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var _textToSend = '';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pubHex = ref.watch(currentPubHexProvider);
    final secHex = ref.watch(currentSecHexProvider);
    final timelinePosts = ref.watch(timelinePostsNotifierProvider);
    final isSeckeyAvailable = ref.watch(isSeckeyAvailableProvider);
    //final pool = ref.watch(connectionPoolProvider);

    return Scaffold(
      // 投稿ボタン
      floatingActionButton: isSeckeyAvailable
          ? FloatingActionButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (ctx, _, __) => Material(
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('send text event'),
                          TextField(
                            onChanged: (value) {
                              _textToSend = value;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (secHex == null) {
                                return;
                              }
                              // TODO: need to modify posting Text event code (HomeScreen::onPressed)
                              final _ = switch (pool) {
                                AsyncData(value: final pool) => pool.addEvent(
                                    buildTextEvent(_textToSend, secHex),
                                  ),
                                _ => null,
                              };
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('send!'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('go back'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      appBar: AppBar(
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
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(timelinePostsNotifierProvider),
        child: ListView(
          children: switch (timelinePosts) {
            AsyncLoading() => [const LinearProgressIndicator()],
            AsyncError(:final error, :final stackTrace) => [
                Text(error.toString()),
                Text(stackTrace.toString()),
              ],
            AsyncData(value: final posts) =>
              posts.map((e) => EventView(event: e)).toList(),
            _ => [const Text('Oops! something went wrong!')],
          },
        ),
      ),
    );
  }
}

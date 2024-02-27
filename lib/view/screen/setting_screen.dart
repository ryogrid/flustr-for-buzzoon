import 'package:buzzoon/controller/setting_provider/setting_provider.dart';
import 'package:buzzoon/view/component/section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// テキストフィールドの内容を保持しておく
String _textFieldContent = '';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawSettings = ref.watch(settingNotifierProvider);
    final settingsController = ref.watch(settingNotifierProvider.notifier);

    // keyがあれば入れる。なければnull
    final currentKey = switch (rawSettings) {
      AsyncData(:final value) => switch (value) {
          NpubAppSetting(:final npub1) => npub1,
          NsecAppSetting(:final nsec1) => nsec1,
          _ => null
        },
      _ => null
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('settings'),
      ),
      body: switch (rawSettings) {
        AsyncLoading() => const Center(
            child: Text('loading...'),
          ),
        AsyncData(value: final settings) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 鍵の状態表示
                Align(
                  alignment: Alignment.centerLeft,
                  child: Section(
                    title: 'key status',
                    content: [
                      Text(
                        'secret key available: ${settings.getNsec1 != null}',
                      ),
                      Text(
                        'public key available: ${settings.getNpub1() != null}',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // 現在の鍵を表示（保存されていれば）
                if (currentKey != null) _CurrentKey(currentKey: currentKey),

                // 鍵入力
                Align(
                  alignment: Alignment.centerLeft,
                  child: Section(
                    title: 'save/update key',
                    content: [
                      TextField(
                        onChanged: (value) {
                          _textFieldContent = value;
                          debugPrint(value);
                        },
                      ),
                      const SizedBox(width: 50),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            final trimmed = _textFieldContent.trim();
                            final valid = validateKey(trimmed);
                            if (valid) {
                              settingsController.setKey(trimmed);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('invalid key was given.'),
                                ),
                              );
                            }
                          },
                          child: const Text('save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        AsyncError(error: _, stackTrace: _) => const Center(
            child: Text('an error occurred'),
          ),
        AsyncValue() => const Center(
            child: Text('hogehoge~'),
          ),
      },
    );
  }
}

// _CurrentKey widgetで使う
final _keyVisibleProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

// 渡されたキーを表示する
// nsec1とか見られたくないし、デフォルトではマスクしておく
class _CurrentKey extends ConsumerWidget {
  const _CurrentKey({Key? key, required this.currentKey}) : super(key: key);

  final String currentKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKeyVisible = ref.watch(_keyVisibleProvider);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Section(
            title: 'current key',
            content: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      isKeyVisible
                          ? currentKey
                          : currentKey.replaceAll(RegExp(r'.'), 'x'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // toggle
                      ref.read(_keyVisibleProvider.notifier).state =
                          !isKeyVisible;
                    },
                    icon: Icon(
                      isKeyVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

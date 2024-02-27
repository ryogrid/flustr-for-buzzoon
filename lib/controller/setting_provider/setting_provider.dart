import 'package:buzzoon/const.dart';
import 'package:nostr/nostr.dart';
import 'package:bip340/bip340.dart' as bip340;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'setting_provider.freezed.dart';
part 'setting_provider.g.dart';

// run this to generate code
// dart run build_runner build

// AppSettingは、npub1とnsec1で実クラスを分ける

@freezed
sealed class AppSetting with _$AppSetting {
  factory AppSetting.nsec({
    required String nsec1,
  }) = NsecAppSetting;
  factory AppSetting.npub({
    required String npub1,
  }) = NpubAppSetting;
  factory AppSetting.empty() = EmptyAppSetting;

  const AppSetting._();

  factory AppSetting.fromKey(String key) {
    if (key.startsWith('nsec1')) {
      return NsecAppSetting(nsec1: key);
    }
    if (key.startsWith('npub1')) {
      return NpubAppSetting(npub1: key);
    }
    return AppSetting.empty();
  }

  String? get getNsec1 => switch (this) {
        NsecAppSetting(nsec1: final key) => key,
        _ => null,
      };

  String? getNpub1() {
    try {
      final result = switch (this) {
        NsecAppSetting(nsec1: _) =>
          hexSecKey != null ? Nip19.encodePubkey(bip340.getPublicKey(hexSecKey!)) : null,
        NpubAppSetting(npub1: final String key) => key,
        _ => null,
      };
      return result;
    } catch (_) {
      // 何か問題があればnullを返す
      return null;
    }
  }

  String? get hexSecKey => switch (this) {
        NsecAppSetting(nsec1: final String key) => Nip19.decodePrivkey(key),
        _ => null,
      };

  String? get hexPubKey =>
      getNpub1() != null ? Nip19.decodePubkey(getNpub1()!) : null;

  factory AppSetting.fromJson(Map<String, dynamic> json) =>
      _$AppSettingFromJson(json);
}

@Riverpod(keepAlive: true)
class SettingNotifier extends _$SettingNotifier {
  @override
  Future<AppSetting> build() async {
    final pref = await SharedPreferences.getInstance();
    final key = pref.getString(PrefKeys.npubOrNsecKey);
    if (!validateKey(key)) {
      return AppSetting.empty();
    }
    return AppSetting.fromKey(key!);
  }

  // npub, nsecに関わらず鍵をセット
  void setKey(String key) {
    final valid = validateKey(key);
    if (!valid) {
      return;
    }
    state = AsyncData(AppSetting.fromKey(key));

    // shared preferenceに保存
    SharedPreferences.getInstance().then((pref) async {
      await pref.setString(PrefKeys.npubOrNsecKey, key);
    });
  }
}

bool validateKey(String? input) {
  if (input == null) {
    return false;
  }
  try {
    if (!input.startsWith(RegExp(r'npub1|nsec1'))) {
      return false;
    }
    if (input.startsWith('nsec1')) {
      final hex = Nip19.decodePrivkey(input);
      final _ = bip340.getPublicKey(hex);
    }
    if (input.startsWith('npub1')) {
      final _ = Nip19.decodePubkey(input);
    }
    return true;
  } catch (_) {
    return false;
  }
}

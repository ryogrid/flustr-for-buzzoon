import 'package:nostr/nostr.dart';
import 'package:bip340/bip340.dart' as bip340;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting_provider.freezed.dart';
part 'setting_provider.g.dart';

// run this to generate code
// dart run build_runner build

// AppSettingは、npub1とnsec1で実クラスを分ける

@freezed
sealed class AppSetting with _$AppSetting {
  factory AppSetting.nsec({
    String? nsec1,
  }) = NsecAppSetting;
  factory AppSetting.npub({
    String? npub1,
  }) = NpubAppSetting;

  const AppSetting._();

  String? get getNsec1 => switch (this) {
        NsecAppSetting(nsec1: final key) => key,
        _ => null,
      };

  String? getNpub1() {
    try {
      final result = switch (this) {
        NsecAppSetting(nsec1: final String key) => bip340.getPublicKey(key),
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

@riverpod
class SettingNotifier extends _$SettingNotifier {
  @override
  AppSetting? build() {
    // 依存先がないので書き変わらない = 初回しか実行されない
    return null;
  }

  // npub, nsecに関わらず鍵をセット
  void setKey(String key) {
    if (key.startsWith('nsec1')) {
      state = NsecAppSetting(nsec1: key);
    }
    if (key.startsWith('npub1')) {
      state = NpubAppSetting(npub1: key);
    }
  }
}

bool validateKey(String input) {
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

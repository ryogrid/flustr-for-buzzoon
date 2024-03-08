import 'package:nostrp2p/const.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'servaddr_provider.freezed.dart';
part 'servaddr_provider.g.dart';

// run this to generate code
// dart run build_runner build

@freezed
sealed class ServAddrSetting with _$ServAddrSetting {
  factory ServAddrSetting.servAddr({
    required String servAddr,
  }) = ImplServAddrSetting;
  factory ServAddrSetting.empty() = EmptyServAddrSetting;

  const ServAddrSetting._();

  factory ServAddrSetting.fromAddr(String addr) {
    if (addr.startsWith('http')) {
      return ImplServAddrSetting(servAddr: addr);
    }
    return ServAddrSetting.empty();
  }

  String? get getServAddr => switch (this) {
    ImplServAddrSetting(servAddr: final key) => key,
    _ => null,
  };


  factory ServAddrSetting.fromJson(Map<String, dynamic> json) =>
      _$ServAddrSettingFromJson(json);
}

@Riverpod(keepAlive: true)
class ServAddrSettingNotifier extends _$ServAddrSettingNotifier {
  @override
  Future<ServAddrSetting> build() async {
    final pref = await SharedPreferences.getInstance();
    final addr = pref.getString(PrefKeys.servAddr);
    return ServAddrSetting.fromAddr(addr!);
  }

  void saveAddr(String addr) {
    state = AsyncData(ServAddrSetting.servAddr(servAddr: addr));

    // shared preferenceに保存
    SharedPreferences.getInstance().then((pref) async {
      await pref.setString(PrefKeys.servAddr, addr);
    });
  }
}

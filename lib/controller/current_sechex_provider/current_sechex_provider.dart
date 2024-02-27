import 'package:buzzoon/controller/setting_provider/setting_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_sechex_provider.g.dart';

@riverpod
String? currentSecHex(CurrentSecHexRef ref) {
  final settings = ref.watch(settingNotifierProvider);
  final sechex = switch (settings) {
    AsyncData(value: final settings) => settings.hexSecKey,
    _ => null,
  };
  return sechex;
}

import 'package:buzzoon/controller/setting_provider/setting_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_seckey_available_provider.g.dart';

@riverpod
bool isSeckeyAvailable(IsSeckeyAvailableRef ref) {
  final settings = ref.watch(settingNotifierProvider);
  final result = switch (settings) {
    AsyncData(:final value) => switch (value) {
      NsecAppSetting(nsec1: final _) => true,
      _ => false,
    },
    _ => false,
  };
  return result;
}

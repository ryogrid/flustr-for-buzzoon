import 'package:nostrp2p/controller/relay_url_provider.dart/relay_url_provider.dart';
import 'package:nostrp2p/controller/servaddr_provider/servaddr_provider.dart';
import 'package:nostrp2p/external/connection_pool.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_pool_provider.g.dart';

@Riverpod(keepAlive: true)
Future<ConnectionPool> connectionPool(ConnectionPoolRef ref) async {
  //final urls = await ref.watch(relayUrlProvider.future);
  final urls = await ref.watch(servAddrSettingNotifierProvider.future);
  return ConnectionPool(urls.getServAddr!);
}

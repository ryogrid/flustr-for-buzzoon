import 'dart:async';
import 'dart:io';
import 'package:web_socket_channel/status.dart' as status;

import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:nostrp2p/external/stream_wrapper.dart';
import 'package:nostr/nostr.dart';
import 'package:nostrp2p/external/np2p_api.dart';

class ConnectionPool {
  //List<WebSocketChannel> webSockets = <WebSocketChannel>[];
  int lastEvtReceived = -1;

  ConnectionPool(_url) {
    print("ConnectionPool: " + _url);
  }

  void dispose() {
  }

  List<ProfileData> profiles = <ProfileData>[];
  Map<String, ProfileData> profileMap = <String, ProfileData>{};
  bool isAggregatorGenerated = false;
  StreamAggregator _lastGeneratedAggregator = new StreamAggregator();

  Future<void> addEvent(Event e) async {
    this._lastGeneratedAggregator.addEvent(e);
  }

  ProfileData fetchProfile(String pubHex) {
    Np2pAPI.getProfile(pubHex);

    print(pubHex);
    return this.profileMap[pubHex]!;
  }

  // ATTENTION: always returns empty list
  Future<List<Event>> getStoredEvent(
    List<Filter> filters, {
    Duration timeout = const Duration(milliseconds: 500),
  }) async {
    return Future(() => <Event>[]);
  }

  // eose後の,複数relayからのstreamをよしなにまとめるStreamを返す
  StreamAggregator getEventStreamAfterEose(
    List<Filter> filters,
  ) {
    print('getEventStreamAfterEose');
    final aggregator = StreamAggregator();
    this._lastGeneratedAggregator = aggregator;
    this.isAggregatorGenerated = true;

    return aggregator;
  }
}

Event buildTextEvent(String content, String secHex) {
  return Event.from(kind: 1, content: content, privkey: secHex);
}

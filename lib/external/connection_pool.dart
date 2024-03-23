import 'dart:async';
import 'dart:io';
import 'package:web_socket_channel/status.dart' as status;

import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:nostrp2p/external/stream_wrapper.dart';
import 'package:nostr/nostr.dart';
import 'package:nostrp2p/external/np2p_api.dart';

class ConnectionPool {
  // int lastEvtReceived = -1;

  ConnectionPool(_url) {
    print("ConnectionPool: " + _url);
  }

  void dispose() {
  }

  // bool isAggregatorGenerated = false;
  // StreamAggregator _lastGeneratedAggregator = new StreamAggregator();

  // Future<void> addEvent(Event e) async {
  //   this._lastGeneratedAggregator.addEvent(e);
  // }


  StreamAggregator getEventStreamAfterEose(
    List<Filter> filters,
  ) {
    print('getEventStreamAfterEose');
    final aggregator = StreamAggregator();
    // this._lastGeneratedAggregator = aggregator;
    // this.isAggregatorGenerated = true;

    return aggregator;
  }
}

// Event buildTextEvent(String content, String secHex) {
//   return Event.from(kind: 1, content: content, privkey: secHex);
// }

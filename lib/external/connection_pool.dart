import 'dart:async';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'package:buzzoon/controller/profile_provider/profile_provider.dart';
import 'package:buzzoon/external/stream_wrapper.dart';
import 'package:buzzoon/external/subscription.dart';
import 'package:nostr/nostr.dart';
import 'package:buzzoon/external/buzzoon_api.dart';

class ConnectionPool {
  //List<WebSocketChannel> webSockets = <WebSocketChannel>[];
  int lastEvtReceived = -1;

  ConnectionPool(_urls) {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      print(timer.tick);
      if (this._isAggregatorGenerated) {
        final now = DateTime.now();
        final nowUnix = (now.millisecondsSinceEpoch / 1000).toInt();
        int since;
        if (lastEvtReceived == -1) {
          since = nowUnix - 60 * 60 * 24 * 7; // 1 week ago
        } else {
          since = lastEvtReceived;
        }

        var events = await BuzzonAPI.getEvents(since, nowUnix);
        print(events);
        for (var e in events) {
          await this.addEvent(e);
        }
      }
    });

    // TODO: need to set timer periodically call BuzzonAPI::getEvents (ConnectionPool at connection_pool.dart)
    //       and extract ProfileData from Event

    // final completer = Completer<void>();
    // connected = completer.future;
    //
    // //final socketFutures = <Future<WebSocket>>[];
    // final socketFutures = <Future<void>>[];
    // for (final url in _urls) {
    //   //socketFutures.add(WebSocket.connect(url));
    //   try{
    //     var webSocket = WebSocketChannel.connect(Uri.parse(url));
    //     this.webSockets.add(webSocket);
    //     socketFutures.add(webSocket.ready.catchError((e) => print("${e}")));
    //   }catch(e){
    //     // do nothing
    //   }
    // }
    // Future.wait(socketFutures).then(
    //   //(sockets) async {
    //   (voids) async {
    //       //final tmp = sockets.map((e) => (e, e.asBroadcastStream())).toList();
    //       //final tmp = webSockets.map((e) => (e, e.stream)).toList();
    //       final tmp = webSockets.map((e) => (e, e.stream.asBroadcastStream())).toList();
    //       relays = tmp;
    //       completer.complete();
    //     }
    //   //},
    // );
  }


  void dispose() {
    // for (final (socket, _) in relays) {
    //   //socket.close();
    //   socket.sink.close(status.goingAway);
    // }
  }

  // // 接続完了後にresolveされる
  // late Future<void> connected;

  // イベントが降ってくるリレー
  //List<String> _urls;
  //late final List<(WebSocketChannel, Stream<dynamic>)> relays;

  List<Event> _events = <Event>[];
  List<ProfileData> _profiles = <ProfileData>[];
  bool _isAggregatorGenerated = false;
  StreamAggregator _lastGeneratedAggregator = new StreamAggregator();

  Future<void> addEvent(Event e) async {

    // for (final (adder, _) in relays) {
    //   //adder.add(e.serialize());
    //   adder.sink.add(e.serialize());
    // }

    //this._events.add(e);
    this._lastGeneratedAggregator.addEvent(e);
  }

  Future<ProfileData> fetchProfile(String pubHex) async {
    // TODO: refer local profile cache data first (fetchProfile at connection_pool.dart)

    BuzzonAPI.getProfile(pubHex);

    return this._profiles.first;
  }

  // ATTENTION: always returns empty list
  Future<List<Event>> getStoredEvent(
    List<Filter> filters, {
    Duration timeout = const Duration(milliseconds: 500),
  }) async {
    // // websocket接続前に呼ばれたら待つ
    // await connected;
    //
    // // 全部のソケットでeoseまで待つ
    // final subs = <Future<List<Event>>>[];
    // for (final relay in relays) {
    //   subs.add(summariseUntilEose(filters, relay, timeout: timeout));
    // }
    // final overlappingEventsList = <List<dynamic>>[]; //await Future.wait(subs);
    //
    // // 重複を消しつつ集計
    // final events = <Event>[];
    // final ids = <String>{};
    // for (final overlappingEvents in overlappingEventsList) {
    //   for (final event in overlappingEvents) {
    //     if (!ids.contains(event.id)) {
    //       events.add(event);
    //       ids.add(event.id);
    //     }
    //   }
    // }
    //
    // return events;

    //return this._events;
    return Future(() => <Event>[]);
  }

  // eose後の,複数relayからのstreamをよしなにまとめるStreamを返す
  StreamAggregator getEventStreamAfterEose(
    List<Filter> filters,
  ) {
    final aggregator = StreamAggregator();
    this._lastGeneratedAggregator = aggregator;
    this._isAggregatorGenerated = true;

    // // list of functions that closes each subscription by sending Close(subId)
    // final closers = <void Function()>[];
    // // list of functions that cancels each listens on websockets
    // final cancelers = <void Function()>[];
    //
    // for (final relay in relays) {
    //   final subId = generate64RandomHexChars().substring(0, 32);
    //
    //   // prepare for listen
    //   bool eose = false;
    //   final sub = relay.$2.listen((rawMessage) {
    //     final message = Message.deserialize(rawMessage);
    //     switch (message.messageType) {
    //       case MessageType.eose:
    //         if ((message.message as Eose).subscriptionId == subId) {
    //           eose = true;
    //         }
    //         break;
    //       case MessageType.event:
    //         if (eose &&
    //             message.message is Event &&
    //             (message.message as Event).subscriptionId == subId) {
    //           aggregator.addEvent(message.message as Event);
    //         }
    //         break;
    //       default:
    //         // do nothing
    //         break;
    //     }
    //   });
    //   cancelers.add(() {
    //     sub.cancel();
    //   });
    //
    //   // subscription stuff
    //   final req = Request(subId, filters);
    //   //relay.$1.add(req.serialize());
    //   relay.$1.sink.add(req.serialize());
    //   closers.add(() {
    //     //relay.$1.add(Close(subId).serialize());
    //     relay.$1.sink.add(Close(subId).serialize());
    //   });
    // }
    //
    // aggregator.cleanUp = () {
    //   for (final fun in cancelers) {
    //     fun();
    //   }
    //   for (final fun in closers) {
    //     fun();
    //   }
    // };

    return aggregator;
  }
}

Event buildTextEvent(String content, String secHex) {
  return Event.from(kind: 1, content: content, privkey: secHex);
}

// Future<bool> _addEventHelper(
//   WebSocket socket,
//   Stream<dynamic> out,
//   Event e,
// ) async {
//   socket.add(e.serialize());
//   final okCompleter = Completer();
//   var ok = false;
//   out.listen((msg) {
//     final message = Message.deserialize(msg);
//     switch (message.messageType) {
//       case MessageType.ok:
//         ok = true;
//         okCompleter.complete();
//         break;
//       default:
//         break;
//     }
//   });
//   await Future.wait([
//     Future.delayed(const Duration(milliseconds: 1000)),
//     okCompleter.future,
//   ]);
//   return ok;
// }

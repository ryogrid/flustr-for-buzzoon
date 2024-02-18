import 'dart:async';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nostr/nostr.dart';

// eoseまで一つのリレーから値を受け取るオブジェクト
Future<List<Event>> summariseUntilEose(
  List<Filter> filters,
  //(WebSocket, Stream<dynamic>) socket, {
  (WebSocketChannel, Stream<dynamic>) socket, {
  Duration timeout = const Duration(milliseconds: 500),
}) async {
  final subscriptionId = generate64RandomHexChars().substring(0, 32);
  final Completer<void> gotEose = Completer();
  var isEose = false;
  final List<Event> events = <Event>[];

  // 聞く準備
  final sub = socket.$2.listen((rawMessage) {
      final message = Message.deserialize(rawMessage);
      switch (message.messageType) {
        case MessageType.event:
          if (isEose) {
            break;
          }
          final event = message.message as Event;
          if (event.subscriptionId == subscriptionId) {
            // 関係ないのは拾わない
            events.add(event);
          }
          break;
        case MessageType.eose: // eoseが来た瞬間に通信終わり
          final eose = message.message as Eose;
          if (eose.subscriptionId == subscriptionId) {
            gotEose.complete();
            isEose = true;
          }
          break;
        default:
        // do nothing
          break;
      }
    });

    // 通信開始
    final request = Request(subscriptionId, filters);
    //socket.$1.add(request.serialize());
    socket.$1.sink.add(request.serialize());

    // タイムアウトかeoseが来るまで待つ
    await Future.any([gotEose.future, Future.delayed(timeout)]);
    sub.cancel(); // listenやめる
    //socket.$1.add(Close(subscriptionId).serialize()); // subscribeやめる
    socket.$1.sink.add(Close(subscriptionId).serialize()); // subscribeやめる

    // eoseじゃない場合は途中まで来てたのも破棄
    return isEose ? events : [];
  }
//}

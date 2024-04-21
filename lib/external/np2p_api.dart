import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:nostr/nostr.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../const.dart';
import '../http_client_factory.dart'
    if (dart.library.js_interop) '../http_client_factory_web.dart';
import 'np2p_util.dart';

class Np2pAPI {
  static String genRandomHexString([int length = 32]) {
    const String charset = '0123456789abcdef';
    final Random random = Random.secure();
    final String randomStr =  List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    return randomStr;
  }

  static publishPost(String secHex, String pubHex, String url, String content, [List<List<String>>? tags, int? kind = 1]) async {
    final now = DateTime.now();
    final nowUnix = (now.millisecondsSinceEpoch / 1000).toInt();
    var partialEvent = Event.partial();
    partialEvent.kind = kind != null ? kind : 1;
    partialEvent.createdAt = nowUnix;
    partialEvent.pubkey = pubHex;
    partialEvent.content = content;
    partialEvent.tags = tags != null ? tags : [];
    partialEvent.id = partialEvent.getEventId();
    partialEvent.sig = partialEvent.getSignature(secHex);

    print(partialEvent.toJson());
    var resp = await Np2pAPI._request(url + '/publish', partialEvent.toJson());
    print(resp);
  }

  static publishFollowList(String secHex, String pubHex, String url, List<List<String>> followIDs) async {
    final now = DateTime.now();
    final nowUnix = (now.millisecondsSinceEpoch / 1000).toInt();
    var partialEvent = Event.partial();
    partialEvent.kind = 3;
    partialEvent.createdAt = nowUnix;
    partialEvent.pubkey = pubHex;
    partialEvent.content = "";
    partialEvent.tags = followIDs;
    partialEvent.id = partialEvent.getEventId();
    partialEvent.sig = partialEvent.getSignature(secHex);

    var resp = await Np2pAPI._request(url + '/publish', partialEvent.toJson());
    print(resp);
  }

  static publishProfile(String url, String pubHex, String secHex, String name, String about, String picture) async {
    final now = DateTime.now();
    final nowUnix = (now.millisecondsSinceEpoch / 1000).toInt();

    var profileHash = {
      "name": name,
      "about": about,
      "picture": picture
    };
    var content = json.encode(profileHash);

    var partialEvent = Event.partial();
    partialEvent.kind = 0;
    partialEvent.createdAt = nowUnix;
    partialEvent.pubkey = pubHex;
    partialEvent.content = content;
    partialEvent.tags = [];
    partialEvent.id = partialEvent.getEventId();
    partialEvent.sig = partialEvent.getSignature(secHex);

    var resp = await Np2pAPI._request(url + '/publish', partialEvent.toJson());
    print(resp);
  }

  static publishReaction(String secHex, String pubHex, String url, String tgtEvtId, String tgtEvtPubHex, String content) async {
    final now = DateTime.now();
    final nowUnix = (now.millisecondsSinceEpoch / 1000).toInt();
    var partialEvent = Event.partial();
    partialEvent.kind = 7;
    partialEvent.createdAt = nowUnix;
    partialEvent.pubkey = pubHex;
    partialEvent.content = "+";
    partialEvent.tags = [["e", tgtEvtId], ["p", tgtEvtPubHex]];
    partialEvent.id = partialEvent.getEventId();
    partialEvent.sig = partialEvent.getSignature(secHex);

    var resp = await Np2pAPI._request(url + '/publish', partialEvent.toJson());
    print(resp);
  }

  static Future<ProfileData?> fetchProfile(String url, String pubHex) async {
    var filter = Filter(kinds: [0], authors: [pubHex]);
    var resp = await Np2pAPI._request(url + '/req', filter.toJson());
    var profList = (resp["results"] as List).map((e) => Np2pAPI.jsonToEvent(e)).toList();
    if (profList.length > 0) {
      return ProfileData.fromEvent(profList[0]);
    }else{
      return null;
    }
  }

  static Future<Event?> fetchFolloList(String url, String pubHex) async {
    var filter = Filter(kinds: [0], authors: [pubHex]);
    var resp = await Np2pAPI._request(url + '/req', filter.toJson());
    var profEvtList = (resp["results"] as List).map((e) => Np2pAPI.jsonToEvent(e)).toList();
    if (profEvtList.length > 0) {
      return profEvtList[0];
    }else{
      return null;
    }
  }

  // TEMPORAL API
  static gatherData() async {
    // TODO: need to implement Np2pAPI::gatherData
  }

  // use NostP2P specific kind 40000
  static Future<List<Event>> reqEvents(String url, int since, int until) async {
    var filter = Filter(kinds: [40000], since: since, until: until);
    var resp = await Np2pAPI._request(url + '/req', filter.toJson());
    return (resp["results"] as List).map((e) => Np2pAPI.jsonToEvent(e)).toList();
  }

  static Future<List<Event>> reqPost(String url, String eventId, String pubHex) async {
    var filter = Filter(kinds: [1], ids: [eventId], authors: [pubHex]);
    var resp = await Np2pAPI._request(url + '/req', filter.toJson());
    return (resp["results"] as List).map((e) => Np2pAPI.jsonToEvent(e)).toList();
  }


  static Future<Map<String, dynamic>> _request(String destUrl, Object params) async {
    Uri url = Uri.parse(destUrl);
    Map<String, String> headers = {
      'content-type': 'application/json',
      "accept": "application/json",
      "Access-Control-Request-Method": "POST",
      "Access-Control-Request-Private-Network": "true",
    };
    String body = json.encode(params);
    print(body);
    var client = httpClient();
    http.Response resp = await client.post(url, headers: headers, body: body);
    if (resp.statusCode == 200) {
      var retJson = json.decode(resp.body);
      print("receied responses (deserialized)");
      print(retJson);
      return retJson;
    } else {
      return new Future(() => {});
    }
  }

  static Event jsonToEvent(Map<String, dynamic> json) {
    var tags = (json['tags'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
        .toList();
    return Event(
      json['id'],
      json['pubkey'],
      json['created_at'],
      json['kind'],
      tags,
      json['content'],
      json['sig'],
      verify: false,
    );
  }

  static String eventToJson(Event evt) {
    return json.encode(evt.toJson());
  }
}

List<List<String>> constructSpecialPostTags(WidgetRef ref, Event destEvt) {
  var epTagMap = extractEAndPtags(destEvt.tags);
  var eTags = epTagMap["e"];
  var pTags = epTagMap["p"];
  // when destEvt is quote repost, remove all tags for multiple nesting is not supported
  if (classifyPostKind(destEvt) == POST_KIND.QUOTE_REPOST) {
    eTags = [];
    pTags = [];
  }
  if (eTags!.length == 0) {
    // destEvt is root post
    eTags.add(["e", destEvt.id, "", "root"]);
    pTags!.add(["p", destEvt.pubkey]);
    return eTags + pTags;
  }else{
    // destEvt is not root post
    eTags.add(["e", destEvt.id, "", "reply"]);
    pTags!.add(["p", destEvt.pubkey]);
    return eTags + pTags;
  }
}


import 'dart:math';

import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:nostr/nostr.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../http_client_factory.dart'
    if (dart.library.js_interop) '../http_client_factory_web.dart';

class Np2pAPI {
  static String genRandomHexString([int length = 32]) {
    const String charset = '0123456789abcdef';
    final Random random = Random.secure();
    final String randomStr =  List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
    return randomStr;
  }

  static postEvent(String secHex, String pubHex, String url, String content) async {
    final now = DateTime.now();
    final nowUnix = (now.millisecondsSinceEpoch / 1000).toInt();
    var partialEvent = Event.partial();
    partialEvent.kind = 1;
    partialEvent.createdAt = nowUnix;
    partialEvent.pubkey = pubHex;
    partialEvent.content = content;
    partialEvent.tags = [];
    partialEvent.id = partialEvent.getEventId();
    partialEvent.sig = partialEvent.getSignature(secHex);

    var resp = await Np2pAPI._request(url + '/publish', partialEvent.toJson());
    print(resp);
  }

  static updateProfile(String url, String pubHex, String secHex, String name, String about, String picture) async {
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

  static Future<ProfileData> getProfile(String pubHex) async {
    //BigInt shortPkey
    // TODO: need to implement Np2pAPI::getProfile
    return ProfileData(name: 'name', picture: 'picture', about: 'about', pubHex: 'pubHex');
  }

  // TEMPORAL API
  static gatherData() async {
    // TODO: need to implement Np2pAPI::gatherData
  }

  static Future<List<Event>> getEvents(String url, int since, int until) async {
    var filter = Filter(kinds: [40000], since: since, until: until);
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
}
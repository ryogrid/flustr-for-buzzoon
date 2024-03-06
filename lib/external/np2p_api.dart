import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:nostr/nostr.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../http_client_factory.dart'
    if (dart.library.js_interop) '../http_client_factory_web.dart';

class Np2pAPI {
  static postEvent(String content) async {
    var params = {
      "Id": "",
      "Pubkey": "",
      "Created_at": 0,
      "Kind": 1,
      "Tags": [],
      "Content": content,
      "Sig": ""
    };
    var resp = await Np2pAPI._request('http://' + Np2pAPI.serverAddr +  '/sendEvent', params);
    print(resp);
  }

  static updateProfile(String name, String about, String picture) async {
    // TODO: need to implement Np2pAPI::updateProfile
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

  static String serverAddr = '192.168.0.2:20001'; //'localhost:20001';


  static Future<List<Event>> getEvents(int since, int until) async {
    var params = {
      "Id": "",
      "Pubkey": "",
      "Created_at": 0,
      "Kind": 0,
      "Tags": [["since", since.toString()],[ "until", until.toString()]],
      "Content": "getEvents",
      "Sig": ""
    };
    var resp = await Np2pAPI._request('http://' + Np2pAPI.serverAddr +  '/req', params);
    print(resp);
    return (resp["Events"] as List).map((e) => Np2pAPI.jsonToEvent(e)).toList();
  }

  static Future<Map<String, dynamic>> _request(String destUrl, Object params) async {
    Uri url = Uri.parse(destUrl);
    Map<String, String> headers = {'content-type': 'application/json', "accept": "application/json"};
    String body = json.encode(params);
    print(body);
    var client = httpClient();
    //http.Response resp = await http.post(url, headers: headers, body: body);
    http.Response resp = await client.post(url, headers: headers, body: body);
    print(resp);
    if (resp.statusCode == 200) {
      return json.decode(resp.body);
    } else {
      return new Future(() => {});
    }
  }

  static Event jsonToEvent(Map<String, dynamic> json) {
    var tags = (json['Tags'] as List<dynamic>)
        .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
        .toList();
    return Event(
      json['Id'],
      json['Pubkey'],
      json['Created_at'],
      json['Kind'],
      tags,
      json['Content'],
      json['Sig'],
      verify: false,
    );
  }
}
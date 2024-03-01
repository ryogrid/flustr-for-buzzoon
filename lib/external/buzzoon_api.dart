import 'package:buzzoon/controller/profile_provider/profile_provider.dart';
import 'package:nostr/nostr.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BuzzonAPI {
  static postEvent(String content) async {
    // TODO: need to implement BuzzonAPI::postEvent
  }

  static updateProfile(String name, String about, String picture) async {
    // TODO: need to implement BuzzonAPI::updateProfile
  }

  static Future<ProfileData> getProfile(String pubHex) async {
    //BigInt shortPkey
    // TODO: need to implement BuzzonAPI::getProfile
    return ProfileData(name: 'name', picture: 'picture', about: 'about', pubHex: 'pubHex');
  }

  // TEMPORAL API
  static gatherData() async {
    // TODO: need to implement BuzzonAPI::gatherData
  }

  static Future<List<Event>> getEvents(int since, int until) async {
    var resp = await BuzzonAPI._request('http://192.168.0.2:20001/getEvents', {"Since": since, "Until": until});
    print(resp);
    if (resp == null) {
      return [];
    }else{
      return (resp["Events"] as List).map((e) => BuzzonAPI.jsonToEvent(e)).toList();
    }

    //return [Event("0", "0", 0, 0, [["hoge"]], "content", "sig")];
  }

  static Future<Map<String, dynamic>> _request(String destUrl, Object params) async {
    Uri url = Uri.parse(destUrl);
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode(params);
    print(body);
    http.Response resp = await http.post(url, headers: headers, body: body);
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